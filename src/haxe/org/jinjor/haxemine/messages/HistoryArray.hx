package org.jinjor.haxemine.messages;

import org.jinjor.util.Event;

class HistoryArray<T> {
    
    private var array : Array<T>;
    private var max : Int;
    private var equals : T -> T -> Bool;
    public var onChange : Event<T>;
    private var cursor : Int;
    
    public function new(max, equals){
        this.array = [];
        this.max = max;
        this.equals = equals;
        this.onChange = new Event();
        this.cursor = 0;
    }
    
    public function cursorToOlder() {
        if(cursor < array.length - 1 && cursor < max - 1){
            cursor = cursor + 1;
            onChange.pub(getCursored());
        }
    }
    public function cursorToNewer() {
        if(0 < cursor){
            cursor = cursor - 1;
            onChange.pub(getCursored());
        }
    }
    public function add(elm : T){
        var i = 0;
        while( i < array.length ) {
            if(equals(array[i], elm)){
                array.splice(i,1);
                break;
            }
            i++;
        }
        array.unshift(elm);
        i = array.length - 1;
        while( i > max ) {
            array.pop();
        }
        cursor = 0;
        onChange.pub(elm);
        
        try{
            trace('');
            trace(untyped array[0].shortName);
            trace(untyped array[1].shortName);
            trace(untyped array[2].shortName);
            trace(untyped array[3].shortName);
        }catch(e:Dynamic){
        }
    }
    
    public function getCursored() : T {
        return if(array.length <= 0) null else array[cursor];
    }
    
}