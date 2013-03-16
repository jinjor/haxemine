describe('PathUtil', function(){
  
  var PathUtil = org.jinjor.haxeminesample.util.PathUtil;
  
  beforeEach(function(){
    localStorage.clear();
  });
  
  it('should join without dupplicating slashes', function(){
    expect(PathUtil.join('a', 'b')).toEqual('a/b');
    expect(PathUtil.join('a', '/b')).toEqual('a/b');
    expect(PathUtil.join('a/', '/b')).toEqual('a/b');
    expect(PathUtil.join('a/', '/b')).toEqual('a/b');
  });
 
});