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
    
    static var express : Dynamic = Node.require('express');
    static var fs  : Dynamic    = Node.require('fs');
    static var sys     = Node.require('sys');
    static var http = Node.require('http');
    static var path = Node.require('path');
    static var readline = Node.require('readline');
    static var socketio = Node.require('socket.io');
    static var childProcess : Dynamic = Node.require('child_process');
    static var async : Dynamic = Node.require('async');
    static var sourcemap : Dynamic = Node.require('source-map-support');
    
    public static function main(){
        sourcemap.install();
        
        var projectRoot = '.';
        
        var confDao = new HaxemineConfigDao();
        var conf = confDao.get(projectRoot);

        if(conf == null){
            var _process = untyped process;
            confDao.create(_process, projectRoot, function(){
                _process.exit(0);
            },function(){
                _process.exit(0);
            });
        }else{
            startApp(projectRoot, conf);
        }
    }
    
    static function startApp(projectRoot : String, conf : HaxemineConfig){
        
        Console.print('projectRoot:' + projectRoot);
        Console.print('port:' + conf.port);
        
        var taskInfos = conf.hxml.map(function(hxml){
            var name = hxml.path;
            var content = fs.readFileSync(projectRoot + '/' + hxml.path, 'utf8');
            
            return new TaskInfo(name, content, if(hxml.auto == null) true else hxml.auto);
        }).array();
        
        var _path = path;
        var _express = express;
        var app : Dynamic = express();
        trace('hoge-');
        
        untyped console.log(untyped __dirname + '/public/favicon.ico');
        
        app.configure(function(){
          app.set('port', conf.port);
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
            
            saveM.sub('Main.startApp', function(saveFileDto){
                if(saveFileDto.fileName == null){
                  trace(saveFileDto);
                  throw "bad request.";
                }
                Service.save(projectRoot, saveFileDto, allHaxeFilesM, socket);
                Service.doAutoTasks(conf, projectRoot, socket, taskProgressM);
            });
            doTaskM.sub('Main.startApp', function(taskName) {
                Service.doTask(conf, projectRoot, socket, taskProgressM, taskName);
            });
            doTasksM.sub('Main.startApp', function(_) {
                Service.doAutoTasks(conf, projectRoot, socket, taskProgressM);
            });
            socket.on('disconnect', function(){
                Console.print("disconnect");
            });
            
            searchM.sub('Main.startApp', function(word){
                Service.searchWord(word, function(err, result){
                    searchResultM.pub(result);
                });
            });
        });        
    }
    
    
}