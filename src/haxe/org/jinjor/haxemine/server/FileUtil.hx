package org.jinjor.haxemine.server;

import js.Node;

class FileUtil {
    
    static var async : Dynamic = Node.require('async');
    static var fs : Dynamic = Node.require('fs');

    private function new() {
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
}