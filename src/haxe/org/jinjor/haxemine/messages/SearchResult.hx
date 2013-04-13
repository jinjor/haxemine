package org.jinjor.haxemine.messages;

class SearchResult {
    
    public var fileName: String;
    public var message : String;

    public function new(fileName, message) {
        this.fileName = fileName;
        this.message = message;
    }

}