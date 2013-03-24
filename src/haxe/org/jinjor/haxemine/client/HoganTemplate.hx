package org.jinjor.haxemine.client;

class HoganTemplate<T> {
    
    private var template : Dynamic;
    
    public function new(s : String){
        this.template = untyped Hogan.compile(s);
    }
    
    public function render(data : Dynamic) : String {
        return template.render(data);
    }
    
}