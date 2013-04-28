package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.DoTaskM;

class TaskView {
    
    private static inline function JQ(s: String){ return untyped $(s);}

    public var container : JQuery;
    
    public function new(doTaskM: DoTaskM, session : Session, task : TaskModel) {
        
        task.onUpdate.sub('TaskView.new.' + task.name, function(_) {
            render(task);
            //js.Lib.alert('onUpdate');
        });
        session.onSave.sub('TaskView.new.' + task.name, function(_) {
            task.reset();
            render(task);
        });
        this.container = JQ('<a class="task-view"/>').attr('title', task.content).click(function(){
            if(task.state == TaskModelState.READY){
                task.setState(TaskModelState.WAITING);
                doTaskM.pub(task.name);
            }
        });
        render(task);
    }
    
    private function render(task : TaskModel) {
        container.html(task.name)
        .removeClass('success')
        .removeClass('failed')
        .removeClass('ready')
        .addClass(switch(task.state){
            case NONE: '';
            case WAITING: '';
            case SUCCESS: 'success';
            case FAILED: 'failed';
            case READY : 'ready';
        });

    }

}