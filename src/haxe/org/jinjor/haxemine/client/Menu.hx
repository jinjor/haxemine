package org.jinjor.haxemine.client;

import js.JQuery;
import org.jinjor.haxemine.server.InitialInfoDto;

class Menu {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var template = new HoganTemplate<InitialInfoDto>('
        <label><!--{{projectRoot}}-->Haxemine</label>
    ');
    private static var templateDisConnected = new HoganTemplate<Dynamic>('
        <label class="disconnected">Disconnected</label>
    ');

    public var container : JQuery;
    
    private var initialInfoDto : InitialInfoDto;
    
    public function new(session : Session) {
        this.container = JQ('<nav id="menu"/>');
        session.onInitialInfoReceived(function(initialInfoDto){
            this.initialInfoDto = initialInfoDto;
            render();
        });
        session.onSocketConnected(function(){
            render();
        });
        session.onSocketDisconnected(function(){
            renderDisconnected();
        });
    }
    
    
    private function render() {
        var html = template.render(initialInfoDto);
        this.container.html(html);
    }
    private function renderDisconnected() {
        var html = templateDisConnected.render({});
        this.container.html(html);
    }

}