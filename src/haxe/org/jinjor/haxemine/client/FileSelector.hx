package org.jinjor.haxemine.client;

import js.Lib;
import js.JQuery;
import org.jinjor.haxemine.model.SourceFile;

using StringTools;
using Lambda;
using org.jinjor.util.Util;

class FileSelector {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var classTemplate = new HoganTemplate<Dynamic>(
'package {{_package}};

class {{_class}} {

    public function new() {
        
    }

}'
);
    
    private static var template = new HoganTemplate<Dynamic>('
        {{#dirs}}
        <label class="file_selector_dir">{{name}}</label>
        <ul>
            {{#files}}
            <li><a data-filePath="{{pathFromProjectRoot}}">{{shortName}}</a></li>
            {{/files}}
        </ul>
        {{/dirs}}
    ');
    
    public var container : JQuery;
    
    public function new(session : Session){
        var that = this;
        
        this.container = JQ('<div id="all-haxe-files"/>').on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            session.selectNextFile(file);
        }).on('click', '.file_selector_dir', function(){
            var path = JQuery.cur.text();
            var guessedPackage = path.replace('/', '.');
            var classPath = js.Lib.window.prompt("create new class", guessedPackage + '.');
            if(classPath != null){
                var splittedClass = classPath.split('.');
                var className = splittedClass[splittedClass.length-1];
                if(className == ''){
                    Lib.alert('invalid name');
                }else{
                    var text = classTemplate.render({
                        _package: classPath.substring(0, classPath.length - className.length - 1),
                        _class: className
                    });
                    session.saveNewFile(path + '/' + className + '.hx', text);
                }
            }
            
        });
        
        session.onCompileErrorsChanged(function(){
            that.render(session);
        });
        session.onAllFilesChanged(function(){
            that.render(session);
        });  
    }
    
    private static function hasCompileError(session : Session, file : SourceFile) : Bool{
        var found = false;
        session.getCompileErrors().foreach(function(error){
            if(session.getAllFiles().get(error.path) == file){
                found = true;
                return false;
            }
            return true;
        });
        return found;
    }
    
    public function render(session : Session){
        var dirsHash = new Hash<Dir>();
        var all = session.getAllFiles();
        for(name in all.keys()){
            var dirName = name.substring(0, name.lastIndexOf('/'));
            var f = all.get(name);
            var dir = if(dirsHash.exists(dirName)){
                dirsHash.get(dirName).files.push(f);
            }else{
                var dir = new Dir(dirName);
                dirsHash.set(dirName, dir);
                dir.files.push(f);
            }
        }
        var dirsArray : Array<Dir> = dirsHash.map(function(dir){
            dir.files.sort(function(f1, f2){
                return f1.shortName.compareTo(f2.shortName);
            });
            return dir;
        }).array();
        dirsArray.sort(function(d1, d2){
            return d1.name.compareTo(d2.name);
        });

        container.html(template.render({
            dirs: dirsArray,
            hasCompileError: function(file : SourceFile){
                return hasCompileError(session, file);
            }
        }));
    }    
}

private class Dir {
    
    public var name : String;
    public var files : Array<SourceFile>;
    
    public function new(name){
        this.name = name;
        this.files = [];
    }
    
    
}


