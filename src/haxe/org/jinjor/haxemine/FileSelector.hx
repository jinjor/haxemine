package org.jinjor.haxemine;

import js.JQuery;
using Lambda;

class FileSelector {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var template = new HoganTemplate<Dynamic>('
    <div id="#all-haxe-files">
        <ul>
            {{#files}}
            <li><a>data-filePath="{{pathFromProjectRoot}}">{{shortName}}</a></li>
            {{/files}}
        </ul>
    </div>
    ');
    
    public var container : JQuery;
    
    public function new(session : Session, onFileSelected : SourceFile -> Void){
        
        var files = new Hash<SourceFile>();
        session.getAllFiles().foreach(function(f){
            files.set(f.pathFromProjectRoot, f);
            return true;
        });
        this.container = JQ('<div/>').on('click li', function(){
            var file = files.get(JQuery.cur.attr('filePath'));
            onFileSelected(file);
        });
    }
    
    private static function hasCompileError(session : Session, file : SourceFile) : Bool{
        var found = false;
        session.getCompileErrors().foreach(function(error){
            if(error.file == file){
                found = true;
                return false;
            }
            return true;
        });
        return found;
    }
    
    public function render(session : Session){
        container.html(template.render({
            files: session.getAllFiles(),
            hasCompileError: function(file : SourceFile){
                return hasCompileError(session, file);
            }
        
        }));
    }
    
}