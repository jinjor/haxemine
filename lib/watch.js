// Copyright 2010-2011 Mikeal Rogers
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

var sys = require('util')
  , fs = require('fs')
  , path = require('path')
  , events = require('events')
  ;

function walk (dir, options, callback) {
  if (!callback) {callback = options; options = {}}
  if (!callback.files) callback.files = {};
  if (!callback.pending) callback.pending = 0;
  callback.pending += 1;
  fs.stat(dir, function (err, stat) {
    if (err) return callback(err);
    callback.files[dir] = stat;
    fs.readdir(dir, function (err, files) {
      if (err) return callback(err);
      callback.pending -= 1;
      files.forEach(function (f, index) {
        f = path.join(dir, f);
        callback.pending += 1;
        fs.stat(f, function (err, stat) {
          var enoent = false
            , done = false;

          if (err) {
            if (err.code !== 'ENOENT') {
              return callback(err);
            } else {
              enoent = true;
            }
          }
          callback.pending -= 1;
          done = callback.pending === 0;
          if (!enoent) {
            if (options.filter && options.filter(f, stat)) return done && callback(null, callback.files);
            callback.files[f] = stat;
            if (stat.isDirectory()) walk(f, options, callback);
            if (done) callback(null, callback.files);
          }
        })
      })
      if (callback.pending === 0) callback(null, callback.files);
    })
    if (callback.pending === 0) callback(null, callback.files);
  })

}
exports.watchTree = function ( root, options, callback ) {
  if (!callback) {callback = options; options = {}}
  walk(root, options, function (err, files) {
    if (err) throw err;
    var fileWatcher = function (f) {
      try {
        fs.watch(f, options, function() {
          fs.stat(f, function(err, c) {
            var p = sys._extend({}, files[f]);
            if (err && err.code === 'ENOENT') {
              // unwatch removed files.
              delete files[f];
              callback(f, null, p);
            } else {
              files[f] = c;
              // console.log(c);
              if (!files[f].isDirectory()) callback(f, c, p);
              else {
                fs.readdir(f, function (err, nfiles) {
                  if (err) return;
                  nfiles.forEach(function (b) {
                    var file = path.join(f, b);
                    if (!files[file]) {
                      fs.stat(file, function (err, stat) {
                        callback(file, stat, null);
                        files[file] = stat;
                        fileWatcher(file);
                      });
                    }
                  });
                });
              }
            }
          });
        });
      } catch (e) {
        if (err && err.code === 'ENOENT') {
          // unwatch removed files.
          delete files[f];
          callback(f, null, p);
        }
      }
    };
    fileWatcher(root);
    for (var i in files) {
      fileWatcher(i);
    }
    callback(files, null, null);
  })
}