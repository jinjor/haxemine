package org.jinjor.haxemine.client;

import js.JQuery;
using Lambda;

class Folder {
    
    private static inline function JQ(s: String) : Dynamic { return untyped $(s);}

    public var container : JQuery;
    
    private var closedMark : JQuery;
    private var openMark : JQuery;
    private var fileContainer : JQuery;

    public function new(dir : JQuery, files : JQuery) {

        this.container = JQ('<div class="folder"/>');
        this.closedMark = JQ('<div class="closeMark">-</div>').click(function(){
            renderClose();
        });
        this.openMark = JQ('<div class="openMark">+</div>').click(function(){
            renderOpen();
        });
        var dirContainer = JQ('<div/>').append(this.closedMark).append(this.openMark).append(dir);
        this.fileContainer = JQ('<div/>').append(files);
        
        this.container.append(dirContainer).append(fileContainer);
        
        renderClose();
    }
    
    function renderOpen(){
        closedMark.show();
        openMark.hide();
        fileContainer.show();
    }
    
    function renderClose(){
        closedMark.hide();
        openMark.show();
        fileContainer.hide();
    }
    
    
    

}