var express = require('express');
var fs      = require('fs')
var sys     = require('sys');
var http = require('http');
var path = require('path');
var socketio = require('socket.io');
//var watch = require('./lib/watch.js');
var childProcess = require('child_process');
var async = require('async');


var CONF_FILE = 'haxemine.json';
var print = function(s, author){
  console.log((author || 'haxemine') + ' > ' + s);
}

if(!path.existsSync('haxemine.json')){
  print('haxemine.json is required in current directory.');
  process.exit(1);
}


var projectRoot = '.';
var conf = JSON.parse(fs.readFileSync(projectRoot + '/' + CONF_FILE, 'utf8'));
var port = conf && conf.port || 8765;
print('projectRoot:' + projectRoot);
print('port:' + port);


var app = express();

app.configure(function(){
  app.set('port', port);
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.get('/', function(req, res){
  res.writeHead(200, {'Content-Type': 'text/html'});
  var rs = fs.createReadStream(__dirname + '/index.html');
  sys.pump(rs, res);
});
app.get('/test', function(req, res){
  res.writeHead(200, {'Content-Type': 'text/html'});
  var rs = fs.createReadStream('SpecRunner.html');
  sys.pump(rs, res);
});
app.get('/src', function(req, res){
  var fileName = req.query.fileName;
  if(!fileName){
    res.send();
  }else{
    res.contentType('application/json');
    //console.log(req.query.fileName);
    res.send(JSON.stringify(findFromSrc(projectRoot + '/' + fileName)));
  }
});

server = http.createServer(app);
server.listen(app.get('port'), function(){
  console.log("haxemine listening on port " + app.get('port'));
});

var io = socketio.listen(server, {'log level': 1});

io.sockets.on('connection', function(socket) {
  console.log("connection");
  getAllHaxeFiles(projectRoot, function(err, files){
    if(err){
      console.log(err);
      throw err;
    }
    
    socket.emit('all-haxe-files', files);
  });
  
  socket.on('save', function(data) {
    if(!data.fileName){
      console.log(data);
      throw "bad request."
    }
    
    saveToSrc(projectRoot + '/'+ data.fileName, data.text);
    socket.emit('stdout', 'saved');
    
    var tasks = conf.hxml.map(function(hxml){
      var task = createCompileHaxeTask(socket, projectRoot, hxml.path);
      return task;
    });
    async.series(tasks, function(){});
    
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

var createCompileHaxeTask = function(socket, projectRoot, hxmlPath){
  return function(callBack){
    compileHaxe(socket, projectRoot, hxmlPath, callBack);
  };
}

var compileHaxe = function(socket, projectRoot, hxmlPath, callBack){
  childProcess.exec('haxe ' + hxmlPath, {
    cwd: projectRoot
  },function(err, stdout, stderr){
    err || print(stdout, hxmlPath);
    err && print(stderr, hxmlPath);
    socket.emit('stdout', stdout);
    
    var compileError = err ? stderr : '';
    socket.emit('haxe-compile-err', compileError);
    callBack(err);
  });
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



