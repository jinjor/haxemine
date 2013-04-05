package org.jinjor.haxemine.client;

import js.JQuery;
import org.jinjor.haxemine.server.InitialInfoDto;

using Lambda;

class TaskListView {
    
    private static inline function JQ(s: String){ return untyped $(s);}

    public var container : JQuery;

    public function new(socket : Dynamic, session : Session) {
        
        session.onInitialInfoReceived(function(info : InitialInfoDto) {
            
            var tasks = info.taskProgresses.map(function(progress) {
                return new TaskModel(progress.taskName, socket);
            });
            var taskViewContainers = tasks.map(function(task){
                return new TaskView(task);
            }).map(function(view){
                return view.container;
            });
            
            container.empty();//一応
            taskViewContainers.foreach(function(c){
                container.append(c);
                return true;
            });
        });
        this.container = JQ('<div/>');
    }

}