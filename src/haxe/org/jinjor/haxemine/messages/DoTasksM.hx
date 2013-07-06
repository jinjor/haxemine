package org.jinjor.haxemine.messages;

class DoTasksM extends SocketMessage<Dynamic>{
    public function new(socket) {
        super(socket, 'doTasks');
    }
}