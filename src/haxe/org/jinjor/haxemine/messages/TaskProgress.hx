package org.jinjor.haxemine.messages;

class TaskProgress {

    public var taskName : String;
    public var compileErrors : Array<CompileError>;
    
    public function new(taskName, compileErrors) {
        this.taskName = taskName;
        this.compileErrors = compileErrors;
    }

}