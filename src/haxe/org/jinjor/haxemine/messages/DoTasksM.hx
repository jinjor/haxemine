package org.jinjor.haxemine.messages;

class DoTasksM extends SocketMessage<Void>{
    public function new(socket) {
        super(socket, 'doTasks');
    }
}