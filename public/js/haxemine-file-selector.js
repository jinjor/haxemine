org.jinjor.haxemine.HaxeFile = Backbone.Model.extend();
org.jinjor.haxemine.HaxeFileRow = Backbone.View.extend({
  tagName: "li",
  //className: "document-row",
  template: _.template('<a><%= errors.length > 0 ? "error!" : "" %><%- shortName %></a>'),
  events: {
    "click": "open",
  },
  open: function() {
    alert('open');
    this.trigger("openFile", this.model.get('filePath'));
  },
  initialize: function() {
    this.listenTo(this.model, "change:errors", this.render);
    //this.render();//TODO
  },
  render: function() {
    return this.$el.html(this.template(this.model.attributes));
  }
});
org.jinjor.haxemine.HaxeFileSelector = Backbone.View.extend({
  tagName: "ul",
  initialize: function() {
    var that = this;
    this.views = this.model.map(function(file){
      console.log(file);
      var view = new org.jinjor.haxemine.HaxeFileRow({model: file, id:'haxe-file:' + file.get('filePath')});
      view.on('openFile', function(filePath){
        that.trigger("openFile", filePath);//TODO スルーパスする方法
      });
      return view;
    });
    //this.render();//TODO
  },
  render: function() {
    var that = this;
    return this.views.reduce(function($el, view){
      $el.append(view.render());
      return $el;
    }, this.$el.empty());
  }
});