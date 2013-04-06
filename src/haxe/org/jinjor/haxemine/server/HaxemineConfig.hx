package org.jinjor.haxemine.server;

typedef Hxml = {
    path : String,
    auto : Bool
}


class HaxemineConfig {
  public var port : Int;
  public var hxml : Array<Hxml>;
  
  public function new(port, hxml){
      this.port = port;
      this.hxml = hxml;
  }
}