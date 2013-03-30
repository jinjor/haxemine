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
        var fileSelectorContainer = JQ('<div id="all-haxe-files"/>');
        var aceContainer = JQ('<div id="editor"/>');
        var compileErrorPanelContainer = JQ('<div id="compile-errors"/>');
        
        container
        .append(fileSelectorContainer)
        //.append(JQ('<div id="all-tests"><a>hoge</a></div>'))
        //.append(JQ('<div id="all-tests"></div>'))
        .append(aceContainer)
        .append(JQ('<hr/>'))
        .append(compileErrorPanelContainer);
        //↑先に作っているのはACEの都合
        
        var editor = ace.edit("editor");
        
        new FileSelector(fileSelectorContainer, session);
        new AceEditorView(editor, session);
        new CompileErrorPanel(compileErrorPanelContainer, session);
    }
    
    
}