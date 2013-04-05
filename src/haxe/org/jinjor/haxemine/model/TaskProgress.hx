package org.jinjor.haxemine.model;

class TaskProgress {

    public var taskName : String;
    public var compileErrors : Array<CompileError>;
    
    public function new(taskName, compileErrors) {
        this.taskName = taskName;
        this.compileErrors = compileErrors;
    }

}