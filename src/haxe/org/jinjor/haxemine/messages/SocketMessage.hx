package org.jinjor.haxemine.messages;

class SocketMessage<T> {
    
    public var pub : T -> Void;
    public var sub : (T -> Void) -> Void;
    
    public function new(socket : Dynamic, key : String) {
        this.pub = function(data : T){
            socket.emit(key, data);//TODO Serialize
        };
        this.sub = function(f : T -> Void){
            socket.on(key, f);
        };
    }

}