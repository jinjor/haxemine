package org.jinjor.haxemine.server;

class TaskInfo {
    
    public var taskName : String;
    public var auto : Bool;

    public function new(taskName, auto) {
        this.taskName = taskName;
        this.auto = auto;
    }

}