package org.jinjor.haxemine;

import js.JQuery;
using Lambda;

class FileSelector {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var template = new HoganTemplate<Dynamic>('
        <ul>
            {{#files}}
            <li><a data-filePath="{{pathFromProjectRoot}}">{{shortName}}</a></li>
            {{/files}}
        </ul>
    ');
    
    public var container : JQuery;
    
    public function new(session : Session){
        var that = this;
        
        this.container = JQ('<div id="all-haxe-files"/>').on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            session.selectNextFile(file);
        });
        
        session.onCompileErrorChanged(function(){
            that.render(session);
        });
        session.onAllFilesChanged(function(){
            that.render(session);
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
        untyped console.log(session);
        var fs : Array<Dynamic> = [];
        for(f in session.getAllFiles()){
            fs.push(f);
        }
        untyped console.log(fs);
        container.html(template.render({
            files: fs,
            hasCompileError: function(file : SourceFile){
                return hasCompileError(session, file);
            }
        }));
    }
    
}