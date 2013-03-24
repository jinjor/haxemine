package org.jinjor.haxemine.model;

class HistoryArray<T> {
    
    public var array : Array<T>;
    private var max : Int;
    private var equals : T -> T -> Bool;
    
    public function new(max, equals){
        this.array = [];
        this.max = max;
        this.equals = equals;
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
    }
    
}