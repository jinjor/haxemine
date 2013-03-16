var express = require('express');
var fs      = require('fs')
var sys     = require('sys');
var http = require('http');
var path = require('path');
var socketio = require('socket.io');
//var watch = require('./lib/watch.js');
var childProcess = require('child_process');
var async = require('async');
var conf = require('./conf.js');

var app = express();

app.configure(function(){
  app.set('port', conf.port);
  //app.set('views', __dirname + '/views');
  //app.set('view engine', 'ejs');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.get('/', function(req, res){
  res.writeHead(200, {'Content-Type': 'text/html'});
  var rs = fs.createReadStream('index.html');
  sys.pump(rs, res);
});
app.get('/test', function(req, res){
  res.writeHead(200, {'Content-Type': 'text/html'});
  var rs = fs.createReadStream('SpecRunner.html');
  sys.pump(rs, res);
});
app.get('/src', function(req, res){
  var fileName = req.query.fileName;
  var projectRoot = conf.project.path;
  if(!fileName){
    res.send();
  }else{
    res.contentType('application/json');
    console.log(req.query.fileName);
    res.send(JSON.stringify(findFromSrc(projectRoot + '/' + fileName)));
  }
});

server = http.createServer(app);
server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

var io = socketio.listen(server, {'log level': 1});

io.sockets.on('connection', function(socket) {
  console.log("connection");
  var projectRoot = conf.project.path;
  
  getAllHaxeFiles(projectRoot, function(err, files){
    socket.emit('all-haxe-files', files);
  });
  
  socket.on('save', function(data) {
    if(!data.fileName){
      console.log(data);
      throw "bad request."
    }
    
    saveToSrc(projectRoot + '/'+ data.fileName, data.text);
    socket.emit('stdout', 'saved');
    childProcess.exec('haxe compile.hxml', {
      cwd: projectRoot
    },function(err, stdout, stderr){
      console.log(stdout);
      socket.emit('stdout', stdout);
      if(err){
        console.log(stderr);
        socket.emit('haxe-compile-err', stderr);
      }
    });
  });
  socket.on('disconnect', function(){
    console.log("disconnect");
  });
});

//logics---------------------------

var findFromSrc = function(fileName){
  console.log(fileName);
  return {
    text: fs.readFileSync(fileName, "utf8"),
    mode: 'haxe'
  };
};
var saveToSrc = function(fileName, text){
  fs.writeFileSync(fileName, text, "utf8");
};



//---------------------------




var walk = function(dir, done) {
  var results = [];
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
      fs.stat(file, function(err, stat) {
        if (stat && stat.isDirectory()) {
          walk(file, function(err, res) {
            results = results.concat(res);
            if (!--pending) done(null, results);
          });
        } else {
          results.push(file);
          if (!--pending) done(null, results);
        }
      });
    });
  });
};

var getAllHaxeFiles = function(projectRoot, _callback){
  
  walk(projectRoot, function(err, results) {
    if (err) {
      _callback(err);
    }else{
      var all = [];
      async.map(results, function(item, callback) {
        if(item.indexOf('.hx') == (item.length - '.hx'.length)){
          callback(null, item.split(projectRoot + '/')[1]);
        }else{
          callback();
        }
      },
      function(err, items) {
        items.forEach(function(item){
          if(item){
            all.push(item);
          }
        });
      });
      _callback(null, all);
    }
  });
};



