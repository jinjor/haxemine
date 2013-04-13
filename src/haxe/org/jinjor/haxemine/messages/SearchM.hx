package org.jinjor.haxemine.messages;

class SearchM extends SocketMessage<String>{

    public function new(socket) {
        super(socket, 'search');
    }

}