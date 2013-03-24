package org.jinjor.haxemine.model;

using Lambda;
import js.JQuery;

class AceEditorModel {
    
    public function new(editor : Dynamic, editingFile : EditingFile){
        editingFile.onChange(function(){
            editor.getSession().setValue(editingFile.getText());
            editor.getSession().setMode("ace/mode/" + editingFile.getMode());
        });
        editingFile.onCompileErrorsChanged(function(){
             var annotations = editingFile.getCompileErrors().map(function(error){
                return {row:error.row-1, text: error.message, type:"error"};
            }).array();
            editor.getSession().setAnnotations(annotations);
        });
    }

}