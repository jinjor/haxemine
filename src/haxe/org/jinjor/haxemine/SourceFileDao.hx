package org.jinjor.haxemine;

class SourceFileDao {
    
    public function new(){
    }
    
    public function getFile(filePath : String, callBack : Dynamic -> Void){
        untyped $.ajax({
            url: 'src',
            data: {fileName: filePath},
            type: 'GET',
            success: function(file){
                callBack(file);
            }
        });
    }
}
//testtest