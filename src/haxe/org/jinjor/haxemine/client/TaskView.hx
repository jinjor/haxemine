package org.jinjor.haxemine.client;

import js.JQuery;

class TaskView {
    
    private static inline function JQ(s: String){ return untyped $(s);}

    public var container : JQuery;
    
    public function new(session : Session, task : TaskModel) {
        
        task.onUpdate(function(taskProgress){
            render(taskProgress.taskName);
        });
        
        this.container = JQ('<a class="task-view"/>').click(function(){
            session.doTask(task.name);
        });
        render(task.name);
    }
    
    private function render(taskName) {
        container.append(taskName);//TODO もうちょっとなんとかする
    }

}