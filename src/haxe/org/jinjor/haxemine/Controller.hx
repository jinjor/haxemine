package org.jinjor.haxemine;

class Controller {

    //private var session : Session;
    
    public function new(socket : Dynamic){
        var session = new Session(new HistoryArray<SourceFile>(10, SourceFile.equals));
        var fileSelector = new FileSelector(session, function(file){
            //changeFile(f);
        
        });
        
        
        socket.on('connect', function(msg) {
            trace("connected.");
        });
        socket.on('stdout', function(msg) {
            trace(msg);
        });
        socket.on('all-haxe-files', function(files : Hash<SourceFile>) {
            session.setAllFiles(files);
        });
        socket.on('haxe-compile-err', function(msg) {
            trace('error found: ' + msg);
            session.setCompileErrors(msg);
        });
    }
    
}