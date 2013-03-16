package org.jinjor.haxemine;

using Lambda;

class Session {

    private var compileErrors : Array<CompileError>;
    private var editingFiles : HistoryArray<SourceFile>;
    private var allFiles : Hash<SourceFile>;
    private var fileToLoad : SourceFile;
    
    private var _onAllFilesChanged : Array<Void -> Void>;
    private var _onCompileErrorChanged : Array<Void -> Void>;
    private var _onEditingFileChanged : Array<Void -> Void>;
    
    public function new(editingFiles){
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this._onAllFilesChanged = [];
        this._onCompileErrorChanged = [];
        this._onEditingFileChanged = [];
    }
    
    //-> Backbone#get/set/onChange
    public function setCompileErrors(msg : String){
        var messages = msg.split('\n');
        this.compileErrors = messages.map(function(message){
            return new CompileError(message, allFiles.get);
        }).array();
        this._onCompileErrorChanged.foreach(function(f){
            f();
            return true;
        });
    }
    public function getCompileErrors() : Array<CompileError> {
        return compileErrors;
    }
    public function onCompileErrorChanged(f: Void -> Void){
        _onCompileErrorChanged.push(f);
    }

    //-> Backbone#get/set/onChange
    public function setAllFiles(allFiles){
        this.allFiles = allFiles;
        this._onAllFilesChanged.foreach(function(f){
            f();
            return true;
        });
    }
    public function getAllFiles() : Hash<SourceFile>{
        return allFiles;
    }
    public function onAllFilesChanged(f: Void -> Void){
        _onAllFilesChanged.push(f);
    }
    
    
    //-> Backbone#add/set/onAdd
    public function getCurrentFile() : SourceFile {
        return editingFiles.array[0];
    }
    public function selectNextFile(file: SourceFile) {
        if(file == null){
            return;
        }
        editingFiles.add(file);
        this._onEditingFileChanged.foreach(function(f){
            f();
            return true;
        });
    }
    public function onEditingFileChanged(f: Void -> Void){
        _onEditingFileChanged.push(f);
    }
    

    
    
}