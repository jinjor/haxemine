package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.TaskProgress;

using Lambda;

class TaskModel {
    
    public var name : String;
    private var _onUpdate : Array<TaskProgress -> Void>;
    
    public function new(name : String, socket : Dynamic) {
        socket.on('taskProgress', function(progress : TaskProgress) {
            if(name != progress.taskName){
                return;
            }
            _onUpdate.foreach(function(f){
                f(progress);
                return true;
            });
        });
        this.name = name;
        _onUpdate = [];
    }
    
    public function onUpdate(f : TaskProgress -> Void) {
        _onUpdate.push(f);
    }

}