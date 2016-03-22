(function ($) {
  Drupal.behaviors.RedCircle = {
    attach: function (context, settings) {

     var dataset = [1,3,5,10,15];     
//Create content

   var sampleSVG = d3.select("#divc")
        .append("svg")
        .attr("width", 100)
        .attr("height", 100);    

    sampleSVG.append("circle")
        .style("stroke", "gray")
        .style("fill", "white")
        .attr("r", 40)
        .attr("cx", 50)
        .attr("cy", 50)
        .on("mouseover", function(){d3.select(this).style("fill", "red");})
        .on("mouseout", function(){d3.select(this).style("fill", "white");});

    }
  };
})(jQuery);
