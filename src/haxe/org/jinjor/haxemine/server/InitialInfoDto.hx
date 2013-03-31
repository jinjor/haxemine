package org.jinjor.haxemine.server;

import org.jinjor.haxemine.model.SourceFile;

class InitialInfoDto {
    
    public var projectRoot : String;
    public var allFiles : Dynamic<SourceFile>;

    public function new(projectRoot, allFiles) {
        this.projectRoot = projectRoot;
        this.allFiles = allFiles;
    }

}