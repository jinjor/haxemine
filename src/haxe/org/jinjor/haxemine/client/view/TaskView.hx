package org.jinjor.haxemine.client.view;

import js.JQuery;

class TaskView {
    
    private static inline function JQ(s: String){ return untyped $(s);}

    public var container : JQuery;
    
    public function new(session : Session, task : TaskModel) {
        
        task.onUpdate.sub(function(_) {
            render(task);
        });
        session.onSave.sub(function(_) {
            task.reset();
            render(task);
        });
        
        this.container = JQ('<a class="task-view"/>').click(function(){
            if(task.state == TaskModelState.READY){
                session.doTask(task.name);
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