package org.jinjor.haxemine.client;

import js.JQuery;
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
        
        var taskListViewContainer = new TaskListView(socket, session).container;
        var compileErrorPanelContainer = new CompileErrorPanel(session).container;
        var menuContainer = new Menu(session).container;
        var fileSelectorContainer = new FileSelector(session).container;
                
        container
        .append(menuContainer)
        .append(taskListViewContainer)
        .append(fileSelectorContainer)
        .append(JQ('<div id="editor"/>'))
        .append(JQ('<hr/>'))
        .append(compileErrorPanelContainer);
        
        var editor = ace.edit("editor");
        new AceEditorView(editor, session);//ACEだけは後
        
    }
    
    
}