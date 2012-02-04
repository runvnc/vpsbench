(function() {
  var Mongolian, db, justNum, server;

  Mongolian = require('mongolian');

  server = new Mongolian;

  db = server.db('bench');

  justNum = function(n) {
    return n.replace(/[^0-9\n\.\,]/g, '');
  };

  exports.parse = function(data) {
    var keep, line, lines, name, obj, parts, section, sections, val, _i, _len;
    console.log("Trying to parse " + data);
    data = data + " ";
    sections = data.split("\n---------\n");
    sections.splice(0, 1);
    parts = [];
    obj = {};
    for (_i = 0, _len = sections.length; _i < _len; _i++) {
      section = sections[_i];
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
        case "RAM":
          val = keep[1];
          break;
        case "date":
          val = new Date(keep[2]);
          break;
        case "Network":
          val = justNum(keep[2]);
          val = 100.0 / val;
          break;
        case "IP address":
          val = keep[2].match(/\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/)[0];
          break;
        case "Disk Write":
        case "Disk Read":
          val = keep[4];
          val = val.match(/[0-9]+\ [a-zA-Z]+\/s/);
          val = val[0];
          val = val.split(' ');
          val = val[0];
          break;
        default:
          val = justNum(keep[2]);
      }
      obj[name] = val;
    }
    console.log("returning from parse");
    console.log(util.inspect(obj));
    return obj;
  };

  exports.newdata = function(data) {
    var record, results;
    record = exports.parse(data);
    results = db.collection('results');
    console.log("inserting ");
    return results.insert(record);
  };

}).call(this);
