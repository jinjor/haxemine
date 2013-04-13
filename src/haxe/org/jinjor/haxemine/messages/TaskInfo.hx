package org.jinjor.haxemine.messages;

class TaskInfo {
    
    public var taskName : String;
    public var content : String;
    public var auto : Bool;

    public function new(taskName, content, auto) {
        this.taskName = taskName;
        this.content = content;
        this.auto = auto;
    }

}