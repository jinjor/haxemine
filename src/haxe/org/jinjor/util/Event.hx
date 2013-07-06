package org.jinjor.util;

using Lambda;

class Event<T> {
    
    var events : Map<String, T -> Void>;

    public function new() {
        events = new Map();
    }
    
    public function sub(key : String, f: T -> Void){
        events.set(key, f);
    }
    
    public function pub(arg: T){
        for(key in events.keys()){
            events.get(key)(arg);
        }
    }

}