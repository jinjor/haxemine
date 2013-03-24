package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.EditingFile;
import org.jinjor.haxemine.model.AceEditorModel;

import js.JQuery;
using Lambda;

class AceEditorView {
    
    
    public function new(editor : Dynamic, session){
        new AceEditorModel(editor, new EditingFile(session));//既にバインド済
        
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
    
    private function render(editor, theme : String) {
        editor.setTheme(theme); 
    }
    
}