package org.jinjor.util;

import js.Lib;
using Lambda;

class Util{
  public static inline function or<A>(a : A, b : A) : A {
    return untyped a || b;
  }
}