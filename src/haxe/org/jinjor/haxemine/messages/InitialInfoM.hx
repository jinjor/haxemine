package org.jinjor.haxemine.messages;

class InitialInfoM extends SocketMessage<InitialInfoDto>{

    public function new(socket) {
        super(socket, 'initialInfo');
    }

}