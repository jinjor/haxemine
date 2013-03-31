package org.jinjor.haxemine.client;

import js.JQuery;
using Lambda;

class AceEditorView {
    
    public function new(editor : Dynamic, session : Session){
        
        session.onEditingFileChanged(function(detail){
            editor.getSession().setValue(detail.text);
            editor.getSession().setMode("ace/mode/" + detail.mode);
            annotateCompileErrors(editor, session);
        });
    
        session.onCompileErrorsChanged(function(){
            annotateCompileErrors(editor, session);
        });
        
        editor.commands.addCommand({
            Name : "savefile",
            bindKey: {
                win : "Ctrl-S",
                mac : "Command-S"
            },
            exec: function(editor) {
                session.saveFile(editor.getSession().getValue());
            }
        });
        render(editor, "ace/theme/eclipse"); 
    }
    
    private static function annotateCompileErrors(editor, session:Session){
        var annotations = session.getCompileErrorsByFile(session.getCurrentFile()).map(function(error){
            return {row:error.row-1, text: error.message, type:"error"};
        }).array();
        editor.getSession().setAnnotations(annotations);
    }
    
    private function render(editor, theme : String) {
        editor.setTheme(theme); 
    }
    
}