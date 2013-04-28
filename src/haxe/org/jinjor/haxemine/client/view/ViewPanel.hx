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
        var panelsContainer = JQ('<div id="panelsContainer"/>');
        
        var selectView = new Hash<Void -> Void>();
        
        var compileErrorPanel = new CompileErrorPanel(socket, session);
        var searchPanel = new SearchPanel(socket, session);
        
        session.onInitialInfoReceived.sub('ViewPanel.new', function(info){
            
            var defs : Array<ViewPanelDef> = [
                {name:'Tasks', container:compileErrorPanel.container}
            ];
            if(info.searchEnabled){
                defs.push({name:'Search', container:searchPanel.container});
            }
            tabsContainer.empty();
            panelsContainer.empty();
            for(def in defs) {
                var panel : JQuery = JQ('<div/>').html(def.container).hide();
                var tab = JQ('<span class="view-tab"/>').text(def.name).click(function(){
                    session.onSelectView.pub(def.name);
                });
                selectView.set(def.name, function(){
                    tab.addClass('selected').siblings().removeClass('selected');
                    panel.show().siblings().hide();
                });
                tabsContainer.append(tab);
                panelsContainer.append(panel);
            }
            
            session.onSelectView.pub('Tasks');
        });
        
        session.onSelectView.sub('ViewPanel.new', function(viewName : String){
            selectView.get(viewName)();
        });
        session.onLastTaskProgressChanged.sub('ViewPanel.new', function(_){
            session.onSelectView.pub('Tasks');
        });

        this.container = container.append(tabsContainer).append(panelsContainer);
    }

}