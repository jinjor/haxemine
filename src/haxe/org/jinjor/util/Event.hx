package org.jinjor.util;

using Lambda;

class Event<T> {
    
    var events : Array<T -> Void>;

    public function new() {
        events = [];
    }
    
    public function sub(f: T -> Void){
        events.push(f);
    }
    
    public function pub(arg: T){
        events.foreach(function(f){
            f(arg);
            return true;
        });
    }

}