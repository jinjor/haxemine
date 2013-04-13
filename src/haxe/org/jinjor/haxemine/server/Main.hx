package org.jinjor.haxemine.server;

import haxe.Json;
import js.Node;
import org.jinjor.haxemine.messages.SourceFile;
import org.jinjor.haxemine.messages.TaskInfo;
import org.jinjor.haxemine.messages.InitialInfoDto;
import org.jinjor.haxemine.messages.SaveM;
import org.jinjor.haxemine.messages.SearchM;
import org.jinjor.haxemine.messages.SearchResultM;
import org.jinjor.haxemine.messages.InitialInfoM;
import org.jinjor.haxemine.messages.SaveFileDto;
import org.jinjor.haxemine.messages.AllHaxeFilesM;
import org.jinjor.haxemine.messages.DoTaskM;
import org.jinjor.haxemine.messages.DoTasksM;
import org.jinjor.haxemine.messages.TaskProgressM;

using Lambda;
using StringTools;
using org.jinjor.util.Util;

class Main {
    
    static inline var CONF_FILE = 'haxemine.json';
    
    static var express : Dynamic = Node.require('express');
    static var fs  : Dynamic    = Node.require('fs');
    static var sys     = Node.require('sys');
    static var http = Node.require('http');
    static var path = Node.require('path');
    static var readline = Node.require('readline');
    static var socketio = Node.require('socket.io');
    static var childProcess : Dynamic = Node.require('child_process');
    static var async : Dynamic = Node.require('async');
    
    public static function main(){
        
        var projectRoot = '.';
        var confPath = projectRoot + '/' + CONF_FILE;
        if(!path.existsSync(confPath)){
            Console.print(CONF_FILE + 'is required in current directory.');
            Console.print('create ' + CONF_FILE + ' here? [y/n]');
            
            var rli = readline.createInterface(untyped process.stdin, untyped process.stdout);
    
            rli.on('line', function(cmd) {
                if(cmd == 'y'){
                    Service.getAllHxmlFiles(projectRoot, function(err, files : Array<String>){
                        if(err != null){
                            Console.print(err);
                            throw(err);
                        }
                        files.sort(function(f1 : String, f2 : String){
                            return if(f1.startsWith('build') && f2.startsWith('compile')){
                                1;
                            }else{
                                -1;
                            }
                        });
                        var xhml = files.map(function(file){
                            return {path: file, auto: true};
                        }).array();
                        var conf = new HaxemineConfig(8765, xhml);
                        var confJson = untyped JSON.stringify(conf, null, " ");
                        fs.writeFileSync(confPath, confJson, "utf8");
                        Console.print('created haxemine.conf\n' + confJson);
                        Console.print('modify haxemine.conf and restart haxemine.');
                        untyped process.exit(0);
                    });
                }else if(cmd == 'n'){
                    untyped process.stdin.destroy();
                }
                rli.prompt();
            }).on('close', function () {
                untyped process.stdin.destroy();
            });
            rli.prompt();
        }else{
            startApp(projectRoot);
        }
    }
    
    static function startApp(projectRoot : String){
        var conf : HaxemineConfig = Json.parse(fs.readFileSync(projectRoot + '/' + CONF_FILE, 'utf8'));
        var port = conf.port.or(8765);
        Console.print('projectRoot:' + projectRoot);
        Console.print('port:' + port);
        
        var taskInfos = conf.hxml.map(function(hxml){
            var name = hxml.path;
            var content = fs.readFileSync(projectRoot + '/' + hxml.path, 'utf8');
            return new TaskInfo(name, content, if(hxml.auto == null) true else hxml.auto);
        }).array();
        
        var _path = path;
        var _express = express;
        var app : Dynamic = express();
        
        untyped console.log(untyped __dirname + '/public/favicon.ico');
        
        app.configure(function(){
          app.set('port', port);
          app.use(express.favicon(untyped __dirname + '/public/favicon.ico'));
          app.use(express.logger('dev'));
          app.use(express.bodyParser());
          app.use(express.methodOverride());
          app.use(app.router);
          app.use(js.Lib.eval("_express.static(_path.join(__dirname, 'public'))"));
        });
        
        app.get('/', function(req, res){
          res.writeHead(200, {'Content-Type': 'text/html'});
          var rs = fs.createReadStream(untyped __dirname + '/index.html');
          sys.pump(rs, res);
        });
        app.get('/test', function(req, res){
          res.writeHead(200, {'Content-Type': 'text/html'});
          var rs = fs.createReadStream('SpecRunner.html');
          sys.pump(rs, res);
        });
        app.get('/src', function(req, res : Dynamic){
          var fileName = req.query.fileName;
          if(fileName == null){
            res.send();
          }else{
            res.contentType('application/json');
            trace(req.query.fileName);
            res.send(Json.stringify(Service.findFromSrc(projectRoot + '/' + fileName)));
          }
        });
        
        var server : Dynamic = http.createServer(app);
        server.listen(app.get('port'), function(){
          Console.print("haxemine listening on port " + app.get('port'));
        });
        
        
        var io = socketio.listen(server, {'log level': 1});
        
        io.sockets.on('connection', function(socket : Dynamic) {
            var initialInfoM = new InitialInfoM(socket);
            var allHaxeFilesM = new AllHaxeFilesM(socket);
            var searchResultM = new SearchResultM(socket);
            var searchM = new SearchM(socket);
            var saveM = new SaveM(socket);
            var doTaskM = new DoTaskM(socket);
            var doTasksM = new DoTasksM(socket);
            var taskProgressM = new TaskProgressM(socket);
            
            Console.print("connection");
            Service.getAllHaxeFiles(projectRoot, function(err, files){
                if(err != null){
                    trace(err);
                    throw err;
                }
                initialInfoM.pub(new InitialInfoDto(projectRoot, files, taskInfos, OS.isWin()));
            });
            
            saveM.sub(function(saveFileDto){
                trace(saveFileDto);
                if(saveFileDto.fileName == null){
                  trace(saveFileDto);
                  throw "bad request.";
                }
                Service.save(projectRoot, saveFileDto, allHaxeFilesM, socket);
                Service.doAutoTasks(conf, projectRoot, socket, taskProgressM);
            });
            doTaskM.sub(function(taskName) {
                Service.doTask(conf, projectRoot, socket, taskProgressM, taskName);
            });
            doTasksM.sub(function(_) {
                Service.doAutoTasks(conf, projectRoot, socket, taskProgressM);
            });
            socket.on('disconnect', function(){
                Console.print("disconnect");
            });
            
            searchM.sub(function(word){
                Service.searchWord(word, function(err, result){
                    searchResultM.pub(result);
                });
            });
        });        
    }
    
    
}