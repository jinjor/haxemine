package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.DoTaskM;
import org.jinjor.haxemine.messages.TaskProgressM;
using Lambda;

class CompileErrorPanel {

    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}
    
    private static var template = new HoganTemplate<Dynamic>('
        <ul>
            {{#errors}}
            <li><a data-filePath="{{path}}", data-row="{{row}}">{{originalMessage}}</a></li>
            {{/errors}}
        </ul>
    ');
    
    public var container: JQuery;
    private var errorContainer: JQuery;
    
    public function new(session : Session, doTaskM : DoTaskM, taskProgressM : TaskProgressM){
        
        this.container = JQ('<div id="compile-error-panel"/>');
        this.errorContainer = JQ('<div id="compile-errors"/>').on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            var row = Std.parseInt(JQuery.cur.attr('data-row'));
            //js.Lib.alert(row);
            session.selectNextFile(file, row);
        });
        var taskListViewContainer = new TaskListView(session, doTaskM, taskProgressM).container;
        
        this.container
            .append(taskListViewContainer)
            .append(errorContainer);
        
        session.onLastTaskProgressChanged.sub('CompileErrorPanel.new', function(_){
            render(session);
        });
    }
    
    private function render(session : Session){
        errorContainer.html(template.render({
            errors : session.getCompileErrors()
        }));
    }
    
}