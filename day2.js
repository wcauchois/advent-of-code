var fs = require('fs'),
    byline = require('byline');

var sum = 0;
var stream = byline(fs.createReadStream('day2.txt', 'utf-8'))
stream.on('data', function(line) {
  line = line.trim();
  if (line) {
    var groups = line.match(/(\d+)x(\d+)x(\d+)/);
    var l = parseInt(groups[1]);
    var w = parseInt(groups[2]);
    var h = parseInt(groups[3]);
    sum += 2*l*w + 2*w*h + 2*h*l;
    var smallestSide = Math.min(l*w, w*h, h*l);
    sum += smallestSide;
  }
});
stream.on('end', function() {
  console.log(sum);
});

