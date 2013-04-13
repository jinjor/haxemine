package org.jinjor.haxemine.messages;

class DoTaskM extends SocketMessage<String>{
    public function new(socket) {
        super(socket, 'doTask');
    }
}