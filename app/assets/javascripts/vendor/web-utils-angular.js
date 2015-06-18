(function() {
  var m;

  m = angular.module("web-utils", []);

  m.service("wuBase64Location", [
    "$location", "$window", function(l, w) {
      var service;
      return service = {
        key: "q",
        pack: function(obj) {
          return w.btoa(JSON.stringify(obj));
        },
        unpack: function(string) {
          return JSON.parse(w.atob(string));
        },
        get_base: function() {
          var result;
          result = l.search()[service.key];
          if (!angular.isString(result)) {
            return "e30=";
          } else {
            return result;
          }
        },
        get: function() {
          return service.unpack(service.get_base());
        },
        get_value: function(key) {
          return service.get()[key];
        },
        set: function(obj) {
          return l.search(service.key, service.pack(obj));
        },
        no_param: function() {
          return l.search()[service.key] === void 0;
        },
        url_to: function(obj) {
          var k, result, v;
          result = $.extend({}, service.get());
          for (k in obj) {
            v = obj[k];
            result[k] = v;
          }
          return service.pack(result);
        },
        update: function(obj) {
          var changes, k, result, v;
          result = $.extend({}, service.get());
          changes = false;
          for (k in obj) {
            v = obj[k];
            if (v !== obj[k]) {
              changes = true;
            }
            result[k] = v;
          }
          if (service.no_param) {
            changes = true;
          }
          if (changes) {
            return service.set(result);
          }
        },
        update_value: function(key, value) {
          var changes, data;
          data = service.get();
          changes = false;
          if (value === void 0 || value === null) {
            delete data[key];
            changes = true;
          } else {
            changes = data[key] !== value;
            data[key] = value;
          }
          if (changes) {
            return service.set(data);
          }
        },
        search: function(search, paramValue) {
          switch (arguments.length) {
            case 0:
              return service.get();
            case 1:
              if (angular.isString(search)) {
                return service.get()[search];
              } else if (angular.isObject(search)) {
                return service.update(search);
              } else {
                return service.get_value(search);
              }
              break;
            default:
              return service.update_value(search, paramValue);
          }
        }
      };
    }
  ]);

  m.directive("wuDraggable", [
    "$parse", function(parse) {
      var directive;
      return directive = {
        link: function(scope, element, attrs) {
          $(element).on("dragcreate", function(event, ui) {
            var fn;
            fn = parse(attrs.ngDraggableEventCreate);
            return fn(scope, {
              $event: event
            });
          });
          $(element).on("dragstart", function(event, ui) {
            var fn;
            fn = parse(attrs.ngDraggableEventStart);
            return fn(scope, {
              $event: event
            });
          });
          $(element).on("dragstop", function(event, ui) {
            var fn;
            fn = parse(attrs.ngDraggableEventStop);
            return fn(scope, {
              $event: event
            });
          });
          $(element).on("drag", function(event, ui) {
            var fn;
            fn = parse(attrs.ngDraggableEventDrag);
            return fn(scope, {
              $event: event,
              x: 12
            });
          });
          attrs.$observe("ngDraggableOptions", function(value) {
            var k, v, _ref, _results;
            _ref = scope.$eval(value);
            _results = [];
            for (k in _ref) {
              v = _ref[k];
              _results.push($(element).draggable("option", k, v));
            }
            return _results;
          });
          return $(element).draggable();
        }
      };
    }
  ]);

  m.service("wuEventually", [
    "$timeout", function(timeout) {
      var promises, service;
      promises = {};
      return service = {
        delay: 300,
        run: function(name, fn, delay) {
          if (delay == null) {
            delay = service.delay;
          }
          if (promises[name]) {
            timeout.cancel(promises[name]);
          }
          return promises[name] = timeout(fn, delay);
        }
      };
    }
  ]);

  m.directive("wuDelayedModel", [
    "wuEventually", function(ev) {
      var directive;
      return directive = {
        require: "?ngModel",
        link: function(scope, element, attrs, ngModel) {
          var oldSetViewValue;
          oldSetViewValue = ngModel.$setViewValue;
          return ngModel.$setViewValue = function(value) {
            var setter;
            setter = function() {
              return oldSetViewValue.apply(ngModel, [value]);
            };
            return ev.run(scope.$id, setter, attrs.eventualModel);
          };
        }
      };
    }
  ]);

  m.directive("wuFocusMe", [
    function() {
      var directive;
      return directive = {
        link: function(scope, element, attrs) {
          return element.focus();
        }
      };
    }
  ]);

  m.provider("wuHttp", {
    $get: [
      "$http", function(http) {
        var handlers, method_stack, service, stack;
        stack = [];
        method_stack = {};
        handlers = {
          success: [],
          error: []
        };
        service = function(request) {
          var method, promise, _base, _base1;
          request.headers || (request.headers = {});
          (_base = request.headers)['Accept'] || (_base['Accept'] = "application/json");
          (_base1 = request.headers)['content-type'] || (_base1['content-type'] = "application/json");
          request.cache = false;
          method = request.method.toLowerCase();
          promise = http(request);
          promise.success(function(data, status, headers, config) {
            var handler, _i, _len, _ref;
            if (service.log) {
              console.log(data);
            }
            _ref = handlers.success;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              handler = _ref[_i];
              handler(data, status, headers, config);
            }
            stack.pop();
            return method_stack[method].pop();
          });
          promise.error(function(data, status, headers, config) {
            var handler, _i, _len, _ref;
            if (service.log) {
              console.log(data);
            }
            _ref = handlers.error;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              handler = _ref[_i];
              handler(data, status, headers, config);
            }
            stack.pop();
            return method_stack[method].pop();
          });
          promise.error(function() {
            return stack.pop();
          });
          stack.push(promise);
          method_stack[method] || (method_stack[method] = []);
          method_stack[method].push(promise);
          return promise;
        };
        service.working = function(method) {
          if (method) {
            return angular.isArray(method_stack["get"]) && method_stack["get"].length > 0;
          } else {
            return stack.length > 0;
          }
        };
        service.log = false;
        service.handlers = function() {
          return handlers;
        };
        return service;
      }
    ]
  });

  m.service("in_groups_of", [
    function() {
      return function(array, per_row, fill) {
        var current, i, result, _i, _len;
        if (per_row == null) {
          per_row = 4;
        }
        if (fill == null) {
          fill = true;
        }
        result = [];
        current = [];
        for (_i = 0, _len = array.length; _i < _len; _i++) {
          i = array[_i];
          if (current.length === per_row) {
            result.push(current);
            current = [];
          }
          current.push(i);
        }
        if (current.length > 0) {
          if (fill) {
            while (current.length < per_row) {
              current.push({});
            }
          }
          result.push(current);
        }
        return result;
      };
    }
  ]);

  m.directive('wuLinkIf', [
    function() {
      return {
        transclude: 'element',
        priority: 1000,
        terminal: true,
        compile: function(compile_element, attr, linker) {
          return function(scope, link_element, attr) {
            var linked;
            linked = false;
            return scope.$watch(attr.ngLinkIf, function(newValue) {
              if (newValue && !linked) {
                linked = true;
                return linker(scope, function(clone) {
                  return link_element.after(clone);
                });
              }
            });
          };
        }
      };
    }
  ]);

  m.filter("wuPercent", function() {
    return function(input) {
      var num;
      num = parseFloat(input);
      if (num < 0) {
        return "n/a";
      } else if (num === 0) {
        return "0.00 %";
      } else if (num <= 1) {
        num = Math.round(num * 100) / 100 * 100;
        return "" + num + " %";
      } else if (num <= 100) {
        return "" + num + " %";
      } else {
        return "n/a";
      }
    };
  });

  m.service("wuPiwik", [
    "$location", function(location) {
      var service;
      return service = {
        configured: false,
        active: function() {
          return typeof _paq !== "undefined";
        },
        track: function() {
          if (service.active()) {
            return _paq.push(["trackPageView"]);
          }
        },
        configure: function(scope) {
          if (!service.configured) {
            scope.$on("$routeChangeSuccess", function(event) {
              return service.track();
            });
            scope.$on("$routeUpdate", function(event) {
              return service.track();
            });
            return service.configured = true;
          }
        }
      };
    }
  ]);

  m.service("wuRoutingWorkflow", [
    "wuBase64Location", function(le) {
      var service;
      return service = {
        configure: function(c) {
          var e, request, scope_change, search_change, _i, _len, _ref, _results;
          search_change = function(is_page_load) {
            if (is_page_load == null) {
              is_page_load = false;
            }
            if (is_page_load) {
              c.scope.page_loading = true;
              $.extend(true, c.scope, c.defaults, le.search());
            } else {
              request();
            }
            if (c.search_change) {
              return c.search_change(is_page_load);
            }
          };
          scope_change = function(new_value, old_value) {
            if ((c.scope.pagination || {}).page === c.loaded_page()) {
              c.scope.pagination.page = 1;
            }
            if (c.scope.page_loading) {
              c.scope.page_loading = false;
              request();
            } else {
              le.search(c.scope_params());
            }
            if (c.search_change) {
              return c.scope_change(new_value, old_value);
            }
          };
          request = function(params) {
            return c.request(params);
          };
          c.scope.$on("$routeChangeSuccess", function(event) {
            search_change(true);
            return event.preventDefault();
          });
          c.scope.$on("$routeUpdate", function(event) {
            return search_change(false);
          });
          _ref = c.scope_watch_expressions || [];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            e = _ref[_i];
            _results.push(c.scope.$watch(e, scope_change, true));
          }
          return _results;
        }
      };
    }
  ]);

  m.filter("wuStrftime", function() {
    return function(input, format) {
      var date, e;
      try {
        if (angular.isString(input)) {
          date = new Strftime(new Date(input));
          return date.render(format);
        } else if (angular.isDate(input)) {
          date = new Strftime(input);
          return date.render(format);
        } else {
          return input;
        }
      } catch (_error) {
        e = _error;
        return input;
      }
    };
  });

  m.filter("wuTeasing", function() {
    return function(input, max) {
      var e;
      try {
        if (!max) {
          max = 30;
        }
        if (input.length > max) {
          return input.slice(0, +max + 1 || 9e9) + '…';
        } else {
          return input;
        }
      } catch (_error) {
        e = _error;
        return input;
      }
    };
  });

}).call(this);

/*
//@ sourceMappingURL=web-utils-angular.js.map
*/