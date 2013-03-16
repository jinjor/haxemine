package org.jinjor.haxemine;

using Lambda;

class Session {

    private var compileErrors : Array<CompileError>;
    private var editingFiles : HistoryArray<SourceFile>;
    private var allFiles : Hash<SourceFile>;
    private var fileToLoad : SourceFile;
    
    private var _onAllFilesChanged : Array<Void -> Void>;
    private var _onCompileErrorsChanged : Array<Void -> Void>;
    private var _onEditingFileChanged : Array<Void -> Void>;
    private var _onDocumentReady : Array<Void -> Void>;
    
    public function new(editingFiles){
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this._onAllFilesChanged = [];
        this._onCompileErrorsChanged = [];
        this._onEditingFileChanged = [];
        this._onDocumentReady = [];
    }
    
    //-> Backbone#get/set/onChange
    public function setCompileErrors(msg : String){
        var messages = msg.split('\n');
        this.compileErrors = messages.map(function(message){
            return new CompileError(message, allFiles.get);
        }).array();
        this._onCompileErrorsChanged.foreach(function(f){
            f();
            return true;
        });
    }
    public function getCompileErrors() : Array<CompileError> {
        return compileErrors;
    }
    public function onCompileErrorsChanged(f: Void -> Void){
        _onCompileErrorsChanged.push(f);
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
    
    
    
    public function setDocumentReady(){
        this._onDocumentReady.foreach(function(f){
            f();
            return true;
        });
    }
    public function onDocumentReady(f: Void -> Void){
        _onDocumentReady.push(f);
    }
    

    
    
}