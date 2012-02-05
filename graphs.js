(function() {
  var multisort, order, process, score;

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
        if (typeof propfunc === func) {
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
    n += obj.Network;
    n += obj['Disk Read'];
    n += obj['Disk Write'];
    return 1.0 / n;
  };

  process = function(results) {
    return multisort(results, ['RAM', score]);
  };

  $(function() {
    return $.get('/results', function(arr) {
      var sorted;
      sorted = process(arr);
      return console.log(sorted);
    });
  });

}).call(this);
