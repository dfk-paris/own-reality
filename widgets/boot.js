Zepto(document).ready(function(event) {
  var style_tag = Zepto('<link rel="stylesheet" type="text/css">')

  var tag = style_tag.clone().attr('href', wApp.api_url() + '/vendor.css')
  Zepto('head').append(tag)

  tag = style_tag.clone().attr('href', wApp.api_url() + '/app.css')
  Zepto('head').append(tag)

  wApp.setup();
});