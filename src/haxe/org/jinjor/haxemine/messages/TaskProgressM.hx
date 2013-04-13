package org.jinjor.haxemine.messages;

class TaskProgressM extends SocketMessage<TaskProgress>{
    public function new(socket) {
        super(socket, 'taskProgress');
    }
}