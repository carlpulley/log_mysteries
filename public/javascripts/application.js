//    Log Mysteries: partial answer for Honeynet challenge
//    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
//    Copyright (C) 2010  Dr. Carl J. Pulley
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

document.observe("dom:loaded", function() {
  $$("div.asn_blacklist").each(function(e) {
      e.hide();
  });
  $$("a.asn_blacklist").each(function(e) {
      e.observe("ajax:before", function(event) {
          event.element().hide();
          event.element().insert({ after: "<img class='loading' src='/images/ajax-loader.gif' alt='Loading...' /> Loading" }); 
      });
      e.observe("ajax:success", function(event) {
          var asn = event.element().readAttribute("href").slice("/research/stop_badware_lookup?asn=".length);
          event.element().up("li").select("div.asn_blacklist").each(function(e) {
             e.show(); 
          });
          var vis = "vis_"+asn;
          eval(vis+".data("+event.memo.responseText+".map(function(e) { var h = {}; h['x'] = e.date; h['y'] = e.partner; return h; }))");
          eval(vis+".render()");
      });
      e.observe("ajax:failure", function(event) {
          console.error(event.memo.responseText);
          var asn = event.element().readAttribute("href").slice("/research/stop_badware_lookup?asn=".length);
          event.element().up("li").replace("<li><font color='red'><b>ERROR:</b></font> ASN "+ asn +" blacklist lookup failed!</li>");
      });
  });
  $$("a.ip_blacklist").each(function(e) {
      e.observe("ajax:before", function(event) {
          event.element().hide();
          event.element().insert({ after: "<img class='loading' src='/images/ajax-loader.gif' alt='Loading...' /> Loading" }); 
      });
      e.observe("ajax:success", function(event) {
          event.element().up("li").replace(event.memo.responseText);
      });
      e.observe("ajax:failure", function(event) {
          console.error(event.memo.responseText);
          var ip_address = event.element().readAttribute("href").slice("/research/blacklist_lookup?ip_address=".length);
          event.element().up("li").replace("<li><font color='red'><b>ERROR:</b></font> "+ ip_address +" blacklist lookup failed!</li>");
      });
  });
  $$("div.tabs div.content").each(function(e) { e.hide(); });
  $$("div.tabs ul.menu li.tab.current").each(function(e) {
      e.up("div.tabs").select("div.content#"+e.readAttribute("id")).each(function(e) { e.show(); });
  });
  $$("div.tabs ul.menu li.tab a").each(function(e) { 
      e.observe("click", function(a) {
          var tabs = a.element().up("div.tabs");
          tabs.select("div.content").each(function(e) { e.hide(); });
          tabs.select("li.tab.current").each(function(e) { e.toggleClassName("current"); });
          a.element().up("li.tab").toggleClassName("current");
          var display = a.element().up("li.tab").readAttribute("id");
          tabs.select("div.content#"+a.element().up("li.tab").readAttribute("id")).each(function(e) { e.show(); });
          a.stop();
      }); 
  });
});

function mean(values) {
  return values.inject(0, function(t,n) { return t+n; }) / values.length;
}

function standard_deviation(values) {
  return Math.sqrt(values.inject(0, function(sum, e) { return sum + Math.pow(e - mean(values), 2); }) / values.length);
}

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

