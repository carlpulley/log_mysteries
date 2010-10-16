function sparkbar(data) {
  var w = 24*5,
      h = 12;

  var hs = pv.Scale.linear(0, 255).range(0, h);

  var vis = new pv.Panel()
      .width(w)
      .height(h);

  vis.add(pv.Bar)
      .data(data.toArray())
      .width(4)
      .left(function() { return 5 * this.index; })
      .height(function(d) { return hs(d.charCodeAt()); })
      .bottom(0);

  return vis;
}

function sparklength(data, mw) {
  var h = 12, pw = 24*5;

  var ws = pv.Scale.linear(0, mw).range(0, pw);
  
  var vis = new pv.Panel()
      .width(pw)
      .height(h)
	  .fillStyle("#B3C6FF");

  vis.add(pv.Bar)
      .height(h)
      .width(ws(data));
  
  return vis;
}

function sparkcolour(data) {
  var vis = new pv.Panel()
	.width(12)
	.height(12);
	
  vis.add(pv.Dot)
	.bottom(6)
	.left(6)
	.fillStyle(pv.Scale.linear(200, 300, 400, 600).range('green', 'yellow', 'red', 'black')(data));
	
  return vis;
}
