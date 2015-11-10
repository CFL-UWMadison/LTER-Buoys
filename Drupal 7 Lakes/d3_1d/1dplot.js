(function ($) {
  Drupal.behaviors.onedplot = {
    attach: function (context, settings) {

//Variables brought over from .module
var numsamps = Drupal.settings.numsamps;
var Dates = Drupal.settings.Dates;
var datetype = Drupal.settings.datetype;
var Values = Drupal.settings.Values;
var units = Drupal.settings.units;

//Set up margin and plot limits
var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var data = [];
for (var i=0; i<numsamps; i++) {
  data.push({
     value: Values[i],
     date: Dates[i],
    });
}
//Massage Data
if (datetype == 'Ymd') {
	var parseDate = d3.time.format("%Y-%m-%d").parse;
} else if (datetype == 'Y') {
	var parseDate = d3.time.format("%Y").parse;
}
data.forEach(function(d) {
    d.date = parseDate(d.date);
    d.value = Number(d.value);
});

var plotSVG = d3.select("#plotDiv").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var line = d3.svg.line()
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.value); });

var x = d3.time.scale()
    .range([0, width]);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain(d3.extent(data, function(d) { return d.value; }));

  plotSVG.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  plotSVG.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text(units);

  plotSVG.append("path")
      .datum(data)
      .attr("class", "line")
      .attr("d", line);


//////////////////////////////////////////
    }
  };
})(jQuery);


