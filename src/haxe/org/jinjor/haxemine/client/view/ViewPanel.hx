package org.jinjor.haxemine.client.view;

import js.JQuery;

typedef ViewPanelDef = {
    name : String,
    container : JQuery
}

class ViewPanel {
    
    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}
    
    public var container : JQuery;

    public function new(defs : Array<ViewPanelDef>, selected : String) {
        var container = JQ('<div/>');
        var tabsContainer = JQ('<div/>');
        var panelsContainer = JQ('<div/>');
        
        for(def in defs) {
            var panel : JQuery = JQ('<div/>').html(def.container);
            var tab = JQ('<span class="view-tab"/>').text(def.name).click(function(){
                JQuery.cur.addClass('selected').siblings().removeClass('selected');
                panel.show().siblings().hide();
            });
            if(def.name == selected){
                tab.addClass('selected');
                panel.show();
            }else{
                tab.removeClass('selected');
                panel.hide();
            }
            tabsContainer.append(tab);
            panelsContainer.append(panel);
        }
        
        this.container = container.append(tabsContainer).append(panelsContainer);
    }

}