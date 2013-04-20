package org.jinjor.haxemine.client.view;

import js.Lib;
import js.JQuery;
import org.jinjor.haxemine.messages.SourceFile;
import org.jinjor.haxemine.messages.SaveFileDto;
import org.jinjor.haxemine.messages.SaveM;

using StringTools;
using Lambda;
using org.jinjor.util.Util;

class FileSelector {
    
    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}
    
    private static var classTemplate = new HoganTemplate<Dynamic>(
'package {{_package}};

class {{_class}} {

    public function new() {
        
    }

}'
);

    private static var dirTemplate = new HoganTemplate<Dir>('<label class="file_selector_dir">{{name}}</label>');
    private static var filesTemplate = new HoganTemplate<Dir>(
        '<ul>
            {{#files}}
            <li><a data-filePath="{{pathFromProjectRoot}}">{{shortName}}</a></li>
            {{/files}}
        </ul>');
    
    public var container : JQuery;
    
    public function new(socket : Dynamic, session : Session){
        var that = this;
        var saveM = new SaveM(socket);
        this.container = JQ('<div id="all-haxe-files"/>').on('click', 'a', function(){
            var file = session.getAllFiles().get(JQuery.cur.attr('data-filePath'));
            session.selectNextFile(file, null);
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
                    saveNewFile(saveM, session, path + '/' + className + '.hx', text);
                }
            }
            
        });
        
        session.onAllFilesChanged.sub(function(_){
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
    
    private static function saveNewFile(saveM, session : Session, pathFromProjectRoot : String, text : String){
        var dup = false;
        for(file in session.getAllFiles()){
            if(file.pathFromProjectRoot == pathFromProjectRoot){
                dup = true;
                break;
            }
        }
        if(dup){
            Lib.alert(pathFromProjectRoot + ' already exists.');
        }else{
            saveM.pub(new SaveFileDto(pathFromProjectRoot, text));
        }
    }
    
    public function render(session : Session){
        var dirsHash = new Hash<Dir>();
        var all = session.getAllFiles();

        for(name in all.keys()){
            var dirName = name.substring(0, name.lastIndexOf('/'));
            var f = all.get(name);
            if(dirsHash.exists(dirName)){
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
        
        container.empty();
        dirsArray.foreach(function(dir){
            var dirDom : JQuery = JQ(dirTemplate.render(dir));
            var filesDom : JQuery = JQ(filesTemplate.render(dir));
            container.append(new Folder(dirDom, filesDom).container);
            return true;
        });

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


