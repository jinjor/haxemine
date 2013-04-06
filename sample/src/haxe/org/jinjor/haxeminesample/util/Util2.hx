package org.jinjor.haxeminesample.util;

class Util2{
    
  public static function join(a: String, b: String) : String {
    if(a.charAt(a.length-1)=='/' && b.charAt(0)=='/'){
      return a + b.substring(1);
    }else if(a.charAt(a.length-1)!='/' && b.charAt(0)!='/'){
      return a + '/' + b;
    }else{
      return a + b;
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}

