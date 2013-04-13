package org.jinjor.haxemine.messages;

class SaveM extends SocketMessage<SaveFileDto>{

    public function new(socket) {
        super(socket, 'save');
    }

}