package org.jinjor.haxemine;


import js.JQuery;
using Lambda;

class CompileErrorPanel {

    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var template = new HoganTemplate<Dynamic>('
        <ul>
            {{#errors}}
            <li><a data-filePath="{{file.pathFromProjectRoot}}">{{originalMessage}}</a></li>
            {{/errors}}
        </ul>
    ');
    
    public var container: JQuery;
    
    public function new(container : JQuery, session : Session){
        this.container = (untyped container).on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            session.selectNextFile(file);
        });
        session.onCompileErrorsChanged(function(){
            render(session);
        });
    }
    
    private function render(session : Session){
        container.html(template.render({
            errors : session.getCompileErrors()
        }));
    }
    
}