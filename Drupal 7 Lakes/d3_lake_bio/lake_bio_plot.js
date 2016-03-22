(function ($) {
  Drupal.behaviors.lakebio = {
    attach: function (context, settings) {

//Variables brought over from .module
var plot_title = Drupal.settings.plot_title;
var plot_units = Drupal.settings.plot_units;
var Dates = Drupal.settings.Dates;
var Richness = Drupal.settings.Richness;
var Common = Drupal.settings.Common;
var Species = Drupal.settings.Species;

// PLOT HALF
//Set up margin and plot limits
var margin = {top: 20, right: 20, bottom: 20, left: 50},
    width = 480 - margin.left - margin.right,
    height = 300 - margin.top - margin.bottom;

var data = [];
for (var i=0; i<Dates.length; i++) {
  data.push({
     value: Richness[i],
     date: Dates[i],
    });
}
var parseDate = d3.time.format("%Y").parse;
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
      .text(plot_units);

  plotSVG.append("path")
      .datum(data)
      .attr("class", "line")
      .attr("d", line);


//////////////////////////////////////////
    }
  };
})(jQuery);


