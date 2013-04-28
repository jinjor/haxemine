package org.jinjor.haxemine.messages;

class SocketMessage<T> {
    
    public var pub : T -> Void;
    public var sub : String -> (T -> Void) -> Void;
    var funcs : Hash<T -> Void>;
    
    public function new(socket : Dynamic, key : String) {
        this.funcs = new Hash();
        this.pub = function(data : T){
            socket.emit(key, haxe.Serializer.run(data));
        };
        this.sub = function(subKey : String, f : T -> Void){
            if(!funcs.exists(subKey)){
                funcs.set(subKey, f);
                socket.on(key, function(data){
                    f(haxe.Unserializer.run(data));
                });
            }
        };
        
    }

}