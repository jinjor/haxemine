package org.jinjor.haxemine.server;

class SaveFileDto {
    public var fileName: String;
    public var text: String;
    
    public function new(fileName, text){
        this.fileName = fileName;
        this.text = text;
    }
}