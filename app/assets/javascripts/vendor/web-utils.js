var Strftime,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Strftime = (function() {
  Strftime.extend = function() {
    Date.prototype.strftime = function(format) {
      return (new Strftime(this)).strftime(format);
    };
    return true;
  };

  function Strftime(date) {
    this.date = date;
    this.substitutions = __bind(this.substitutions, this);
    this.day_name = __bind(this.day_name, this);
    this.month_name = __bind(this.month_name, this);
    this.render = __bind(this.render, this);
  }

  Strftime.prototype.render = function(format) {
    var g, p, _ref;
    _ref = this.substitutions();
    for (p in _ref) {
      g = _ref[p];
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
    var _this = this;
    return {
      'Y': function() {
        return _this.date.getFullYear();
      },
      'm': function() {
        return _this.pad(_this.date.getMonth() + 1);
      },
      'd': function() {
        return _this.pad(_this.date.getDate());
      },
      'C': function() {
        return Math.floor(_this.date.getFullYear() / 100);
      },
      'y': function() {
        return _this.pad(_this.date.getFullYear() % 100);
      },
      'B': function() {
        return _this.month_name();
      },
      '^B': function() {
        return _this.month_name().toUpperCase();
      },
      'b': function() {
        return _this.month_name().slice(0, 3);
      },
      '^b': function() {
        return _this.month_name().slice(0, 3).toUpperCase();
      },
      'h': function() {
        return _this.month_name().slice(0, 3);
      },
      '^h': function() {
        return _this.month_name().slice(0, 3).toUpperCase();
      },
      'e': function() {
        return _this.date.getDate();
      },
      'j': function() {
        var from;
        from = new Date("" + (_this.date.getFullYear()) + "-01-01 00:00:00");
        return Math.ceil((_this.date - from) / (1000 * 60 * 60 * 24));
      },
      'H': function() {
        return _this.pad(_this.date.getHours());
      },
      'k': function() {
        return _this.date.getHours();
      },
      'I': function() {
        var value;
        value = _this.date.getHours() > 12 ? _this.date.getHours() - 12 : _this.date.getHours();
        return _this.pad(value, 2, '0');
      },
      'l': function() {
        var value;
        value = _this.date.getHours() > 12 ? _this.date.getHours() - 12 : _this.date.getHours();
        return _this.pad(value, 2, ' ');
      },
      'p': function() {
        if (_this.date.getHours() - 12 >= 0) {
          return 'am';
        } else {
          return 'pm';
        }
      },
      'P': function() {
        return (_this.date.getHours() - 12 >= 0 ? 'am' : 'pm').toUpperCase();
      },
      'M': function() {
        return _this.pad(_this.date.getMinutes());
      },
      'S': function() {
        return _this.pad(_this.date.getSeconds());
      },
      'L': function() {
        return _this.pad(_this.date.getMilliseconds(), 3);
      },
      '[\d]+N': function() {
        return 'NOT SUPPORTED IN JAVASCRIPT';
      },
      'A': function() {
        return _this.day_name();
      },
      '^A': function() {
        return _this.day_name().toUpperCase();
      },
      'a': function() {
        return _this.day_name().slice(0, 3);
      },
      '^a': function() {
        return _this.day_name().slice(0, 3).toUpperCase();
      },
      'u': function() {
        return 'NOT IMPLEMENTED';
      },
      'w': function() {
        return _this.date.getDay();
      }
    };
  };

  return Strftime;

})();

this.Strftime = Strftime;

/*
//@ sourceMappingURL=web-utils.js.map
*/