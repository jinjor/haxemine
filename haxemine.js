(function () { "use strict";
var $hxClasses = {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { }
$hxClasses["HxOverrides"] = HxOverrides;
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
$hxClasses["Lambda"] = Lambda;
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
var List = function() {
	this.length = 0;
};
$hxClasses["List"] = List;
List.__name__ = ["List"];
List.prototype = {
	iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,__class__: List
}
var IMap = function() { }
$hxClasses["IMap"] = IMap;
IMap.__name__ = ["IMap"];
var Reflect = function() { }
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.deleteField = function(o,field) {
	if(!Reflect.hasField(o,field)) return false;
	delete(o[field]);
	return true;
}
var Std = function() { }
$hxClasses["Std"] = Std;
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	__class__: StringBuf
}
var StringTools = function() { }
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { }
$hxClasses["Type"] = Type;
Type.__name__ = ["Type"];
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
var haxe = {}
haxe.Json = function() { }
$hxClasses["haxe.Json"] = haxe.Json;
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.stringify = function(obj,replacer,insertion) {
	return js.Node.stringify(obj,replacer,insertion);
}
haxe.Json.parse = function(jsonString) {
	return js.Node.parse(jsonString);
}
haxe.Serializer = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new haxe.ds.StringMap();
	this.scount = 0;
};
$hxClasses["haxe.Serializer"] = haxe.Serializer;
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype = {
	serialize: function(v) {
		var _g = Type["typeof"](v);
		var $e = (_g);
		switch( $e[1] ) {
		case 0:
			this.buf.b += "n";
			break;
		case 1:
			if(v == 0) {
				this.buf.b += "z";
				return;
			}
			this.buf.b += "i";
			this.buf.b += Std.string(v);
			break;
		case 2:
			if(Math.isNaN(v)) this.buf.b += "k"; else if(!Math.isFinite(v)) this.buf.b += Std.string(v < 0?"m":"p"); else {
				this.buf.b += "d";
				this.buf.b += Std.string(v);
			}
			break;
		case 3:
			this.buf.b += Std.string(v?"t":"f");
			break;
		case 6:
			var c = $e[2];
			if(c == String) {
				this.serializeString(v);
				return;
			}
			if(this.useCache && this.serializeRef(v)) return;
			switch(c) {
			case Array:
				var ucount = 0;
				this.buf.b += "a";
				var l = v.length;
				var _g1 = 0;
				while(_g1 < l) {
					var i = _g1++;
					if(v[i] == null) ucount++; else {
						if(ucount > 0) {
							if(ucount == 1) this.buf.b += "n"; else {
								this.buf.b += "u";
								this.buf.b += Std.string(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) this.buf.b += "n"; else {
						this.buf.b += "u";
						this.buf.b += Std.string(ucount);
					}
				}
				this.buf.b += "h";
				break;
			case List:
				this.buf.b += "l";
				var v1 = v;
				var $it0 = v1.iterator();
				while( $it0.hasNext() ) {
					var i = $it0.next();
					this.serialize(i);
				}
				this.buf.b += "h";
				break;
			case Date:
				var d = v;
				this.buf.b += "v";
				this.buf.b += Std.string(HxOverrides.dateStr(d));
				break;
			case haxe.ds.StringMap:
				this.buf.b += "b";
				var v1 = v;
				var $it1 = v1.keys();
				while( $it1.hasNext() ) {
					var k = $it1.next();
					this.serializeString(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.IntMap:
				this.buf.b += "q";
				var v1 = v;
				var $it2 = v1.keys();
				while( $it2.hasNext() ) {
					var k = $it2.next();
					this.buf.b += ":";
					this.buf.b += Std.string(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += "h";
				break;
			case haxe.ds.ObjectMap:
				this.buf.b += "M";
				var v1 = v;
				var $it3 = v1.keys();
				while( $it3.hasNext() ) {
					var k = $it3.next();
					var id = Reflect.field(k,"__id__");
					Reflect.deleteField(k,"__id__");
					this.serialize(k);
					k.__id__ = id;
					this.serialize(v1.h[k.__id__]);
				}
				this.buf.b += "h";
				break;
			case haxe.io.Bytes:
				var v1 = v;
				var i = 0;
				var max = v1.length - 2;
				var charsBuf = new StringBuf();
				var b64 = haxe.Serializer.BASE64;
				while(i < max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					var b3 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt((b2 << 2 | b3 >> 6) & 63));
					charsBuf.b += Std.string(b64.charAt(b3 & 63));
				}
				if(i == max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt(b2 << 2 & 63));
				} else if(i == max + 1) {
					var b1 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt(b1 << 4 & 63));
				}
				var chars = charsBuf.b;
				this.buf.b += "s";
				this.buf.b += Std.string(chars.length);
				this.buf.b += ":";
				this.buf.b += Std.string(chars);
				break;
			default:
				this.cache.pop();
				if(v.hxSerialize != null) {
					this.buf.b += "C";
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					v.hxSerialize(this);
					this.buf.b += "g";
				} else {
					this.buf.b += "c";
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					this.serializeFields(v);
				}
			}
			break;
		case 4:
			if(this.useCache && this.serializeRef(v)) return;
			this.buf.b += "o";
			this.serializeFields(v);
			break;
		case 7:
			var e = $e[2];
			if(this.useCache && this.serializeRef(v)) return;
			this.cache.pop();
			this.buf.b += Std.string(this.useEnumIndex?"j":"w");
			this.serializeString(Type.getEnumName(e));
			if(this.useEnumIndex) {
				this.buf.b += ":";
				this.buf.b += Std.string(v[1]);
			} else this.serializeString(v[0]);
			this.buf.b += ":";
			var l = v.length;
			this.buf.b += Std.string(l - 2);
			var _g1 = 2;
			while(_g1 < l) {
				var i = _g1++;
				this.serialize(v[i]);
			}
			this.cache.push(v);
			break;
		case 5:
			throw "Cannot serialize function";
			break;
		default:
			throw "Cannot serialize " + Std.string(v);
		}
	}
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.b += "g";
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0, _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += "r";
				this.buf.b += Std.string(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += "R";
			this.buf.b += Std.string(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += "y";
		s = StringTools.urlEncode(s);
		this.buf.b += Std.string(s.length);
		this.buf.b += ":";
		this.buf.b += Std.string(s);
	}
	,toString: function() {
		return this.buf.b;
	}
	,__class__: haxe.Serializer
}
haxe.Unserializer = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
$hxClasses["haxe.Unserializer"] = haxe.Unserializer;
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	unserialize: function() {
		var _g = this.buf.charCodeAt(this.pos++);
		switch(_g) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			var p1 = this.pos;
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = HxOverrides.substr(this.buf,this.pos,len);
			this.pos += len;
			s = StringTools.urlDecode(s);
			this.scache.push(s);
			return s;
		case 107:
			return Math.NaN;
		case 109:
			return Math.NEGATIVE_INFINITY;
		case 112:
			return Math.POSITIVE_INFINITY;
		case 97:
			var buf = this.buf;
			var a = new Array();
			this.cache.push(a);
			while(true) {
				var c = this.buf.charCodeAt(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n = this.readDigits();
			if(n < 0 || n >= this.cache.length) throw "Invalid reference";
			return this.cache[n];
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
			return this.scache[n];
		case 120:
			throw this.unserialize();
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 119:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new haxe.ds.StringMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new haxe.ds.IntMap();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.charCodeAt(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.charCodeAt(this.pos++);
			}
			if(c != 104) throw "Invalid IntMap format";
			return h;
		case 77:
			var h = new haxe.ds.ObjectMap();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 118:
			var d = HxOverrides.strDate(HxOverrides.substr(this.buf,this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
			var codes = haxe.Unserializer.CODES;
			if(codes == null) {
				codes = haxe.Unserializer.initCodes();
				haxe.Unserializer.CODES = codes;
			}
			var i = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i + (len - rest);
			var bytes = haxe.io.Bytes.alloc(size);
			var bpos = 0;
			while(i < max) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = c1 << 2 | c2 >> 4;
				var c3 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = c2 << 4 | c3 >> 2;
				var c4 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = c3 << 6 | c4;
			}
			if(rest >= 2) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = c1 << 2 | c2 >> 4;
				if(rest == 3) {
					var c3 = codes[buf.charCodeAt(i++)];
					bytes.b[bpos++] = c2 << 4 | c3 >> 2;
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.buf.charCodeAt(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.charCodeAt(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!js.Boot.__instanceof(k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,__class__: haxe.Unserializer
}
haxe.ds = {}
haxe.ds.IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe.ds.IntMap;
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,__class__: haxe.ds.IntMap
}
haxe.ds.ObjectMap = function() {
	this.h = { };
	this.h.__keys__ = { };
};
$hxClasses["haxe.ds.ObjectMap"] = haxe.ds.ObjectMap;
haxe.ds.ObjectMap.__name__ = ["haxe","ds","ObjectMap"];
haxe.ds.ObjectMap.__interfaces__ = [IMap];
haxe.ds.ObjectMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) a.push(this.h.__keys__[key]);
		}
		return HxOverrides.iter(a);
	}
	,set: function(key,value) {
		var id = key.__id__ != null?key.__id__:key.__id__ = ++haxe.ds.ObjectMap.count;
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,__class__: haxe.ds.ObjectMap
}
haxe.ds.StringMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.StringMap"] = haxe.ds.StringMap;
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
haxe.io = {}
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
$hxClasses["haxe.io.Bytes"] = haxe.io.Bytes;
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	return new haxe.io.Bytes(length,new Buffer(length));
}
haxe.io.Bytes.ofString = function(s) {
	var nb = new Buffer(s,"utf8");
	return new haxe.io.Bytes(nb.length,nb);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype = {
	getData: function() {
		return this.b;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length?this.length:other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var nb = new Buffer(len), slice = this.b.slice(pos,pos + len);
		slice.copy(nb,0,0,len);
		return new haxe.io.Bytes(len,nb);
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		src.b.copy(this.b,pos,srcpos,srcpos + len);
	}
	,set: function(pos,v) {
		this.b[pos] = v;
	}
	,get: function(pos) {
		return this.b[pos];
	}
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
var js = {}
js.Boot = function() { }
$hxClasses["js.Boot"] = js.Boot;
js.Boot.__name__ = ["js","Boot"];
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.NodeC = function() { }
$hxClasses["js.NodeC"] = js.NodeC;
js.NodeC.__name__ = ["js","NodeC"];
js.Node = function() { }
$hxClasses["js.Node"] = js.Node;
js.Node.__name__ = ["js","Node"];
js.Node.newSocket = function(options) {
	return new js.Node.net.Socket(options);
}
var org = {}
org.jinjor = {}
org.jinjor.haxemine = {}
org.jinjor.haxemine.messages = {}
org.jinjor.haxemine.messages.SocketMessage = function(socket,key) {
	var _g = this;
	this.funcs = new haxe.ds.StringMap();
	this.pub = function(data) {
		socket.emit(key,haxe.Serializer.run(data));
	};
	this.sub = function(subKey,f) {
		if(!_g.funcs.exists(subKey)) {
			_g.funcs.set(subKey,f);
			socket.on(key,function(data) {
				f(haxe.Unserializer.run(data));
			});
		}
	};
};
$hxClasses["org.jinjor.haxemine.messages.SocketMessage"] = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.SocketMessage.__name__ = ["org","jinjor","haxemine","messages","SocketMessage"];
org.jinjor.haxemine.messages.SocketMessage.prototype = {
	__class__: org.jinjor.haxemine.messages.SocketMessage
}
org.jinjor.haxemine.messages.AllHaxeFilesM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"search");
};
$hxClasses["org.jinjor.haxemine.messages.AllHaxeFilesM"] = org.jinjor.haxemine.messages.AllHaxeFilesM;
org.jinjor.haxemine.messages.AllHaxeFilesM.__name__ = ["org","jinjor","haxemine","messages","AllHaxeFilesM"];
org.jinjor.haxemine.messages.AllHaxeFilesM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.AllHaxeFilesM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.AllHaxeFilesM
});
org.jinjor.haxemine.messages.CompileError = function(originalMessage) {
	this.originalMessage = originalMessage;
	var parsed = org.jinjor.haxemine.messages.CompileError.parseCompileErrorMessage(originalMessage);
	this.path = parsed.path;
	this.row = parsed.row;
	this.message = parsed.message;
};
$hxClasses["org.jinjor.haxemine.messages.CompileError"] = org.jinjor.haxemine.messages.CompileError;
org.jinjor.haxemine.messages.CompileError.__name__ = ["org","jinjor","haxemine","messages","CompileError"];
org.jinjor.haxemine.messages.CompileError.parseCompileErrorMessage = function(message) {
	var elms = message.split(":");
	console.log(elms);
	return { path : elms[0], row : Std.parseInt(elms[1]), message : elms[elms.length - 1]};
}
org.jinjor.haxemine.messages.CompileError.prototype = {
	__class__: org.jinjor.haxemine.messages.CompileError
}
org.jinjor.haxemine.messages.DoTaskM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"doTask");
};
$hxClasses["org.jinjor.haxemine.messages.DoTaskM"] = org.jinjor.haxemine.messages.DoTaskM;
org.jinjor.haxemine.messages.DoTaskM.__name__ = ["org","jinjor","haxemine","messages","DoTaskM"];
org.jinjor.haxemine.messages.DoTaskM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.DoTaskM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.DoTaskM
});
org.jinjor.haxemine.messages.DoTasksM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"doTasks");
};
$hxClasses["org.jinjor.haxemine.messages.DoTasksM"] = org.jinjor.haxemine.messages.DoTasksM;
org.jinjor.haxemine.messages.DoTasksM.__name__ = ["org","jinjor","haxemine","messages","DoTasksM"];
org.jinjor.haxemine.messages.DoTasksM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.DoTasksM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.DoTasksM
});
org.jinjor.haxemine.messages.FileDetail = function(text,mode) {
	this.text = text;
	this.mode = mode;
};
$hxClasses["org.jinjor.haxemine.messages.FileDetail"] = org.jinjor.haxemine.messages.FileDetail;
org.jinjor.haxemine.messages.FileDetail.__name__ = ["org","jinjor","haxemine","messages","FileDetail"];
org.jinjor.haxemine.messages.FileDetail.prototype = {
	__class__: org.jinjor.haxemine.messages.FileDetail
}
org.jinjor.haxemine.messages.InitialInfoDto = function(projectRoot,allFiles,taskInfos,searchEnabled) {
	this.projectRoot = projectRoot;
	this.allFiles = allFiles;
	this.taskInfos = taskInfos;
	this.searchEnabled = searchEnabled;
};
$hxClasses["org.jinjor.haxemine.messages.InitialInfoDto"] = org.jinjor.haxemine.messages.InitialInfoDto;
org.jinjor.haxemine.messages.InitialInfoDto.__name__ = ["org","jinjor","haxemine","messages","InitialInfoDto"];
org.jinjor.haxemine.messages.InitialInfoDto.prototype = {
	__class__: org.jinjor.haxemine.messages.InitialInfoDto
}
org.jinjor.haxemine.messages.InitialInfoM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"initialInfo");
};
$hxClasses["org.jinjor.haxemine.messages.InitialInfoM"] = org.jinjor.haxemine.messages.InitialInfoM;
org.jinjor.haxemine.messages.InitialInfoM.__name__ = ["org","jinjor","haxemine","messages","InitialInfoM"];
org.jinjor.haxemine.messages.InitialInfoM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.InitialInfoM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.InitialInfoM
});
org.jinjor.haxemine.messages.SaveFileDto = function(fileName,text) {
	this.fileName = fileName;
	this.text = text;
};
$hxClasses["org.jinjor.haxemine.messages.SaveFileDto"] = org.jinjor.haxemine.messages.SaveFileDto;
org.jinjor.haxemine.messages.SaveFileDto.__name__ = ["org","jinjor","haxemine","messages","SaveFileDto"];
org.jinjor.haxemine.messages.SaveFileDto.prototype = {
	__class__: org.jinjor.haxemine.messages.SaveFileDto
}
org.jinjor.haxemine.messages.SaveM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"save");
};
$hxClasses["org.jinjor.haxemine.messages.SaveM"] = org.jinjor.haxemine.messages.SaveM;
org.jinjor.haxemine.messages.SaveM.__name__ = ["org","jinjor","haxemine","messages","SaveM"];
org.jinjor.haxemine.messages.SaveM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.SaveM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.SaveM
});
org.jinjor.haxemine.messages.SearchM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"search");
};
$hxClasses["org.jinjor.haxemine.messages.SearchM"] = org.jinjor.haxemine.messages.SearchM;
org.jinjor.haxemine.messages.SearchM.__name__ = ["org","jinjor","haxemine","messages","SearchM"];
org.jinjor.haxemine.messages.SearchM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.SearchM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.SearchM
});
org.jinjor.haxemine.messages.SearchResult = function(fileName,row,message) {
	this.fileName = fileName;
	this.row = row;
	this.message = message;
};
$hxClasses["org.jinjor.haxemine.messages.SearchResult"] = org.jinjor.haxemine.messages.SearchResult;
org.jinjor.haxemine.messages.SearchResult.__name__ = ["org","jinjor","haxemine","messages","SearchResult"];
org.jinjor.haxemine.messages.SearchResult.prototype = {
	__class__: org.jinjor.haxemine.messages.SearchResult
}
org.jinjor.haxemine.messages.SearchResultM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"search-result");
};
$hxClasses["org.jinjor.haxemine.messages.SearchResultM"] = org.jinjor.haxemine.messages.SearchResultM;
org.jinjor.haxemine.messages.SearchResultM.__name__ = ["org","jinjor","haxemine","messages","SearchResultM"];
org.jinjor.haxemine.messages.SearchResultM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.SearchResultM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.SearchResultM
});
org.jinjor.haxemine.messages.SourceFile = function(pathFromProjectRoot) {
	this.pathFromProjectRoot = pathFromProjectRoot;
	var splitted = pathFromProjectRoot.split("/");
	this.shortName = splitted[splitted.length - 1];
};
$hxClasses["org.jinjor.haxemine.messages.SourceFile"] = org.jinjor.haxemine.messages.SourceFile;
org.jinjor.haxemine.messages.SourceFile.__name__ = ["org","jinjor","haxemine","messages","SourceFile"];
org.jinjor.haxemine.messages.SourceFile.equals = function(o1,o2) {
	if(o1 == null || o2 == null) return false;
	return o1.pathFromProjectRoot == o2.pathFromProjectRoot;
}
org.jinjor.haxemine.messages.SourceFile.prototype = {
	__class__: org.jinjor.haxemine.messages.SourceFile
}
org.jinjor.haxemine.messages.TaskInfo = function(taskName,content,auto) {
	this.taskName = taskName;
	this.content = content;
	this.auto = auto;
};
$hxClasses["org.jinjor.haxemine.messages.TaskInfo"] = org.jinjor.haxemine.messages.TaskInfo;
org.jinjor.haxemine.messages.TaskInfo.__name__ = ["org","jinjor","haxemine","messages","TaskInfo"];
org.jinjor.haxemine.messages.TaskInfo.prototype = {
	__class__: org.jinjor.haxemine.messages.TaskInfo
}
org.jinjor.haxemine.messages.TaskProgress = function(taskName,compileErrors) {
	this.taskName = taskName;
	this.compileErrors = compileErrors;
};
$hxClasses["org.jinjor.haxemine.messages.TaskProgress"] = org.jinjor.haxemine.messages.TaskProgress;
org.jinjor.haxemine.messages.TaskProgress.__name__ = ["org","jinjor","haxemine","messages","TaskProgress"];
org.jinjor.haxemine.messages.TaskProgress.prototype = {
	__class__: org.jinjor.haxemine.messages.TaskProgress
}
org.jinjor.haxemine.messages.TaskProgressM = function(socket) {
	org.jinjor.haxemine.messages.SocketMessage.call(this,socket,"taskProgress");
};
$hxClasses["org.jinjor.haxemine.messages.TaskProgressM"] = org.jinjor.haxemine.messages.TaskProgressM;
org.jinjor.haxemine.messages.TaskProgressM.__name__ = ["org","jinjor","haxemine","messages","TaskProgressM"];
org.jinjor.haxemine.messages.TaskProgressM.__super__ = org.jinjor.haxemine.messages.SocketMessage;
org.jinjor.haxemine.messages.TaskProgressM.prototype = $extend(org.jinjor.haxemine.messages.SocketMessage.prototype,{
	__class__: org.jinjor.haxemine.messages.TaskProgressM
});
org.jinjor.haxemine.server = {}
org.jinjor.haxemine.server.Console = function() { }
$hxClasses["org.jinjor.haxemine.server.Console"] = org.jinjor.haxemine.server.Console;
org.jinjor.haxemine.server.Console.__name__ = ["org","jinjor","haxemine","server","Console"];
org.jinjor.haxemine.server.Console.print = function(s,author) {
	console.log((author || "haxemine") + " > " + s);
}
org.jinjor.haxemine.server.FileUtil = function() {
};
$hxClasses["org.jinjor.haxemine.server.FileUtil"] = org.jinjor.haxemine.server.FileUtil;
org.jinjor.haxemine.server.FileUtil.__name__ = ["org","jinjor","haxemine","server","FileUtil"];
org.jinjor.haxemine.server.FileUtil.getAllMatchedFiles = function(root,filter,_callback) {
	org.jinjor.haxemine.server.FileUtil.walk(root,function(err,results) {
		if(err != null) _callback(err,null); else {
			var all = [];
			org.jinjor.haxemine.server.FileUtil.async.map(results,function(item,cb) {
				if(filter(item)) cb(null,item.split("" + root + "/")[1]); else cb(null,null);
			},function(err1,items) {
				items.forEach(function(item) {
					if(item != null) all.push(item);
				});
			});
			_callback(null,all);
		}
	});
}
org.jinjor.haxemine.server.FileUtil.walk = function(dir,done) {
	var results = [];
	org.jinjor.haxemine.server.FileUtil.fs.readdir(dir,function(err,list) {
		if(err != null) return done(err,null);
		var pending = list.length;
		if(pending == 0) return done(null,results);
		list.forEach(function(file) {
			file = "" + dir + "/" + file;
			org.jinjor.haxemine.server.FileUtil.fs.stat(file,function(err1,stat) {
				if(stat != null && stat.isDirectory()) org.jinjor.haxemine.server.FileUtil.walk(file,function(err2,res) {
					results = results.concat(res);
					if(--pending == 0) done(null,results);
				}); else {
					results.push(file);
					if(--pending == 0) done(null,results);
				}
			});
			return true;
		});
		return;
	});
}
org.jinjor.haxemine.server.FileUtil.prototype = {
	__class__: org.jinjor.haxemine.server.FileUtil
}
org.jinjor.haxemine.server.HaxemineConfig = function(port,hxml) {
	this.port = port;
	this.hxml = hxml;
};
$hxClasses["org.jinjor.haxemine.server.HaxemineConfig"] = org.jinjor.haxemine.server.HaxemineConfig;
org.jinjor.haxemine.server.HaxemineConfig.__name__ = ["org","jinjor","haxemine","server","HaxemineConfig"];
org.jinjor.haxemine.server.HaxemineConfig.prototype = {
	__class__: org.jinjor.haxemine.server.HaxemineConfig
}
org.jinjor.haxemine.server.HaxemineConfigDao = function() {
};
$hxClasses["org.jinjor.haxemine.server.HaxemineConfigDao"] = org.jinjor.haxemine.server.HaxemineConfigDao;
org.jinjor.haxemine.server.HaxemineConfigDao.__name__ = ["org","jinjor","haxemine","server","HaxemineConfigDao"];
org.jinjor.haxemine.server.HaxemineConfigDao.makeConfpath = function(projectRoot) {
	return "" + projectRoot + "/" + "haxemine.json";
}
org.jinjor.haxemine.server.HaxemineConfigDao.getAllHxmlFiles = function(projectRoot,_callback) {
	var filter = function(item) {
		return StringTools.endsWith(item,".hxml");
	};
	org.jinjor.haxemine.server.FileUtil.getAllMatchedFiles(projectRoot,filter,_callback);
}
org.jinjor.haxemine.server.HaxemineConfigDao.prototype = {
	create: function(process,projectRoot,onCreate,onCancel) {
		var confPath = org.jinjor.haxemine.server.HaxemineConfigDao.makeConfpath(projectRoot);
		org.jinjor.haxemine.server.Console.print("" + "haxemine.json" + " is required in current directory.");
		org.jinjor.haxemine.server.Console.print("create " + "haxemine.json" + " here? [y/n]");
		var rli = org.jinjor.haxemine.server.HaxemineConfigDao.readline.createInterface(process.stdin,process.stdout);
		rli.on("line",function(cmd) {
			if(cmd == "y") org.jinjor.haxemine.server.HaxemineConfigDao.getAllHxmlFiles(projectRoot,function(err,files) {
				if(err != null) {
					org.jinjor.haxemine.server.Console.print(err);
					throw err;
				}
				files.sort(function(f1,f2) {
					return StringTools.startsWith(f1,"build") && StringTools.startsWith(f2,"compile")?1:-1;
				});
				var xhml = Lambda.array(files.map(function(file) {
					return { path : file, auto : true};
				}));
				var conf = new org.jinjor.haxemine.server.HaxemineConfig(8765,xhml);
				var confJson = JSON.stringify(conf,null," ");
				org.jinjor.haxemine.server.HaxemineConfigDao.fs.writeFileSync(confPath,confJson,"utf8");
				org.jinjor.haxemine.server.Console.print("created haxemine.conf\n" + confJson);
				org.jinjor.haxemine.server.Console.print("modify haxemine.conf and restart haxemine.");
				onCreate();
				process.exit(0);
			}); else if(cmd == "n") {
				process.stdin.destroy();
				onCancel();
			}
			rli.prompt();
		});
	}
	,get: function(projectRoot) {
		var confPath = org.jinjor.haxemine.server.HaxemineConfigDao.makeConfpath(projectRoot);
		if(!org.jinjor.haxemine.server.HaxemineConfigDao.path.existsSync(confPath)) return null;
		var conf = haxe.Json.parse(org.jinjor.haxemine.server.HaxemineConfigDao.fs.readFileSync(confPath,"utf8"));
		conf.port = conf.port || 8765;
		var _g = 0, _g1 = conf.hxml;
		while(_g < _g1.length) {
			var hxml = _g1[_g];
			++_g;
			hxml.auto = hxml.auto || true;
		}
		return conf;
	}
	,__class__: org.jinjor.haxemine.server.HaxemineConfigDao
}
org.jinjor.haxemine.server.Main = function() { }
$hxClasses["org.jinjor.haxemine.server.Main"] = org.jinjor.haxemine.server.Main;
org.jinjor.haxemine.server.Main.__name__ = ["org","jinjor","haxemine","server","Main"];
org.jinjor.haxemine.server.Main.main = function() {
	org.jinjor.haxemine.server.Main.sourcemap.install();
	var projectRoot = ".";
	var confDao = new org.jinjor.haxemine.server.HaxemineConfigDao();
	var conf = confDao.get(projectRoot);
	if(conf == null) {
		var _process = process;
		confDao.create(_process,projectRoot,function() {
			_process.exit(0);
		},function() {
			_process.exit(0);
		});
	} else org.jinjor.haxemine.server.Main.startApp(projectRoot,conf);
}
org.jinjor.haxemine.server.Main.startApp = function(projectRoot,conf) {
	org.jinjor.haxemine.server.Console.print("projectRoot:" + projectRoot);
	org.jinjor.haxemine.server.Console.print("port:" + conf.port);
	var taskInfos = Lambda.array(conf.hxml.map(function(hxml) {
		var name = hxml.path;
		var content = org.jinjor.haxemine.server.Main.fs.readFileSync("" + projectRoot + "/" + hxml.path,"utf8");
		return new org.jinjor.haxemine.messages.TaskInfo(name,content,hxml.auto == null?true:hxml.auto);
	}));
	var _path = org.jinjor.haxemine.server.Main.path;
	var _express = org.jinjor.haxemine.server.Main.express;
	var app = org.jinjor.haxemine.server.Main.express();
	console.log(__dirname + "/public/favicon.ico");
	app.configure(function() {
		app.set("port",conf.port);
		app["use"](org.jinjor.haxemine.server.Main.express.favicon(__dirname + "/public/favicon.ico"));
		app["use"](org.jinjor.haxemine.server.Main.express.logger("dev"));
		app["use"](org.jinjor.haxemine.server.Main.express.bodyParser());
		app["use"](org.jinjor.haxemine.server.Main.express.methodOverride());
		app["use"](app.router);
		app["use"](eval("_express.static(_path.join(__dirname, 'public'))"));
	});
	app.get("/",function(req,res) {
		res.writeHead(200,{ 'Content-Type' : "text/html"});
		var rs = org.jinjor.haxemine.server.Main.fs.createReadStream(__dirname + "/index.html");
		org.jinjor.haxemine.server.Main.sys.pump(rs,res);
	});
	app.get("/test",function(req,res) {
		res.writeHead(200,{ 'Content-Type' : "text/html"});
		var rs = org.jinjor.haxemine.server.Main.fs.createReadStream("SpecRunner.html");
		org.jinjor.haxemine.server.Main.sys.pump(rs,res);
	});
	app.get("/src",function(req,res) {
		var fileName = req.query.fileName;
		if(fileName == null) res.send(); else {
			res.contentType("application/json");
			console.log(req.query.fileName);
			res.send(js.Node.stringify(org.jinjor.haxemine.server.Service.findFromSrc("" + projectRoot + "/" + fileName),null,null));
		}
	});
	var server = org.jinjor.haxemine.server.Main.http.createServer(app);
	server.listen(app.get("port"),function() {
		org.jinjor.haxemine.server.Console.print("haxemine listening on port " + Std.string(app.get("port")));
	});
	var io = org.jinjor.haxemine.server.Main.socketio.listen(server,{ 'log level' : 1});
	io.sockets.on("connection",function(socket) {
		var initialInfoM = new org.jinjor.haxemine.messages.InitialInfoM(socket);
		var allHaxeFilesM = new org.jinjor.haxemine.messages.AllHaxeFilesM(socket);
		var searchResultM = new org.jinjor.haxemine.messages.SearchResultM(socket);
		var searchM = new org.jinjor.haxemine.messages.SearchM(socket);
		var saveM = new org.jinjor.haxemine.messages.SaveM(socket);
		var doTaskM = new org.jinjor.haxemine.messages.DoTaskM(socket);
		var doTasksM = new org.jinjor.haxemine.messages.DoTasksM(socket);
		var taskProgressM = new org.jinjor.haxemine.messages.TaskProgressM(socket);
		org.jinjor.haxemine.server.Console.print("connection");
		org.jinjor.haxemine.server.Service.getAllHaxeFiles(projectRoot,function(err,files) {
			if(err != null) {
				console.log(err);
				throw err;
			}
			initialInfoM.pub(new org.jinjor.haxemine.messages.InitialInfoDto(projectRoot,files,taskInfos,org.jinjor.haxemine.server.OS.isWin()));
		});
		saveM.sub("Main.startApp",function(saveFileDto) {
			if(saveFileDto.fileName == null) {
				console.log(saveFileDto);
				throw "bad request.";
			}
			org.jinjor.haxemine.server.Service.save(projectRoot,saveFileDto,allHaxeFilesM,socket);
			org.jinjor.haxemine.server.Service.doAutoTasks(conf,projectRoot,socket,taskProgressM);
		});
		doTaskM.sub("Main.startApp",function(taskName) {
			org.jinjor.haxemine.server.Service.doTask(conf,projectRoot,socket,taskProgressM,taskName);
		});
		doTasksM.sub("Main.startApp",function(_) {
			org.jinjor.haxemine.server.Service.doAutoTasks(conf,projectRoot,socket,taskProgressM);
		});
		socket.on("disconnect",function() {
			org.jinjor.haxemine.server.Console.print("disconnect");
		});
		searchM.sub("Main.startApp",function(word) {
			org.jinjor.haxemine.server.Service.searchWord(word,function(err,result) {
				searchResultM.pub(result);
			});
		});
	});
}
org.jinjor.haxemine.server.OS = function() { }
$hxClasses["org.jinjor.haxemine.server.OS"] = org.jinjor.haxemine.server.OS;
org.jinjor.haxemine.server.OS.__name__ = ["org","jinjor","haxemine","server","OS"];
org.jinjor.haxemine.server.OS.isWin = function() {
	return StringTools.startsWith(org.jinjor.haxemine.server.OS.type().toLowerCase(),"win");
}
org.jinjor.haxemine.server.OS.type = function() {
	return org.jinjor.haxemine.server.OS.os.type();
}
org.jinjor.haxemine.server.Service = function() {
};
$hxClasses["org.jinjor.haxemine.server.Service"] = org.jinjor.haxemine.server.Service;
org.jinjor.haxemine.server.Service.__name__ = ["org","jinjor","haxemine","server","Service"];
org.jinjor.haxemine.server.Service.save = function(projectRoot,data,allHaxeFilesM,socket) {
	var _path = "" + projectRoot + "/" + data.fileName;
	var isNew = !org.jinjor.haxemine.server.Service.path.existsSync(_path);
	org.jinjor.haxemine.server.Service.saveToSrc(org.jinjor.haxemine.server.Service.fs,_path,data.text);
	if(isNew) org.jinjor.haxemine.server.Service.getAllHaxeFiles(projectRoot,function(err,files) {
		if(err != null) {
			console.log(err);
			throw err;
		}
		allHaxeFilesM.pub(files);
	});
	socket.emit("stdout","saved");
}
org.jinjor.haxemine.server.Service.doTask = function(conf,projectRoot,socket,taskProgressM,taskName) {
	var tasks = Lambda.array(conf.hxml.filter(function(hxml) {
		return hxml.path == taskName;
	}).map(function(hxml) {
		var task = org.jinjor.haxemine.server.Service.createCompileHaxeTask(socket,taskProgressM,projectRoot,hxml.path);
		return task;
	}));
	org.jinjor.haxemine.server.Service.async.series(tasks,function() {
	});
}
org.jinjor.haxemine.server.Service.doAutoTasks = function(conf,projectRoot,socket,taskProgressM) {
	var tasks = Lambda.array(conf.hxml.filter(function(hxml) {
		return hxml.auto != null && hxml.auto;
	}).map(function(hxml) {
		var task = org.jinjor.haxemine.server.Service.createCompileHaxeTask(socket,taskProgressM,projectRoot,hxml.path);
		return task;
	}));
	org.jinjor.haxemine.server.Service.async.series(tasks,function() {
	});
}
org.jinjor.haxemine.server.Service.searchWord = function(word,cb) {
	if(!org.jinjor.haxemine.server.OS.isWin()) throw "search unsupported ."; else {
		var command = "findstr /N /S " + word + " *.hx";
		org.jinjor.haxemine.server.Console.print(command);
		org.jinjor.haxemine.server.Service.childProcess.exec(command,function(err,stdout,stderr) {
			if(err != null) cb(null,[]); else {
				var messages = stdout.split("\n");
				var results = Lambda.array(messages.filter(function(message) {
					return message != "";
				}).map(function(message) {
					console.log(message);
					var fileName = StringTools.replace(message.split(":")[0],"\\","/");
					var row = Std.parseInt(message.split(":")[1]);
					return new org.jinjor.haxemine.messages.SearchResult(fileName,row,message);
				}));
				cb(null,results);
			}
		});
	}
}
org.jinjor.haxemine.server.Service.findFromSrc = function(fileName) {
	return new org.jinjor.haxemine.messages.FileDetail(org.jinjor.haxemine.server.Service.fs.readFileSync(fileName,"utf8"),"haxe");
}
org.jinjor.haxemine.server.Service.saveToSrc = function(fs,fileName,text) {
	fs.writeFileSync(fileName,text,"utf8");
}
org.jinjor.haxemine.server.Service.createCompileHaxeTask = function(socket,taskProgressM,projectRoot,hxmlPath) {
	return function(callBack) {
		org.jinjor.haxemine.server.Service.compileHaxe(socket,taskProgressM,projectRoot,hxmlPath,callBack);
	};
}
org.jinjor.haxemine.server.Service.compileHaxe = function(socket,taskProgressM,projectRoot,hxmlPath,callBack) {
	org.jinjor.haxemine.server.Service.childProcess.exec("haxe " + hxmlPath,{ cwd : projectRoot},function(err,stdout,stderr) {
		if(err != null) org.jinjor.haxemine.server.Console.print(stderr,hxmlPath);
		socket.emit("stdout",stdout);
		var compileErrors = err?(function($this) {
			var $r;
			var msg = stderr;
			var messages = msg.split("\n");
			var compileErrors1 = Lambda.array(messages.map(function(message) {
				if(StringTools.startsWith(message,"./")) message = message.substring("./".length);
				return new org.jinjor.haxemine.messages.CompileError(message);
			}));
			$r = compileErrors1;
			return $r;
		}(this)):[];
		taskProgressM.pub(new org.jinjor.haxemine.messages.TaskProgress(hxmlPath,compileErrors));
		callBack(err);
	});
}
org.jinjor.haxemine.server.Service.getAllHaxeFiles = function(projectRoot,_callback) {
	var filter = function(item) {
		return StringTools.endsWith(item,".hx");
	};
	org.jinjor.haxemine.server.FileUtil.getAllMatchedFiles(projectRoot,filter,function(err,filePaths) {
		if(err != null) _callback(err,null); else {
			var files = new haxe.ds.StringMap();
			Lambda.foreach(filePaths,function(f) {
				files.set(f,new org.jinjor.haxemine.messages.SourceFile(f));
				return true;
			});
			_callback(null,files);
		}
	});
}
org.jinjor.haxemine.server.Service.prototype = {
	__class__: org.jinjor.haxemine.server.Service
}
org.jinjor.util = {}
org.jinjor.util.Util = function() { }
$hxClasses["org.jinjor.util.Util"] = org.jinjor.util.Util;
org.jinjor.util.Util.__name__ = ["org","jinjor","util","Util"];
org.jinjor.util.Util.or = function(a,b) {
	return a || b;
}
org.jinjor.util.Util.and = function(a,b) {
	return a && b;
}
org.jinjor.util.Util.compareTo = function(a,b) {
	return a < b?-1:a > b?1:0;
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
js.Node.__filename = __filename;
js.Node.__dirname = __dirname;
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
js.Node.util = js.Node.require("util");
js.Node.fs = js.Node.require("fs");
js.Node.net = js.Node.require("net");
js.Node.http = js.Node.require("http");
js.Node.https = js.Node.require("https");
js.Node.path = js.Node.require("path");
js.Node.url = js.Node.require("url");
js.Node.os = js.Node.require("os");
js.Node.crypto = js.Node.require("crypto");
js.Node.dns = js.Node.require("dns");
js.Node.queryString = js.Node.require("querystring");
js.Node.assert = js.Node.require("assert");
js.Node.childProcess = js.Node.require("child_process");
js.Node.vm = js.Node.require("vm");
js.Node.tls = js.Node.require("tls");
js.Node.dgram = js.Node.require("dgram");
js.Node.assert = js.Node.require("assert");
js.Node.repl = js.Node.require("repl");
js.Node.cluster = js.Node.require("cluster");
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.ds.ObjectMap.count = 0;
js.NodeC.UTF8 = "utf8";
js.NodeC.ASCII = "ascii";
js.NodeC.BINARY = "binary";
js.NodeC.BASE64 = "base64";
js.NodeC.HEX = "hex";
js.NodeC.EVENT_EVENTEMITTER_NEWLISTENER = "newListener";
js.NodeC.EVENT_EVENTEMITTER_ERROR = "error";
js.NodeC.EVENT_STREAM_DATA = "data";
js.NodeC.EVENT_STREAM_END = "end";
js.NodeC.EVENT_STREAM_ERROR = "error";
js.NodeC.EVENT_STREAM_CLOSE = "close";
js.NodeC.EVENT_STREAM_DRAIN = "drain";
js.NodeC.EVENT_STREAM_CONNECT = "connect";
js.NodeC.EVENT_STREAM_SECURE = "secure";
js.NodeC.EVENT_STREAM_TIMEOUT = "timeout";
js.NodeC.EVENT_STREAM_PIPE = "pipe";
js.NodeC.EVENT_PROCESS_EXIT = "exit";
js.NodeC.EVENT_PROCESS_UNCAUGHTEXCEPTION = "uncaughtException";
js.NodeC.EVENT_PROCESS_SIGINT = "SIGINT";
js.NodeC.EVENT_PROCESS_SIGUSR1 = "SIGUSR1";
js.NodeC.EVENT_CHILDPROCESS_EXIT = "exit";
js.NodeC.EVENT_HTTPSERVER_REQUEST = "request";
js.NodeC.EVENT_HTTPSERVER_CONNECTION = "connection";
js.NodeC.EVENT_HTTPSERVER_CLOSE = "close";
js.NodeC.EVENT_HTTPSERVER_UPGRADE = "upgrade";
js.NodeC.EVENT_HTTPSERVER_CLIENTERROR = "clientError";
js.NodeC.EVENT_HTTPSERVERREQUEST_DATA = "data";
js.NodeC.EVENT_HTTPSERVERREQUEST_END = "end";
js.NodeC.EVENT_CLIENTREQUEST_RESPONSE = "response";
js.NodeC.EVENT_CLIENTRESPONSE_DATA = "data";
js.NodeC.EVENT_CLIENTRESPONSE_END = "end";
js.NodeC.EVENT_NETSERVER_CONNECTION = "connection";
js.NodeC.EVENT_NETSERVER_CLOSE = "close";
js.NodeC.FILE_READ = "r";
js.NodeC.FILE_READ_APPEND = "r+";
js.NodeC.FILE_WRITE = "w";
js.NodeC.FILE_WRITE_APPEND = "a+";
js.NodeC.FILE_READWRITE = "a";
js.NodeC.FILE_READWRITE_APPEND = "a+";
org.jinjor.haxemine.server.FileUtil.async = js.Node.require("async");
org.jinjor.haxemine.server.FileUtil.fs = js.Node.require("fs");
org.jinjor.haxemine.server.HaxemineConfigDao.CONF_FILE = "haxemine.json";
org.jinjor.haxemine.server.HaxemineConfigDao.path = js.Node.require("path");
org.jinjor.haxemine.server.HaxemineConfigDao.fs = js.Node.require("fs");
org.jinjor.haxemine.server.HaxemineConfigDao.readline = js.Node.require("readline");
org.jinjor.haxemine.server.Main.express = js.Node.require("express");
org.jinjor.haxemine.server.Main.fs = js.Node.require("fs");
org.jinjor.haxemine.server.Main.sys = js.Node.require("sys");
org.jinjor.haxemine.server.Main.http = js.Node.require("http");
org.jinjor.haxemine.server.Main.path = js.Node.require("path");
org.jinjor.haxemine.server.Main.readline = js.Node.require("readline");
org.jinjor.haxemine.server.Main.socketio = js.Node.require("socket.io");
org.jinjor.haxemine.server.Main.childProcess = js.Node.require("child_process");
org.jinjor.haxemine.server.Main.async = js.Node.require("async");
org.jinjor.haxemine.server.Main.sourcemap = js.Node.require("source-map-support");
org.jinjor.haxemine.server.OS.os = js.Node.require("os");
org.jinjor.haxemine.server.Service.fs = js.Node.require("fs");
org.jinjor.haxemine.server.Service.childProcess = js.Node.require("child_process");
org.jinjor.haxemine.server.Service.async = js.Node.require("async");
org.jinjor.haxemine.server.Service.path = js.Node.require("path");
org.jinjor.haxemine.server.Main.main();
})();

//@ sourceMappingURL=haxemine.js.map