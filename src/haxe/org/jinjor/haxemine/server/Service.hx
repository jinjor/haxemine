package org.jinjor.haxemine.server;

import js.Node;
import org.jinjor.haxemine.messages.SearchResult;
import org.jinjor.haxemine.messages.FileDetail;
import org.jinjor.haxemine.messages.SourceFile;
import org.jinjor.haxemine.messages.TaskProgress;
import org.jinjor.haxemine.messages.CompileError;
import org.jinjor.haxemine.messages.SaveM;
import org.jinjor.haxemine.messages.AllHaxeFilesM;
import org.jinjor.haxemine.messages.TaskProgressM;

using Lambda;
using StringTools;
using org.jinjor.util.Util;

class Service {
    
    static var fs  : Dynamic    = Node.require('fs');
    static var childProcess : Dynamic = Node.require('child_process');
    static var async : Dynamic = Node.require('async');
    static var path : Dynamic = Node.require('path');

    private function new() {
    }
    
    public static function save(projectRoot : String, data, allHaxeFilesM : AllHaxeFilesM, socket:Dynamic){
        var _path = projectRoot + '/'+ data.fileName;
        var isNew = !path.existsSync(_path);
        Service.saveToSrc(fs, _path, data.text);
        if(isNew){
            Service.getAllHaxeFiles(projectRoot, function(err, files : Dynamic<SourceFile>){
                if(err != null){
                    trace(err);
                    throw err;
                }
                allHaxeFilesM.pub(files);
            });
        }
        socket.emit('stdout', 'saved');
    }
    
    public static function doTask(conf : HaxemineConfig, projectRoot, socket, taskProgressM : TaskProgressM, taskName : String){
        var tasks = conf.hxml.filter(function(hxml){
            return hxml.path == taskName;
        }).map(function(hxml){
            var task = Service.createCompileHaxeTask(socket, taskProgressM, projectRoot, hxml.path);
            return task;
        }).array();
        async.series(tasks, function(){});
    }
          
    public static function doAutoTasks(conf : HaxemineConfig, projectRoot, socket, taskProgressM : TaskProgressM){
        var tasks = conf.hxml.filter(function(hxml){
            return hxml.auto != null && hxml.auto;
        }).map(function(hxml){
            var task = Service.createCompileHaxeTask(socket, taskProgressM, projectRoot, hxml.path);
            return task;
        }).array();
        async.series(tasks, function(){});
    }
    
    public static function searchWord(word : String, cb : Dynamic -> Array<SearchResult> -> Void) {
        if(!OS.isWin()){
            throw 'not supported search.';
        }else{
            var command = 'findstr /S ' + word + ' *.hx';
            Console.print(command);
            childProcess.exec(command, function(err, stdout:String, stderr){
                if(err != null){
                    cb(null, []);
                }else{
                    var messages = stdout.split('\n');
                    var results = messages.filter(function(message){
                        return message != '';
                    }).map(function(message){
                        var fileName = message.split(':')[0].replace('\\', '/');
                        return new SearchResult(fileName, message);
                    }).array();
                    cb(null, results);
                }
            });
        }
    }
    
    public static function findFromSrc(fileName) : FileDetail {
      untyped console.log(fileName);
      return new FileDetail(fs.readFileSync(fileName, "utf8"), 'haxe');
    }
    public static function saveToSrc(fs, fileName, text){
        fs.writeFileSync(fileName, text, "utf8");
    }
    
    public static function createCompileHaxeTask(socket, taskProgressM : TaskProgressM, projectRoot, hxmlPath){
      return function(callBack){
        compileHaxe(socket, taskProgressM, projectRoot, hxmlPath, callBack);
      };
    }
    
    public static function compileHaxe(socket, taskProgressM : TaskProgressM, projectRoot : String, hxmlPath, callBack){
      childProcess.exec('haxe ' + hxmlPath, {
        cwd: projectRoot
      },function(err, stdout, stderr){
          if(err != null){
             Console.print(stderr, hxmlPath);
          }
        //err.or(print(stdout, hxmlPath));
        //err.and(print(stderr, hxmlPath));
        socket.emit('stdout', stdout);
        
        var compileErrors = if(err){
            var msg = stderr;
            var messages = msg.split('\n');
            var compileErrors = messages.map(function(message){
                if(message.startsWith('./')){
                    message = message.substring('./'.length);
                }
                return new CompileError(message);
            }).array();
            compileErrors;
        }else{
            [];
        }
        taskProgressM.pub(new TaskProgress(hxmlPath, compileErrors));
        callBack(err);
      });
    }
    
    
    
    
    //---------------------------

    public static function walk(dir, done) : Void {
      var results = [];
      fs.readdir(dir, function(err, list) {
        if (err != null) return done(err, null);
        var pending : Int = list.length;
        if (pending == 0) return done(null, results);
        list.forEach(function(file) {
          file = dir + '/' + file;
          fs.stat(file, function(err, stat) {
            if (stat != null && stat.isDirectory()) {
              walk(file, function(err, res) {
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
    
    public static function getAllHaxeFiles(projectRoot : String, _callback : Dynamic -> Dynamic<SourceFile> -> Void){
        var filter = function(item : String){
            return item.endsWith('.hx');
        };
        getAllMatchedFiles(projectRoot, filter, function(err, filePaths){
            if(err){
                _callback(err, null);
            }else{
                var files : Dynamic<SourceFile> = {};
                filePaths.foreach(function(f){
                    untyped {files[f] = new SourceFile(f);}
                    return true;
                });
                _callback(null, files);
            }
        });
    }
    public static function getAllHxmlFiles(projectRoot : String, _callback){
        var filter = function(item : String){
            return item.endsWith('.hxml');
        };
        getAllMatchedFiles(projectRoot, filter, _callback);
    }
    
    public static function getAllMatchedFiles(root : String, filter:String -> Bool, _callback){
      walk(root, function(err, results) {
        if (err != null) {
          _callback(err, null);
        }else{
          var all = [];
          async.map(results, function(item : String, cb) {
            if(filter(item)){
              cb(null, item.split(root + '/')[1]);
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