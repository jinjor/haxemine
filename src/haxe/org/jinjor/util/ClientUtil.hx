package org.jinjor.util;

import js.JQuery;

class ClientUtil {

    public static function fixedSubmit(jquery : JQuery, f : JQuery -> Void) : JQuery {
        js.Lib.eval('
            jquery.submit(function(){
                f($(this));
                return false;
            });
        ');
        return jquery;
   }

}