var express = require('express');
var fs      = require('fs')
var sys     = require('sys');
var http = require('http');
var path = require('path');
var socketio = require('socket.io');
var watch = require('./watch.js');

var app = express();

app.configure(function(){
  app.set('port', 8765);
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
app.get('/src', function(req, res){
  res.contentType('application/json');
  res.send(JSON.stringify(findFromSrc(req.query.fileName)));
});

server = http.createServer(app);
server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

var io = socketio.listen(server);

io.sockets.on('connection', function(socket) {
  console.log("connection");
  socket.on('save', function(data) {
    saveToSrc(data.fileName, data.text);
  });
  
  socket.on('disconnect', function(){
    console.log("disconnect");
  });
});

//logics---------------------------

var findFromSrc = function(fileName){
  return {
    text: fs.readFileSync(fileName, "utf8"),
    mode: 'haxe'
  };
};
var saveToSrc = function(fileName, text){
  console.log(fs.writeFileSync(fileName, text, "utf8"));
};








