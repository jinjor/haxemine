package org.jinjor.haxemine.messages;

class InitialInfoDto {
    
    public var projectRoot : String;
    public var allFiles : Dynamic<SourceFile>;
    public var taskInfos : Array<TaskInfo>;
    public var searchEnabled : Bool;

    public function new(projectRoot, allFiles, taskInfos, searchEnabled) {
        this.projectRoot = projectRoot;
        this.allFiles = allFiles;
        this.taskInfos = taskInfos;
        this.searchEnabled = searchEnabled;
    }

}