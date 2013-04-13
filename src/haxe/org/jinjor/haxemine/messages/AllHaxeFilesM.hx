package org.jinjor.haxemine.messages;

class AllHaxeFilesM extends SocketMessage<Dynamic<SourceFile>>{

    public function new(socket) {
        super(socket, 'search');
    }

}