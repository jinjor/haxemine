package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.TaskProgress;

using Lambda;

class TaskModel {
    
    public var name : String;
    public var auto : Bool;
    public var state : TaskModelState;
    private var _onUpdate : Array<Void -> Void>;
    
    public function new(name : String, auto : Bool, socket : Dynamic) {
        untyped console.log(auto);
        var that = this;
        socket.on('taskProgress', function(progress : TaskProgress) {
            
            if(name != progress.taskName){
                return;
            }
            //untyped console.log(progress);

            that.state = if(progress.compileErrors.length <= 0){
                TaskModelState.SUCCESS;
            }else{
                TaskModelState.FAILED;
            }

            _onUpdate.foreach(function(f){
                f();
                return true;
            });
        });
        this.name = name;
        this.auto = auto;
        _onUpdate = [];
        reset();
    }
    
    public function onUpdate(f : Void -> Void) {
        _onUpdate.push(f);
    }

    public function reset() {
        state = if(auto){
            TaskModelState.NONE;//TODO 本当は前のを待たないといけない
        }else{
            TaskModelState.READY;
        }
        
    }
}
