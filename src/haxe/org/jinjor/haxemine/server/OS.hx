package org.jinjor.haxemine.server;

import js.Node;
using StringTools;

class OS {

    private static var os = Node.require('os');
    public static function isWin(){
        return type().toLowerCase().startsWith('win');
    }
    public static function type():String{
        return os.type();
    }

}