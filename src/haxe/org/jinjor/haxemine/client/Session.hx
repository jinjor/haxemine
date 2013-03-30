package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.CompileError;
import org.jinjor.haxemine.model.SourceFile;
import org.jinjor.haxemine.model.HistoryArray;
import org.jinjor.haxemine.model.FileDetail;

using Lambda;
using org.jinjor.util.Util;

class Session {

    private var socket : Dynamic;
    private var compileErrors : Array<CompileError>;
    private var editingFiles : HistoryArray<SourceFile>;
    private var allFiles : Hash<SourceFile>;
    private var fileToLoad : SourceFile;
    
    private var _onAllFilesChanged : Array<Void -> Void>;
    private var _onCompileErrorsChanged : Array<Void -> Void>;
    private var _onEditingFileChanged : Array<FileDetail -> Void>;
    
    public function new(socket, editingFiles){
        var that = this;
        this.socket = socket;
        socket.on('stdout', function(msg : Dynamic) {
            if(msg != ''){
                trace(msg);//View
            }
        });
        socket.on('all-haxe-files', function(files : Dynamic<SourceFile>) {
            setAllFiles(Util.dynamicToHash(files));
        });
        socket.on('haxe-compile-err', function(msg : Dynamic) {
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
    private function setCompileErrors(compileErrors : Array<CompileError>){
        this.compileErrors = compileErrors;
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
    private function setAllFiles(allFiles : Hash<SourceFile>){
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
        var that = this;
        if(file == null){
            return;
        }
        editingFiles.add(file);
        new FileDetailDao().getFile(getCurrentFile().pathFromProjectRoot, function(detail: FileDetail){
            that._onEditingFileChanged.foreach(function(f){
                f(detail);
                return true;
            });
        });
    }
    public function onEditingFileChanged(f: FileDetail -> Void){
        _onEditingFileChanged.push(f);
    }
    
    public function getCompileErrorsByFile(file : SourceFile) : List<CompileError> {
        return getCompileErrors().filter(function(error){
            return error.originalMessage.indexOf(file.pathFromProjectRoot) == 0
            || error.originalMessage.indexOf('./' + file.pathFromProjectRoot) == 0;
        });
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