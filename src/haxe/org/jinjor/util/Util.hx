package org.jinjor.util;

import js.Lib;

using Lambda;

class Util{
  public static inline function or<A>(a : A, b : A) : A {
    return untyped a || b;
  }
  public static inline function and<A>(a : A, b : A) : A {
    return untyped a && b;
  }
  public static inline function compareTo(a : String, b: String) : Int {
    return if ( a < b ) -1 else if ( a > b ) 1 else 0;
  }
  
}