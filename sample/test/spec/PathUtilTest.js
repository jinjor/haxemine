describe('PathUtil', function(){
  
  var PathUtil = org.jinjor.haxeminesample.util.PathUtil;

  beforeEach(function(){
    localStorage.clear();
    console.log('muho');
  });
  
  it('should join without dupplicating slashes', function(){
    console.log('hogo');
    expect(PathUtil.join('a', 'b')).toEqual('a/b');
    expect(PathUtil.join('a', '/b')).toEqual('a/b');
    expect(PathUtil.join('a/', '/b')).toEqual('a/b');
    expect(PathUtil.join('a/', '/b')).toEqual('a/b');
    console.log('muge');
  });
 
});