package org.jinjor.haxemine.client;

import js.JQuery;
using Lambda;

class CompileErrorPanel {

    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}
    
    private static var template = new HoganTemplate<Dynamic>('
        <ul>
            {{#errors}}
            <li><a data-filePath="{{path}}">{{originalMessage}}</a></li>
            {{/errors}}
        </ul>
    ');
    
    public var container: JQuery;
    private var errorContainer: JQuery;
    
    public function new(socket : Dynamic, session : Session){
        this.container = JQ('<div id="compile-error-panel"/>');
        this.errorContainer = JQ('<div id="compile-errors"/>').on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            session.selectNextFile(file);
        });
        var taskListViewContainer = new TaskListView(socket, session).container;
        
        this.container
            .append(taskListViewContainer)
            .append(errorContainer);
        
        session.onCompileErrorsChanged.sub(function(_){
            render(session);
        });
    }
    
    private function render(session : Session){
        errorContainer.html(template.render({
            errors : session.getCompileErrors()
        }));
    }
    
}