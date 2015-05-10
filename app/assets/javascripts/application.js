//= require jquery
//= require jquery-ui
//= require angular
//= require angular-route
//= require twitter/bootstrap
//= require_self
//= require_tree .

jQuery.ready(function(event){
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
});

var app = angular.module("or", ["ngRoute"]);