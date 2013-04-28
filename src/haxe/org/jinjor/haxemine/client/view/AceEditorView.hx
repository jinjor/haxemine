package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.SaveFileDto;
import org.jinjor.haxemine.messages.SaveM;
import org.jinjor.haxemine.messages.FileDetail;

using Lambda;

class AceEditorView {
    
    public function new(editor : Dynamic, socket : Dynamic, session : Session){
        var saveM = new SaveM(socket); 
        session.onEditingFileChange.sub(function(file, line){
            new FileDetailDao().getFile(file.pathFromProjectRoot, function(detail: FileDetail){
                editor.getSession().setValue(detail.text);
                editor.getSession().setMode("ace/mode/" + detail.mode);
                annotateCompileError(editor, session);
                if(line != null){
                    editor.gotoLine(100);
                }
                
            });
        });
    
        session.onLastTaskProgressChanged.sub(function(_){
            annotateCompileError(editor, session);
        });

        editor.commands.addCommands([{
            Name : "savefile",
            bindKey: {
                win : "Ctrl-S",
                mac : "Command-S"
            },
            exec: function(editor) {
                saveFile(saveM, session, editor.getSession().getValue());
            }
        },{//TODO Ctrl-Click
            Name : "jumpToClass",
            bindKey: {
                win : "Ctrl-Q",
                mac : "Command-Q"
            },
            exec: function(editor) {
                var pos = editor.getCursorPosition();
                var value : String = editor.getSession().getTokenAt(pos.row,pos.column).value;
                var charCode = value.charCodeAt(0);
                var startsWithUpper = charCode != null && 65 <= charCode && charCode <= 90;
                if(!startsWithUpper){
                    return;
                }
                var filtered = session.getAllFiles().filter(function(file){
                    var name = file.shortName;
                    var splitted = name.split('.hx');
                    return splitted[0] == value;
                }).array();
                if(filtered.length == 1){
                    session.selectNextFile(filtered[0], null);
                }else if(filtered.length > 1){
                    //TODO
                }
            }
        },{
            Name : "toOlder",
            bindKey: {
                win : "Alt-Left"
            },
            exec: function(editor) {
                session.selectOlderFile();
            }
        },{
            Name : "toNewer",
            bindKey: {
                win : "Alt-Right"
            },
            exec: function(editor) {
                session.selectNewerFile();
            }
        }]);
        /*
        editor.getSession().getSelection().on('changeCursor', function(){
            var pos = editor.getCursorPosition();
            untyped console.log(editor.getSession().getTokenAt(pos.row,pos.column));
            editor.getSession().get
        });*/
        /*
        editor.onCursorChange(function(){
            
        });*/
        
        
        render(editor, "ace/theme/eclipse"); 
    }
    
    private static function annotateCompileError(editor, session : Session) {
        var annotations = session.getCompileErrorsByFile(session.getCurrentFile()).map(function(error){
            return {row:error.row-1, text: error.message, type:"error"};
        }).array();
        editor.getSession().setAnnotations(annotations);
        
    }
    private static function saveFile(saveM : SaveM, session : Session, text : String){
        session.onSave.pub(null);
        saveM.pub(new SaveFileDto(session.getCurrentFile().pathFromProjectRoot, text));
    }
    
    private function render(editor, theme : String) {
        editor.setTheme(theme); 
    }
    
}