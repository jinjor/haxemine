package org.jinjor.haxemine.client.view;

import js.JQuery;
import org.jinjor.haxemine.messages.SearchM;
import org.jinjor.haxemine.messages.SearchResult;
import org.jinjor.haxemine.messages.SearchResultM;

using org.jinjor.util.ClientUtil;

class SearchPanel {
    
    private static inline function JQ(s: String) : JQuery { return untyped $(s);}
    public var container : JQuery;

    public function new(socket : Dynamic, session : Session) {
        var searchM = new SearchM(socket);
        var searchResultM = new SearchResultM(socket);
        
        var input = JQ('<input type="text"/>');
        var button = JQ('<input type="submit">').val('Search');
        var form = JQ('<form/>').append(input).append(button);
        var resultsContainer = JQ('<div/>');
        this.container = JQ('<div/>').append(form).append(resultsContainer);
        
        form.fixedSubmit(function(_){
            var word = input.val();
            searchM.pub(word);
            form.attr("disabled", "disabled");
        });
        
        searchResultM.sub(function(results : Array<SearchResult>){
            resultsContainer.empty();
            for(result in results){
                var link = JQ('<a/>').text(result.message).click(function(){
                    var file = session.getAllFiles().get(result.fileName);
                    session.selectNextFile(file);
                });
                var resultElm = JQ('<div/>').append(link);
                resultsContainer.append(resultElm);
            }
            form.removeAttr("disabled");
        });
        
    }

}