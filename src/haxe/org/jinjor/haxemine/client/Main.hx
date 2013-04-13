package org.jinjor.haxemine.client;

import org.jinjor.haxemine.messages.CompileError;
import org.jinjor.haxemine.client.Session;
import org.jinjor.haxemine.messages.HistoryArray;
import org.jinjor.haxemine.messages.SourceFile;
import org.jinjor.haxemine.client.view.View;

import js.JQuery;

class Main {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}
    
    public static function main(){
        
        var socket = untyped io.connect('/');
        var session = new Session(socket, new HistoryArray<SourceFile>(10, SourceFile.equals));
        var ace = untyped js.Lib.window.ace;
        
        var view = new View(ace, socket, session);
        new JQuery(js.Lib.document).ready(function(e){
            view.render(JQ('body'));
        });
        
    }
    
}