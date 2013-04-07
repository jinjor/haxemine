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
using org.jinjor.util.Event;

class Session {

    var socket : Dynamic;
    
    var compileErrors : Array<CompileError>;
    var editingFiles : HistoryArray<SourceFile>;
    var allFiles : Hash<SourceFile>;
    var fileToLoad : SourceFile;
    
    public var onSocketConnected : Event<Void>;
    public var onSocketDisconnected : Event<Void>;
    public var onInitialInfoReceived : Event<InitialInfoDto>;
    public var onAllFilesChanged : Event<Void>;
    public var onCompileErrorsChanged : Event<Void>;
    public var onEditingFileChanged : Event<FileDetail>;
    public var onSave : Event<Void>;
    
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
            onInitialInfoReceived.pub(initialInfoDto);
            setAllFiles(Util.dynamicToHash(initialInfoDto.allFiles));
        });
        socket.on('taskProgress', function(taskProgress : Dynamic) {//TODO ここじゃない
            that.setCompileErrors(taskProgress.compileErrors);
        });
        socket.on('connect', function(_) {
            trace("connected.");//View
            onSocketConnected.pub(null);
        });
        socket.on('disconnect', function(_){
            trace("disconnected.");//View
            onSocketDisconnected.pub(null);
        });
        this.compileErrors = [];
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this.onSocketConnected = new Event();
        this.onSocketDisconnected = new Event();
        this.onInitialInfoReceived = new Event();
        this.onAllFilesChanged = new Event();
        this.onCompileErrorsChanged = new Event();
        this.onEditingFileChanged = new Event();
        this.onSave = new Event();
        
        this.onSocketConnected.sub(function(_){
            doAllAutoTasks();//TODO ここじゃないきがする
        });
    }
    
    //-> Backbone#get/set/onChange
    private function setCompileErrors(compileErrors : Array<CompileError>){
        this.compileErrors = compileErrors;
        this.onCompileErrorsChanged.pub(null);
    }
    public function getCompileErrors() : Array<CompileError> {
        return compileErrors;
    }
    
    //-> Backbone#get/set/onChange
    private function setAllFiles(allFiles : Hash<SourceFile>){
        this.allFiles = allFiles;
        this.onAllFilesChanged.pub(null);
    }
    public function getAllFiles() : Hash<SourceFile>{
        return allFiles;
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
            that.onEditingFileChanged.pub(detail);
        });
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
    
    public function doTask(taskName : String){
        socket.emit('doTask', {
            taskName: taskName
        });
    }
    public function doAllAutoTasks(){
        socket.emit('doTasks', {});
    }
    
    public function saveFile(text : String){
        onSave.pub(null);
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