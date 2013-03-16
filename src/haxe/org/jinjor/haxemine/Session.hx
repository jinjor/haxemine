package org.jinjor.haxemine;

using Lambda;

class Session {

    private var compileErrors : Array<CompileError>;
    private var editingFiles : HistoryArray<SourceFile>;
    private var allFiles : Hash<SourceFile>;
    
    private var _onAllFilesChanged : Void -> Void;
    private var _onCompileErrorChanged : Void -> Void;
    
    public function new(editingFiles){
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this._onAllFilesChanged = function(){};
        this._onCompileErrorChanged = function(){};
    }
    
    
    public function setCompileErrors(msg : String){
        var messages = msg.split('\n');
        this.compileErrors = messages.map(function(message){
            return new CompileError(message, allFiles.get);
        }).array();
        this._onCompileErrorChanged();
    }
    public function getCompileErrors() : Array<CompileError> {
        return compileErrors;
    }
    public function onCompileErrorChanged(f: Void -> Void){
        var that = this;
        this._onCompileErrorChanged = function(){
            f();
            that._onCompileErrorChanged();
        }
    }

    
    public function setAllFiles(allFiles){
        this.allFiles = allFiles;
        this._onAllFilesChanged();
    }
    public function getAllFiles() : Hash<SourceFile>{
        return allFiles;
    }
    public function onAllFilesChanged(f: Void -> Void){
        var that = this;
        this._onAllFilesChanged = function(){
            f();
            that._onAllFilesChanged();
        }
    }
    
    
}