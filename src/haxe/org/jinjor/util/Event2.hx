package org.jinjor.util;

using Lambda;

class Event2<A, B> {

    var events : Array<A -> B -> Void>;

    public function new() {
        events = [];
    }
    
    public function sub(f: A -> B -> Void){
        events.push(f);
    }
    
    public function pub(a: A, b: B){
        events.foreach(function(f){
            f(a, b);
            return true;
        });
    }

}