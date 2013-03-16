package org.jinjor.haxemine;

using Lambda;

class AceEditor {
    
    private static var template = new HoganTemplate<Dynamic>('
    <div id="editor"></div>
    ');
    
    private var editor : Dynamic;
    
    public function new(ace : Dynamic, session : Session, socket : Dynamic){
        
        var saveFile = function(editor, filePath){
            socket.emit('save', {
                fileName : filePath,
                text: editor.getSession().getValue()
            });
            editor.getSession().clearAnnotations();
            session.setCompileErrors('');
        };
        
        var editor = ace.edit("editor");
        editor.setTheme("ace/theme/eclipse");
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
        this.editor = editor;
        
        var that = this;
        session.onEditingFileChanged(function(){
            that.render(session);
        });
        session.onCompileErrorsChanged(function(){
            that.renderCompileErrors(session);
        });
        
        session.selectNextFile(session.getCurrentFile());
    }
    
    private function renderCompileErrors(session : Session){
        var currentFile = session.getCurrentFile();
        var annotations = session.getCompileErrors().filter(function(error){
            return error.originalMessage.indexOf(currentFile.pathFromProjectRoot) == 0;
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