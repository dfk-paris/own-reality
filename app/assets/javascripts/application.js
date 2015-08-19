//= require jquery
//= require jquery-ui
//= require vendor/angular.min
//= require vendor/angular-route.min
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

var app = angular.module("or", ["ngRoute", "ngSanitize", "web-utils"]);

(function(){
  var injector = angular.injector(['ng']);
  var http = injector.get('$http');
  promise = http({method: 'get', url: 'api/translations'});

  promise.success(function(data) {
    app.value('orTranslations', data);
    angular.bootstrap(document, ["or"]);
  });
})();