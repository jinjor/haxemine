package org.jinjor.haxemine.messages;

class AllHaxeFilesM extends SocketMessage<Hash<SourceFile>>{

    public function new(socket) {
        super(socket, 'search');
    }

}