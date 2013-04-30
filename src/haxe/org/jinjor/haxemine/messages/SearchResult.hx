package org.jinjor.haxemine.messages;

class SearchResult {
    
    public var fileName: String;
    public var row: Int;
    public var message : String;

    public function new(fileName, row, message) {
        this.fileName = fileName;
        this.row = row;
        this.message = message;
    }

}