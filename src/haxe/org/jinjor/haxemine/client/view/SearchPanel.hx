package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.model.SearchResult;

using org.jinjor.util.ClientUtil;

class SearchPanel {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}
    public var container : JQuery;

    public function new(socket : Dynamic, session : Session) {
        
        var input = JQ('<input type="text"/>');
        var button = JQ('<input type="submit">').val('Search');
        var form = JQ('<form/>').append(input).append(button);
        form.fixedSubmit(function(_){
            var word = input.val();
            socket.emit('search', word);
            form.attr("disabled", "disabled");
        });
        var resultsContainer = JQ('<div/>');
        
        socket.on('search-result', function(results : Array<SearchResult>){
            resultsContainer.empty();
            for(result in results){
                var resultElm = JQ('<a/>').text(result.message).click(function(){
                    var file = session.getAllFiles().get(result.fileName);
                    session.selectNextFile(file);
                });
                resultsContainer.append(resultElm);
            }
            form.removeAttr("disabled");
        });
        this.container = JQ('<div/>').append(form).append(resultsContainer);
    }

}