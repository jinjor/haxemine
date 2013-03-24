package org.jinjor.haxemine.model;

using Lambda;

class Session {

    private var socket : Dynamic;
    private var compileErrors : Array<CompileError>;
    private var editingFiles : HistoryArray<SourceFile>;
    private var allFiles : Hash<SourceFile>;
    private var fileToLoad : SourceFile;
    
    private var _onAllFilesChanged : Array<Void -> Void>;
    private var _onCompileErrorsChanged : Array<Void -> Void>;
    private var _onEditingFileChanged : Array<Void -> Void>;
    
    public function new(socket, editingFiles){
        var that = this;
        this.socket = socket;
        socket.on('stdout', function(msg) {
            trace(msg);//View
        });
        socket.on('all-haxe-files', function(filesPaths : Array<String>) {
            var files = new Hash<SourceFile>();
            filesPaths.foreach(function(f){
                files.set(f, new SourceFile(f));
                return true;
            });
            setAllFiles(files);
        });
        socket.on('haxe-compile-err', function(msg : Dynamic) {
            trace('error found: ' + msg);
            that.setCompileErrors(msg);
        });
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this._onAllFilesChanged = [];
        this._onCompileErrorsChanged = [];
        this._onEditingFileChanged = [];
    }
    
    //-> Backbone#get/set/onChange
    private function setCompileErrors(msg : String){
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
    private function setAllFiles(allFiles){
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
    
    public function compile(){
        untyped console.log(socket);
        socket.emit('doTasks', {});
    }
    
    public function saveFile(text){
        socket.emit('save', {
            fileName : getCurrentFile().pathFromProjectRoot,
            text: text
        });
    }

    
    
}