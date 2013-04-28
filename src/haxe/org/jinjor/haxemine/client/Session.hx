package org.jinjor.haxemine.client;

import js.Lib;
import org.jinjor.haxemine.messages.CompileError;
import org.jinjor.haxemine.messages.SourceFile;
import org.jinjor.haxemine.messages.HistoryArray;
import org.jinjor.haxemine.messages.FileDetail;
import org.jinjor.haxemine.messages.SaveFileDto;
import org.jinjor.haxemine.messages.InitialInfoDto;
import org.jinjor.haxemine.messages.TaskProgress;

import org.jinjor.haxemine.messages.SaveM;
import org.jinjor.haxemine.messages.InitialInfoM;
import org.jinjor.haxemine.messages.AllHaxeFilesM;
import org.jinjor.haxemine.messages.DoTaskM;
import org.jinjor.haxemine.messages.DoTasksM;
import org.jinjor.haxemine.messages.TaskProgressM;

using Lambda;
using org.jinjor.util.Util;
import org.jinjor.util.Event;
import org.jinjor.util.Event2;

class Session {

    var socket : Dynamic;
    
    public var editingFiles : HistoryArray<SourceFile>;
    var allFiles : Hash<SourceFile>;
    var fileToLoad : SourceFile;
    var lastTaskProgress : TaskProgress;
    
    public var onSocketConnected : Event<Void>;
    public var onSocketDisconnected : Event<Void>;
    public var onInitialInfoReceived : Event<InitialInfoDto>;
    public var onAllFilesChanged : Event<Void>;
    public var onLastTaskProgressChanged : Event<Void>;
    public var onSave : Event<Void>;
    public var onSelectView : Event<String>;
    public var onEditingFileChange : Event2<SourceFile, Int>;
    
    public function new(socket, editingFiles){
        var that = this;
        this.socket = socket;
        var initialInfoM = new InitialInfoM(socket);
        var allHaxeFilesM = new AllHaxeFilesM(socket);
        var doTasksM = new DoTasksM(socket);
        var taskProgressM = new TaskProgressM(socket);
        
        socket.on('stdout', function(msg : Dynamic) {
            if(msg != ''){
                trace(msg);//View
            }
        });
        allHaxeFilesM.sub(function(files) {
            setAllFiles(files);
        });
        initialInfoM.sub(function(initialInfo) {
            onInitialInfoReceived.pub(initialInfo);
            setAllFiles(initialInfo.allFiles);
        });
        taskProgressM.sub(function(taskProgress) {//TODO ここじゃない
            that.lastTaskProgress = taskProgress;
            onLastTaskProgressChanged.pub(null);
        });
        socket.on('connect', function(_) {
            trace("connected.");//View
            onSocketConnected.pub(null);
        });
        socket.on('disconnect', function(_){
            trace("disconnected.");//View
            onSocketDisconnected.pub(null);
        });
        this.editingFiles = editingFiles;
        this.allFiles = new Hash();
        
        this.onSocketConnected = new Event();
        this.onSocketDisconnected = new Event();
        this.onInitialInfoReceived = new Event();
        this.onAllFilesChanged = new Event();
        this.onLastTaskProgressChanged = new Event();
        this.onSave = new Event();
        this.onSelectView = new Event();
        this.onEditingFileChange = new Event2();
        
        this.onSocketConnected.sub('Session.new', function(_){
            doTasksM.pub(null);
        });
    }
    

    public function getCompileErrors() : Array<CompileError> {
        return if(lastTaskProgress != null) lastTaskProgress.compileErrors else [];
    }
    

    private function setAllFiles(allFiles : Hash<SourceFile>){
        this.allFiles = allFiles;
        this.onAllFilesChanged.pub(null);
    }
    public function getAllFiles() : Hash<SourceFile>{
        return allFiles;
    }
    

    public function getCurrentFile() : SourceFile {
        return editingFiles.getCursored();
    }
    public function selectNextFile(file: SourceFile, optLine : Int) {
        if(file == null){
            return;
        }
        editingFiles.add(file);
        onEditingFileChange.pub(file, optLine);
    }
    public function selectOlderFile() {
        if(editingFiles.cursorToOlder()){
            onEditingFileChange.pub(editingFiles.getCursored(), null);
        }
    }
    public function selectNewerFile() {
        if(editingFiles.cursorToNewer()){
            onEditingFileChange.pub(editingFiles.getCursored(), null);
        }
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
    
}