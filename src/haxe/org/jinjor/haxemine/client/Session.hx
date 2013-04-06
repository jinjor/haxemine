package org.jinjor.haxemine.client;

import js.Lib;
import org.jinjor.haxemine.model.CompileError;
import org.jinjor.haxemine.model.SourceFile;
import org.jinjor.haxemine.model.HistoryArray;
import org.jinjor.haxemine.model.FileDetail;
import org.jinjor.haxemine.server.SaveFileDto;
import org.jinjor.haxemine.server.InitialInfoDto;

using Lambda;
using org.jinjor.util.Util;

class Session {

    var socket : Dynamic;
    
    var compileErrors : Array<CompileError>;
    var editingFiles : HistoryArray<SourceFile>;
    var allFiles : Hash<SourceFile>;
    var fileToLoad : SourceFile;
    
    var _onSocketConnected : Array<Void -> Void>;
    var _onSocketDisconnected : Array<Void -> Void>;
    var _onInitialInfoReceived : Array<InitialInfoDto -> Void>;
    var _onAllFilesChanged : Array<Void -> Void>;
    var _onCompileErrorsChanged : Array<Void -> Void>;
    var _onEditingFileChanged : Array<FileDetail -> Void>;
    var _onSave : Array<Void -> Void>;
    
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
        socket.on('initial-info', function(initialInfoDto : InitialInfoDto) {
            _onInitialInfoReceived.foreach(function(f){
                f(initialInfoDto);
                return true;
            });
            setAllFiles(Util.dynamicToHash(initialInfoDto.allFiles));
        });
        socket.on('taskProgress', function(taskProgress : Dynamic) {//TODO ここじゃない
            that.setCompileErrors(taskProgress.compileErrors);
        });
        socket.on('connect', function(_) {
            trace("connected.");//View
            _onSocketConnected.foreach(function(f){
                f();
                return true;
            });
        });
        socket.on('disconnect', function(_){
            trace("disconnected.");//View
            _onSocketDisconnected.foreach(function(f){
                f();
                return true;
            });
        });
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this._onSocketConnected = [];
        this._onSocketDisconnected = [];
        this._onInitialInfoReceived = [];
        this._onAllFilesChanged = [];
        this._onCompileErrorsChanged = [];
        this._onEditingFileChanged = [];
        this._onSave = [];
        
        this.onSocketConnected(function(){
            doAllAutoTasks();//TODO ここじゃないきがする
        });
    }
    
    
    public function onSocketConnected(f: Void -> Void){
        _onSocketConnected.push(f);
    }
    public function onSocketDisconnected(f: Void -> Void){
        _onSocketDisconnected.push(f);
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



    public function onInitialInfoReceived(f: InitialInfoDto -> Void){
        _onInitialInfoReceived.push(f);
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
        if(file == null){
            return new List();
        }
        return getCompileErrors().filter(function(error){
            return error.originalMessage.indexOf(file.pathFromProjectRoot) == 0
            || error.originalMessage.indexOf('./' + file.pathFromProjectRoot) == 0;
        });
    }
    
    public function onSave(f : Void -> Void) {
        _onSave.push(f);
    }
    
    
    public function doTask(taskName : String){
        socket.emit('doTask', {
            taskName: taskName
        });
    }
    public function doAllAutoTasks(){
        socket.emit('doTasks', {});
    }
    
    public function saveFile(text : String){
        _onSave.foreach(function(f){
            f();
            return true;
        });
        socket.emit('save', new SaveFileDto(getCurrentFile().pathFromProjectRoot, text));
    }
    
    public function saveNewFile(pathFromProjectRoot : String, text : String){
        var dup = false;
        for(file in getAllFiles()){
            if(file.pathFromProjectRoot == pathFromProjectRoot){
                dup = true;
                break;
            }
        }
        if(dup){
            Lib.alert(pathFromProjectRoot + ' already exists.');
        }else{
            socket.emit('save', new SaveFileDto(pathFromProjectRoot, text));
        }
        
        
        
    }
    
}