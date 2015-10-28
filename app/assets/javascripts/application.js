//= require jquery
//= require jquery-ui
//= require vendor/angular.min
//= require vendor/angular-route.min
//= require vendor/angular-ui-router.min
//= require vendor/angular-sanitize.min
//= require vendor/bootstrap.min
//= require vendor/web-utils
//= require vendor/web-utils-angular
//= require vendor/pdfobject
//= require vendor/vis.min
//= require_self
//= require ./app
//= require_tree ./controllers
//= require_tree ./services
//= require_tree ./directives
//= require ./filters

var app = angular.module("or", ["ui.router", "ngSanitize", "web-utils"]);

(function(){
  var injector = angular.injector(['ng']);
  var http = injector.get('$http');
  var translate_promise = http({method: 'get', url: 'api/translations'});
  var misc_promise = http({method: 'get', url: 'api/misc'});

  translate_promise.success(function(translate_data) {
    misc_promise.success(function(misc_data) {
      app.value('orTranslations', translate_data);
      app.value('orMisc', misc_data);
      angular.bootstrap(document, ["or"]);
    });
  });
})();