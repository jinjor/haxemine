package org.jinjor.haxemine.model;

import org.jinjor.haxemine.client.SourceFileDao;

using Lambda;

class EditingFile {
    
    public var session : Session;
    private var _onChange : Array<Void -> Void>;
    private var _onCompileErrorsChanged : Array<Void -> Void>;
    
    public var text : String;
    public var mode : String;
    
    
    public function new(session : Session){
        var that = this;
        this.session = session;
        this._onChange = [];
        this._onCompileErrorsChanged = [];
         
        session.onEditingFileChanged(function(){
            that.loadNew();
        });
        session.onCompileErrorsChanged(function(){
            that._onCompileErrorsChanged.foreach(function(f){
                f();
                return true;
            });
        });
    }


    private function loadNew(){
        var that = this;
        var currentFile = session.getCurrentFile();
        if(currentFile == null){
            return;
        }
        new SourceFileDao().getFile(currentFile.pathFromProjectRoot, function(_file){
            if(_file == null){
                return;
            }
            that.text = _file.text;
            that.mode = _file.mode;
            that._onChange.foreach(function(f){
                f();
                return true;
            });
            that._onCompileErrorsChanged.foreach(function(f){
                f();
                return true;
            });
        });
    }
    
    public function getCompileErrors() : List<CompileError> {
        var file = session.getCurrentFile();
        if(file == null){
            return new List();
        }
        return session.getCompileErrors().filter(function(error){
            return error.originalMessage.indexOf(file.pathFromProjectRoot) == 0
            || error.originalMessage.indexOf('./' + file.pathFromProjectRoot) == 0;
        });
    }

    public function onChange(f: Void -> Void){
        _onChange.push(f);
    }
    public function onCompileErrorsChanged(f: Void -> Void){
        _onCompileErrorsChanged.push(f);
    }
    
    public function getFile(){
        return session.getCurrentFile();
    }
    
    public function getText() : String {
        return text;
    }
    
    public function getMode() : String {
        return mode;
    }
    
    

    
}