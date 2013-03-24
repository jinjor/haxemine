package org.jinjor.haxemine.model;

class SourceFile {

    public var pathFromProjectRoot : String;
    public var shortName : String;
    
    public static function equals(o1 : SourceFile, o2 : SourceFile){
        if(o1 == null || o2 == null){
            return false;
        }
        return o1.pathFromProjectRoot == o2.pathFromProjectRoot;
    }
    
    public function new(pathFromProjectRoot){
        this.pathFromProjectRoot = pathFromProjectRoot;
        var splitted = pathFromProjectRoot.split('/');
        this.shortName = splitted[splitted.length-1];
    }
    
}