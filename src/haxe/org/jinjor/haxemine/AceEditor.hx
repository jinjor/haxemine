package org.jinjor.haxemine;

using Lambda;
import js.JQuery;

class AceEditor {
    
    private static inline function JQ(s: String){ return untyped $(s);}
        
    private var ace : Dynamic;
    private var editor : Dynamic;
    
    public var container: JQuery;
    
    public function new(ace : Dynamic, session : Session, socket : Dynamic){
        this.container = JQ('<div id="editor"/>');

        session.onEditingFileChanged(function(){
            render(session);
        });
        session.onCompileErrorsChanged(function(){
            renderCompileErrors(session);
        });
        session.onDocumentReady(function(){
            editor = ace.edit("editor");
            var saveFile = function(editor, filePath){
                socket.emit('save', {
                    fileName : filePath,
                    text: editor.getSession().getValue()
                });
            };
            editor.commands.addCommand({
                Name : "savefile",
                bindKey: {
                    win : "Ctrl-S",
                    mac : "Command-S"
                },
                exec: function(editor) {
                    saveFile(editor, session.getCurrentFile().pathFromProjectRoot);
                }
            });
            editor.setTheme("ace/theme/eclipse");
        });
        this.ace = ace;
    }
    
    private function renderCompileErrors(session : Session){
        
        var currentFile = session.getCurrentFile();
        var annotations = session.getCompileErrors().filter(function(error){
            return error.originalMessage.indexOf(currentFile.pathFromProjectRoot) == 0
            || error.originalMessage.indexOf('./' + currentFile.pathFromProjectRoot) == 0;
        }).map(function(error){
            return {row:error.row-1, text: error.message, type:"error"};
        }).array();
        
        editor.getSession().setAnnotations(annotations);
    }
    
    private function render(session : Session){
        var currentFile = session.getCurrentFile();
        if(currentFile == null){
            return;
        }
        new SourceFileDao().getFile(currentFile.pathFromProjectRoot, function(file){
            if(file == null){
                return;
            }
            var text = file.text;
            editor.getSession().setValue(text);
            editor.getSession().setMode("ace/mode/" + file.mode);
            renderCompileErrors(session);
        });
    }
    
}