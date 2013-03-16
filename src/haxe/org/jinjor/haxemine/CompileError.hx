package org.jinjor.haxemine;

class CompileError {
    
    private static function parseCompileErrorMessage(message){
        var elms = message.split(':');
        trace(elms);        
        return {
          path: elms[0],
          row: Std.parseInt(elms[1]),
          message: elms[elms.length-1]
        };//TODO
    }
    
    public var originalMessage : String;
    public var file : SourceFile;
    public var row : Int;
    public var message : String;
    
    public function new(originalMessage, filePathToFile : String -> SourceFile){
        this.originalMessage = originalMessage;
        var parsed = parseCompileErrorMessage(originalMessage);
        this.file = filePathToFile(parsed.path);
        this.row = parsed.row;
        this.message = parsed.message;
    }
    
    
}