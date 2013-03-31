package org.jinjor.haxemine.client;

import js.JQuery;
import org.jinjor.haxemine.server.InitialInfoDto;

class Menu {
    
    private static inline function JQ(s: String){ return untyped $(s);}
    
    private static var template = new HoganTemplate<InitialInfoDto>('
        <label><!--{{projectRoot}}-->Haxemine</label>
    ');

    public var container : JQuery;
    
    public function new(session : Session) {
        this.container = JQ('<nav id="menu"/>');
        session.onInitialInfoReceived(function(initialInfoDto){
            render(initialInfoDto);
        });
    }
    
    
    private function render(initialInfoDto : InitialInfoDto) {
        var html = template.render(initialInfoDto);
        this.container.html(html);
    }

}