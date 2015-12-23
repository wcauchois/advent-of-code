var fs = require('fs'),
    byline = require('byline'),
    util = require('util');

// XXX unused
function permutations(xs) {
  if (xs.length > 1) {
    var result = [];
    permutations(xs.slice(1)).forEach(function(p) {
      result.push([xs[0]].concat(p));
      result.push(p.concat([xs[0]]));
    });
    return result;
  } else {
    return [xs];
  }
}

// not at all hardened against bad inputs
function choose(xs, n) {
  if (n > 1) {
    var result = [];
    choose(xs.slice(1), n - 1).forEach(function(c) {
      result.push([xs[0]].concat(c));
      result.push(c.concat([xs[0]]));
    });
    return result;
  } else {
    return xs.map(function(x) { return [x]; });
  }
}

function calcRibbon(l, w, h, debug) {
  var wrap = Math.min.apply(Math, choose([l, w, h], 2).map(function(side) {
    return side[0]*2 + side[1]*2;
  }));
  var bow = l*w*h;
  debug && console.log(util.format("%s feet to wrap, %s feet for bow", wrap, bow));
  return wrap + bow;
}
exports.calcRibbon = calcRibbon;

if (require.main === module) {
  var sum = 0;
  var stream = byline(fs.createReadStream('day2.txt', 'utf-8'))
  stream.on('data', function(line) {
    line = line.trim();
    if (line) {
      var groups = line.match(/(\d+)x(\d+)x(\d+)/);
      var l = parseInt(groups[1]);
      var w = parseInt(groups[2]);
      var h = parseInt(groups[3]);
      sum += calcRibbon(l, w, h);
    }
  });
  stream.on('end', function() {
    console.log(sum);
  });
}

