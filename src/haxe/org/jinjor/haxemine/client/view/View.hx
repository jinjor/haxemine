package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.AllMessages;

using Lambda;

class View {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}

    private var ace : Dynamic;
    private var socket : Dynamic;
    private var session : Session;
    
    public function new(ace : Dynamic, socket, session : Session){
        this.ace = ace;
        this.socket = socket;
        this.session = session;
    }
    
    public function render(container : JQuery) {
        
        var viewPanel = new ViewPanel(session, new AllMessages(socket));
        
        var menuContainer = new Menu(session).container;
        var fileSelectorContainer = new FileSelector(socket, session).container;
        var rightPanel = JQ('<div id="right"/>')
            .append(JQ('<div id="editor"/>'))
            .append(JQ('<hr/>'))
            .append(viewPanel.container);
                
        container
        .append(menuContainer)
        .append(fileSelectorContainer)
        .append(rightPanel).keydown(function(e){
            if(e.altKey && e.keyCode == 37){
                session.editingFiles.cursorToOlder();
                return false;
            }else if(e.altKey && e.keyCode == 39){
                session.editingFiles.cursorToNewer();
                return false;
            }else{
                return true;
            }
        });
        
        
        var editor = ace.edit("editor");
        new AceEditorView(editor, socket, session);//ACEだけは後
    }
    
    
}