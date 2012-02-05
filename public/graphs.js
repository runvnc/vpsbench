(function() {
  var datatable, multisort, order, process, score;

  order = function(a, b) {
    var ret;
    ret = a - b;
    if (ret !== 0) return ret /= Math.abs(ret);
  };

  multisort = function(arr, propfuncs) {
    return arr.sort(function(a, b) {
      var numa, numb, propfunc, ret, _i, _len;
      for (_i = 0, _len = propfuncs.length; _i < _len; _i++) {
        propfunc = propfuncs[_i];
        if (typeof propfunc === 'function') {
          numa = propfunc(a);
          numb = propfunc(b);
          ret = order(numa, numb);
        } else {
          ret = order(a[propfunc], b[propfunc]);
        }
        if (ret !== 0) break;
      }
      return ret;
    });
  };

  score = function(obj) {
    var n;
    n = 100 - obj.CPU;
    n += obj.Network * 1;
    n += obj['Disk Read'] * 1;
    n += obj['Disk Write'] * 1;
    return 1.0 / n;
  };

  process = function(results) {
    var row, _i, _len;
    multisort(results, ['RAM', score]);
    for (_i = 0, _len = results.length; _i < _len; _i++) {
      row = results[_i];
      try {
        row.Total = 1.0 / score(row);
        row.date = new Date(row.date).toLocaleDateString();
        row.CPU = 100 - row.CPU;
        row.Network = Math.round(row.Network);
      } catch (e) {
        console.log(e);
      }
    }
    return results;
  };

  datatable = function(rows) {
    var col, cols, key, out, row, val, _i, _j, _len, _len2, _ref;
    cols = [];
    _ref = rows[0];
    for (key in _ref) {
      val = _ref[key];
      cols.push(key);
    }
    out = "<table><thead>";
    for (_i = 0, _len = cols.length; _i < _len; _i++) {
      col = cols[_i];
      out += "<th>" + col + "</th>";
    }
    out += "</thead><tbody>";
    for (_j = 0, _len2 = rows.length; _j < _len2; _j++) {
      row = rows[_j];
      out += "<tr>";
      for (key in row) {
        val = row[key];
        out += "<td>" + val + "</td>";
      }
      out += "</tr>";
    }
    return out += "</tbody></table>";
  };

  $(function() {
    return $.getJSON('/results', function(arr) {
      var sorted;
      sorted = process(arr);
      console.log(sorted);
      return $('#resultshere').html(datatable(sorted));
    });
  });

}).call(this);
