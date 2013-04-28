package org.jinjor.haxemine.messages;

class AllMessages {
    
    public var doTaskM : DoTaskM;
    public var taskProgressM : TaskProgressM;
    public var searchM : SearchM;
    public var searchResultM : SearchResultM;

    public function new(socket) {
        this.doTaskM = new DoTaskM(socket);
        this.taskProgressM = new TaskProgressM(socket);
        this.searchM = new SearchM(socket);
        this.searchResultM = new SearchResultM(socket);
    }

}