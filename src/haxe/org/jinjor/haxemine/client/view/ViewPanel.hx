package org.jinjor.haxemine.client.view;

import js.JQuery;

typedef ViewPanelDef = {
    name : String,
    container : JQuery
}

class ViewPanel {
    
    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}
    
    public var container : JQuery;

    public function new(socket : Dynamic, session : Session) {
        var container = JQ('<div id="viewPanel"/>');
        var tabsContainer = JQ('<div id="tabsContainer"/>');
        var panelsContainer = JQ('<div/>');
        
        session.onInitialInfoReceived.sub(function(info){
            var compileErrorPanel = new CompileErrorPanel(socket, session);
            var searchPanel = new SearchPanel(socket, session);
            var selected = 'Tasks';
            var defs : Array<ViewPanelDef> = [
                {name:'Tasks', container:compileErrorPanel.container}
            ];
            if(info.searchEnabled){
                defs.push({name:'Search', container:searchPanel.container});
            }
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
        });

        this.container = container.append(tabsContainer).append(panelsContainer);
    }

}