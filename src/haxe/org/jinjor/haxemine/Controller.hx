package org.jinjor.haxemine;

import js.JQuery;
using Lambda;

class Controller {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}

    //private var session : Session;
    
    public function new(socket : Dynamic, ace : Dynamic){
        var session = new Session(new HistoryArray<SourceFile>(10, SourceFile.equals));
        var fileSelector = new FileSelector(session);
        
        
        socket.on('connect', function(msg) {
            trace("connected.");
        });
        socket.on('stdout', function(msg) {
            trace(msg);
        });
        socket.on('all-haxe-files', function(filesPaths : Array<String>) {
            var files = new Hash<SourceFile>();
            filesPaths.foreach(function(f){
                files.set(f, new SourceFile(f));
                return true;
            });
            
            session.setAllFiles(files);
        });
        socket.on('haxe-compile-err', function(msg) {
            trace('error found: ' + msg);
            session.setCompileErrors(msg);
        });
        
        new JQuery(js.Lib.document).ready(function(e){
            JQ('body')
            .append(fileSelector.container)
            .append(JQ('<div id="all-tests"></div>'))
            .append(JQ('<div id="editor"></div>'))
            .append(JQ('<hr/>'))
            .append(JQ('<div id="compile-errors"></div>'));
            fileSelector.render(session);
            
            var aceEditor = new AceEditor(ace, session, socket);
            
            var setCompileErrors = function(){
        
        //status側
        var container = $('#compile-errors').empty();
        session.getCompileErrors().forEach(function(error){
          container.append($('<a/>').text(error.originalMessage).click(function(){
            var path = parseCompileErrorMessage(error.originalMessage).path;
            loadFile(path);
          }));
        });
      };
      
        });
    }
    
}