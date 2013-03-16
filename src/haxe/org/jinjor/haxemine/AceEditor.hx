package org.jinjor.haxemine;

using Lambda;

class AceEditor {
    
    private static var template = new HoganTemplate<Dynamic>('
    <div id="editor"></div>
    ');

    public var pathFromProjectRoot : String;
    public var shortName : String;
    
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
                saveFile(editor, '');//TODO currentFilePath
            }
        });
        this.editor = editor;
        
        var that = this;
        session.onEditingFileChanged(function(){
            that.render(session);
        });
        
        session.selectNextFile(session.getCurrentFile());
    }
    
    public function render(session : Session){
        var file = session.getCurrentFile();
         if(file == null){
            return;
        }
        new SourceFileDao().getFile(file.pathFromProjectRoot, function(file){
            if(file == null){
                return;
            }
            var text = file.text;
            editor.getSession().setValue(text);
            editor.getSession().setMode("ace/mode/" + file.mode);
            
            var annotations = session.getCompileErrors().filter(function(error){
            untyped console.log(file);
                return error.originalMessage.indexOf(file.pathFromProjectRoot) == 0;
            }).map(function(error){
                return {row:error.row-1, text: error.message, type:"error"};
            });
            editor.getSession().setAnnotations(annotations);
        });
    }
    
}