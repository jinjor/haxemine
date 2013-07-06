package org.jinjor.haxemine.messages;

class AllHaxeFilesM extends SocketMessage<Map<String, SourceFile>>{

    public function new(socket) {
        super(socket, 'search');
    }

}