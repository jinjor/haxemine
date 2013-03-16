package org.jinjor.haxemine;

import org.jinjor.haxemine.CompileError;
import org.jinjor.haxemine.Session;
import org.jinjor.haxemine.Controller;
import org.jinjor.haxemine.FileSelector;

class Main {
    
    public static function main(){
        
        var socket = untyped io.connect('/');
        var ace = untyped js.Lib.window.ace;
        
        new Controller(socket, ace);
    }
    
}