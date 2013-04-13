package org.jinjor.haxemine.messages;

class SearchResultM extends SocketMessage<Array<SearchResult>>{

    public function new(socket) {
        super(socket, 'search-result');
    }

}