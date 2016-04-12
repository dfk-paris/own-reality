var Strftime,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Strftime = (function() {
  Strftime.extend = function() {
    Date.prototype.strftime = function(format) {
      return (new Strftime(this)).strftime(format);
    };
    return true;
  };

  function Strftime(date) {
    this.date = date;
    this.substitutions = bind(this.substitutions, this);
    this.day_name = bind(this.day_name, this);
    this.month_name = bind(this.month_name, this);
    this.render = bind(this.render, this);
  }

  Strftime.prototype.render = function(format) {
    var g, p, ref;
    ref = this.substitutions();
    for (p in ref) {
      g = ref[p];
      format = format.replace("%" + p, g());
    }
    return format;
  };

  Strftime.prototype.pad = function(value, length, char) {
    var result;
    if (length == null) {
      length = 2;
    }
    if (char == null) {
      char = '0';
    }
    result = value;
    while (("" + result).length < length) {
      result = "" + char + result;
    }
    return result;
  };

  Strftime.prototype.month_name = function() {
    return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'Oktober', 'November', 'December'][this.date.getMonth()];
  };

  Strftime.prototype.day_name = function() {
    return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][this.date.getDay()];
  };

  Strftime.prototype.substitutions = function() {
    return {
      'Y': (function(_this) {
        return function() {
          return _this.date.getFullYear();
        };
      })(this),
      'm': (function(_this) {
        return function() {
          return _this.pad(_this.date.getMonth() + 1);
        };
      })(this),
      'd': (function(_this) {
        return function() {
          return _this.pad(_this.date.getDate());
        };
      })(this),
      'C': (function(_this) {
        return function() {
          return Math.floor(_this.date.getFullYear() / 100);
        };
      })(this),
      'y': (function(_this) {
        return function() {
          return _this.pad(_this.date.getFullYear() % 100);
        };
      })(this),
      'B': (function(_this) {
        return function() {
          return _this.month_name();
        };
      })(this),
      '^B': (function(_this) {
        return function() {
          return _this.month_name().toUpperCase();
        };
      })(this),
      'b': (function(_this) {
        return function() {
          return _this.month_name().slice(0, 3);
        };
      })(this),
      '^b': (function(_this) {
        return function() {
          return _this.month_name().slice(0, 3).toUpperCase();
        };
      })(this),
      'h': (function(_this) {
        return function() {
          return _this.month_name().slice(0, 3);
        };
      })(this),
      '^h': (function(_this) {
        return function() {
          return _this.month_name().slice(0, 3).toUpperCase();
        };
      })(this),
      'e': (function(_this) {
        return function() {
          return _this.date.getDate();
        };
      })(this),
      'j': (function(_this) {
        return function() {
          var from;
          from = new Date((_this.date.getFullYear()) + "-01-01 00:00:00");
          return Math.ceil((_this.date - from) / (1000 * 60 * 60 * 24));
        };
      })(this),
      'H': (function(_this) {
        return function() {
          return _this.pad(_this.date.getHours());
        };
      })(this),
      'k': (function(_this) {
        return function() {
          return _this.date.getHours();
        };
      })(this),
      'I': (function(_this) {
        return function() {
          var value;
          value = _this.date.getHours() > 12 ? _this.date.getHours() - 12 : _this.date.getHours();
          return _this.pad(value, 2, '0');
        };
      })(this),
      'l': (function(_this) {
        return function() {
          var value;
          value = _this.date.getHours() > 12 ? _this.date.getHours() - 12 : _this.date.getHours();
          return _this.pad(value, 2, ' ');
        };
      })(this),
      'p': (function(_this) {
        return function() {
          if (_this.date.getHours() - 12 >= 0) {
            return 'am';
          } else {
            return 'pm';
          }
        };
      })(this),
      'P': (function(_this) {
        return function() {
          return (_this.date.getHours() - 12 >= 0 ? 'am' : 'pm').toUpperCase();
        };
      })(this),
      'M': (function(_this) {
        return function() {
          return _this.pad(_this.date.getMinutes());
        };
      })(this),
      'S': (function(_this) {
        return function() {
          return _this.pad(_this.date.getSeconds());
        };
      })(this),
      'L': (function(_this) {
        return function() {
          return _this.pad(_this.date.getMilliseconds(), 3);
        };
      })(this),
      '[\d]+N': (function(_this) {
        return function() {
          return 'NOT SUPPORTED IN JAVASCRIPT';
        };
      })(this),
      'A': (function(_this) {
        return function() {
          return _this.day_name();
        };
      })(this),
      '^A': (function(_this) {
        return function() {
          return _this.day_name().toUpperCase();
        };
      })(this),
      'a': (function(_this) {
        return function() {
          return _this.day_name().slice(0, 3);
        };
      })(this),
      '^a': (function(_this) {
        return function() {
          return _this.day_name().slice(0, 3).toUpperCase();
        };
      })(this),
      'u': (function(_this) {
        return function() {
          return 'NOT IMPLEMENTED';
        };
      })(this),
      'w': (function(_this) {
        return function() {
          return _this.date.getDay();
        };
      })(this)
    };
  };

  return Strftime;

})();

this.Strftime = Strftime;
