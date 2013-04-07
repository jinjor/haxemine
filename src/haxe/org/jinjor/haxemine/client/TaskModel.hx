package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.TaskProgress;
import org.jinjor.util.Event;

using Lambda;

class TaskModel {
    
    public var name : String;
    public var auto : Bool;
    public var state : TaskModelState;
    public var onUpdate : Event<Void>;
    
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

            onUpdate.pub(null);
        });
        this.name = name;
        this.auto = auto;
        onUpdate = new Event();
        reset();
    }
    
    public function reset() {
        state = if(auto){
            TaskModelState.NONE;//TODO 本当は前のを待たないといけない
        }else{
            TaskModelState.READY;
        }
        
    }
}
