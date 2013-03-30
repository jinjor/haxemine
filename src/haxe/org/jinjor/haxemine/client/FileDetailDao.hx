package org.jinjor.haxemine.client;

import org.jinjor.haxemine.model.FileDetail;

class FileDetailDao {
    
    public function new(){
    }
    
    public function getFile(filePath : String, callBack : FileDetail -> Void){
        untyped $.ajax({
            url: 'src',
            data: {fileName: filePath},
            type: 'GET',
            success: function(fileDetail){
                callBack(fileDetail);
            }
        });
    }
}