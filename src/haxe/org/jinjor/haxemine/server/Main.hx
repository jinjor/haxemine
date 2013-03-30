package org.jinjor.haxemine.server;

import haxe.Json;
import js.Node;
import org.jinjor.haxemine.model.CompileError;
import org.jinjor.haxemine.model.HistoryArray;
import org.jinjor.haxemine.model.SourceFile;
import org.jinjor.haxemine.model.FileDetail;

using Lambda;
using org.jinjor.util.Util;

typedef Conf = {
    port : Int,
    hxml : Array<Dynamic>
}

class Main {
    
    private static function print(s, ?author : String){
      untyped console.log(author.or('haxemine') + ' > ' + s);
    }
    
    public static function main(){
        
        var express : Dynamic = Node.require('express');
        var fs  : Dynamic    = Node.require('fs');
        var sys     = Node.require('sys');
        var http = Node.require('http');
        var path = Node.require('path');
        var socketio = Node.require('socket.io');
        //var watch = Node.require('./lib/watch.js');
        var childProcess = Node.require('child_process');
        var async : Dynamic = Node.require('async');
        
        
        var CONF_FILE = 'haxemine.json';
        
        
        if(!path.existsSync('haxemine.json')){
          print('haxemine.json is required in current directory.');
          untyped process.exit(1);
        }
        
        
        var projectRoot = '.';
        var conf : Conf = Json.parse(fs.readFileSync(projectRoot + '/' + CONF_FILE, 'utf8'));
        var port = conf.port.or(8765);
        print('projectRoot:' + projectRoot);
        print('port:' + port);
        
        
        var app : Dynamic = express();
        
        app.configure(function(){
          app.set('port', port);
          app.use(express.favicon());
          app.use(express.logger('dev'));
          app.use(express.bodyParser());
          app.use(express.methodOverride());
          app.use(app.router);
          app.use(js.Lib.eval("express.static(path.join(__dirname, 'public'))"));
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
            res.send(Json.stringify(findFromSrc(fs, projectRoot + '/' + fileName)));
          }
        });
        
        var server : Dynamic = http.createServer(app);
        server.listen(app.get('port'), function(){
          print("haxemine listening on port " + app.get('port'));
        });
        
        var io = socketio.listen(server, {'log level': 1});
        
        io.sockets.on('connection', function(socket : Dynamic) {
          print("connection");
          getAllHaxeFiles(async, fs, projectRoot, function(err, filePaths : Array<String>){
            if(err != null){
              trace(err);
              throw err;
            }
            trace(filePaths);
            
            var files : Dynamic<SourceFile> = {};
            filePaths.foreach(function(f){
                untyped {files[f] = new SourceFile(f);}
                return true;
            });
            
            socket.emit('all-haxe-files', files);
            
          });
          
          var doTasks = function(){
            var tasks = conf.hxml.map(function(hxml){
              var task = createCompileHaxeTask(childProcess, socket, projectRoot, hxml.path);
              return task;
            }).array();
            async.series(tasks, function(){});
          };
          
          socket.on('save', function(data) {
            if(data.fileName == null){
              trace(data);
              throw "bad request.";
            }
            saveToSrc(fs, projectRoot + '/'+ data.fileName, data.text);
            socket.emit('stdout', 'saved');
            doTasks();
          });
          socket.on('doTasks', function() {
            doTasks();
          });
          socket.on('disconnect', function(){
            print("disconnect");
          });
        });
        
    }
    
    //logics---------------------------
    
    static function findFromSrc(fs, fileName) : FileDetail {
      untyped console.log(fileName);
      return new FileDetail(fs.readFileSync(fileName, "utf8"), 'haxe');
    }
    static function saveToSrc(fs, fileName, text){
      fs.writeFileSync(fileName, text, "utf8");
    }
    
    static function createCompileHaxeTask(childProcess, socket, projectRoot, hxmlPath){
      return function(callBack){
        compileHaxe(childProcess, socket, projectRoot, hxmlPath, callBack);
      };
    }
    
    static function compileHaxe(childProcess, socket, projectRoot, hxmlPath, callBack){
      childProcess.exec('haxe ' + hxmlPath, {
        cwd: projectRoot
      },function(err, stdout, stderr){
          if(err != null){
              print(stderr, hxmlPath);
          }
        //err.or(print(stdout, hxmlPath));
        //err.and(print(stderr, hxmlPath));
        socket.emit('stdout', stdout);
        
        var msg = if(err != null) stderr else '';
        
        var messages = msg.split('\n');
        var compileErrors = messages.map(function(message){
            return new CompileError(message);
        }).array();
        
        socket.emit('haxe-compile-err', compileErrors);
        callBack(err);
      });
    }
    
    //---------------------------

    static function walk(fs, dir, done) : Void {
      var results = [];
      fs.readdir(dir, function(err, list) {
        if (err != null) return done(err, null);
        var pending : Int = list.length;
        if (pending == 0) return done(null, results);
        list.forEach(function(file) {
          file = dir + '/' + file;
          fs.stat(file, function(err, stat) {
            if (stat != null && stat.isDirectory()) {
              walk(fs, file, function(err, res) {
                results = results.concat(res);
                if (--pending == 0) done(null, results);
              });
            } else {
              results.push(file);
              if (--pending == 0) done(null, results);
            }
          });
          return true;
        });
        return;
      });
    }
    
    static function getAllHaxeFiles(async, fs, projectRoot : String, _callback){
      untyped console.log(projectRoot);
      walk(fs, projectRoot, function(err, results) {
        if (err != null) {
          _callback(err, null);
        }else{
          var all = [];
          async.map(results, function(item : String, cb) {
            if(item.indexOf('.hx') == (item.length - '.hx'.length)){
              cb(null, item.split(projectRoot + '/')[1]);
            }else{
              cb(null, null);
            }
          },
          function(err, items) {
            items.forEach(function(item){
              if(item != null){
                all.push(item);
              }
            });
          });
          _callback(null, all);
        }
      });
    }
}