package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.InitialInfoDto;
import org.jinjor.haxemine.messages.DoTaskM;
import org.jinjor.haxemine.messages.TaskProgressM;

using Lambda;

class TaskListView {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    private static inline var HEIGHT = 16;

    public var container : JQuery;

    public function new(session : Session, doTaskM : DoTaskM, taskProgressM : TaskProgressM) {
        
        session.onInitialInfoReceived.sub('TaskListView.new', function(info : InitialInfoDto) {
            var tasks = info.taskInfos.map(function(taskInfo) {
                return new TaskModel(taskInfo.taskName, taskInfo.content, taskInfo.auto, taskProgressM);
            });
            
            var taskViewContainers = tasks.map(function(task){
                return new TaskView(doTaskM, session, task);
            }).map(function(view){
                return view.container;
            });
            
            container.empty();//一応
            taskViewContainers.foreach(function(c){
                container.append(c);
                return true;
            });
        });
        this.container = JQ('<div id="task-list-view"/>');
    }

}