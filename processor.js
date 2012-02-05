(function() {
  var Mongolian, db, justNum, justNum2, server, util;

  util = require('util');

  Mongolian = require('mongolian');

  server = new Mongolian;

  db = server.db('bench');

  justNum = function(n) {
    if (n != null) return n.replace(/[^0-9\n\.\,]/g, '');
  };

  justNum2 = function(n) {
    var m, s;
    if (!(n != null)) return n;
    n = n.replace('s', '');
    n = n.replace(/[^0-9m\n\.\,]/g, '');
    if (n.indexOf('m') > 0) {
      s = n.split('m');
      m = s[0] * 1;
      n = s[1].replace(/[^0-9\n.\,]/g, '');
      n = n * 1;
      n = n + 60.0 * m;
    }
    return n * 1.0;
  };

  exports.parse = function(data) {
    var keep, line, lines, name, obj, parts, section, sections, val, _i, _len;
    console.log("Trying to parse " + data);
    data = data + " ";
    data = "\n" + data;
    sections = data.split("\n---------\n");
    sections.splice(0, 1);
    parts = [];
    obj = {};
    for (_i = 0, _len = sections.length; _i < _len; _i++) {
      section = sections[_i];
      try {
        lines = section.split("\n");
        keep = (function() {
          var _j, _len2, _results;
          _results = [];
          for (_j = 0, _len2 = lines.length; _j < _len2; _j++) {
            line = lines[_j];
            if (line !== '---') _results.push(line);
          }
          return _results;
        })();
        name = keep[0];
        switch (name) {
          case "Provider":
            val = keep[2];
            break;
          case "RAM":
            val = keep[1];
            break;
          case "date":
            val = new Date(keep[2]);
            break;
          case "Network":
            val = justNum2(keep[2]);
            console.log('secs = ' + val);
            val = 100.0 / val;
            console.log("network extracted " + val);
            break;
          case "IP address":
            val = keep[2].match(/\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/)[0];
            break;
          default:
            val = justNum(keep[2]);
        }
        obj[name] = val;
      } catch (e) {

      }
    }
    console.log("returning from parse");
    console.log(util.inspect(obj));
    return obj;
  };

  exports.newdata = function(data) {
    var record, results;
    try {
      record = exports.parse(data);
      if (record === 'disk issue') {
        return console.log('disk issue ' + data);
      } else {
        results = db.collection('results');
        return results.insert(record);
      }
    } catch (e) {
      return console.log(e);
    }
  };

}).call(this);
