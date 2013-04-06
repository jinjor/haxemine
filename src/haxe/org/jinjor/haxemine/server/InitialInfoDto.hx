package org.jinjor.haxemine.server;

import org.jinjor.haxemine.model.SourceFile;
import org.jinjor.haxemine.model.TaskProgress;

class InitialInfoDto {
    
    public var projectRoot : String;
    public var allFiles : Dynamic<SourceFile>;
    public var taskInfos : Array<TaskInfo>;

    public function new(projectRoot, allFiles, taskInfos) {
        this.projectRoot = projectRoot;
        this.allFiles = allFiles;
        this.taskInfos = taskInfos;
    }

}