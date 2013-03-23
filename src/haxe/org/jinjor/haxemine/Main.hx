package org.jinjor.haxemine;

import org.jinjor.haxemine.CompileError;
import org.jinjor.haxemine.Session;
import org.jinjor.haxemine.View;
import org.jinjor.haxemine.FileSelector;

import js.JQuery;

class Main {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}
    
    public static function main(){
        
        var socket = untyped io.connect('/');
        var ace = untyped js.Lib.window.ace;
        
        var view = new View(socket, ace);
        new JQuery(js.Lib.document).ready(function(e){
            view.render(JQ('body'));
        });
    }
    
}