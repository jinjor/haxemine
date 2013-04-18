package org.jinjor.haxemine.client;

import org.jinjor.haxemine.messages.TaskProgress;
import org.jinjor.haxemine.messages.TaskProgressM;
import org.jinjor.util.Event;

using Lambda;

class TaskModel {
    
    public var name : String;
    public var content : String;
    public var auto : Bool;
    public var state(default, null) : TaskModelState;
    public var onUpdate : Event<Void>;
    
    public function new(name : String, content : String, auto : Bool, socket : Dynamic) {
        var taskProgressM = new TaskProgressM(socket);
        var that = this;
        taskProgressM.sub(function(progress) {
            if(name != progress.taskName){
                return;
            }
            that.state = if(progress.compileErrors.length <= 0){
                TaskModelState.SUCCESS;
            }else{
                TaskModelState.FAILED;
            }

            onUpdate.pub(null);
        });
        this.name = name;
        this.content = content;
        this.auto = auto;
        onUpdate = new Event();
        reset();
    }
    
    public function setState(newState) {
        this.state = newState;
        onUpdate.pub(null);
    }
    
    public function reset() {
        state = if(auto){
            TaskModelState.NONE;//TODO 本当は前のを待たないといけない
        }else{
            TaskModelState.READY;
        }
        
    }
}
