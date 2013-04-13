package org.jinjor.haxemine.server;

using org.jinjor.util.Util;

class Console {

    public static function print(s, ?author : String){
      untyped console.log(author.or('haxemine') + ' > ' + s);
    }

}