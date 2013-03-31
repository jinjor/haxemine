package org.jinjor.haxemine.client;

import js.JQuery;
using Lambda;

class View {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}

    private var ace : Dynamic;
    private var session : Session;
    
    public function new(session : Session, ace : Dynamic){
        this.ace = ace;
        this.session = session;
        //session.selectNextFile(session.getCurrentFile());
    }
    
    public function render(container : JQuery){
        var compileErrorPanelContainer = new CompileErrorPanel(session).container;
        var menuContainer = new Menu(session).container;
        var fileSelectorContainer = new FileSelector(session).container;
                
        container
        .append(menuContainer)
        .append(fileSelectorContainer)
        .append(JQ('<div id="editor"/>'))
        .append(JQ('<hr/>'))
        .append(compileErrorPanelContainer);
        
        var editor = ace.edit("editor");
        new AceEditorView(editor, session);//ACEだけは後
        
    }
    
    
}