(function ($) {
  Drupal.behaviors.tempMap = {
    attach: function (context, settings) {

//Variables brought over from .module
var numdays = Drupal.settings.numdays;
var numdepths = Drupal.settings.numdepths;
var Depths = Drupal.settings.depths_array;  //1D array
var Temps = Drupal.settings.temps_array;    //2D array
var Dates = Drupal.settings.dates_array;   //1D array
//Convert Dates to Date format
for (var i=0; i<Dates.length; i++) { Dates[i] = d3.time.format("%Y-%m-%d").parse(Dates[i]);}

var padding = 10;
var tempmap_border = [5*padding,padding+880,padding,padding+300]; //left,right,top,bottom
var legend_border = [tempmap_border[1]+30,tempmap_border[1]+50,padding,padding+270];

//Generate a 4-tuble for every cell in the map: rect y, height, x, temp
var Cellvals = new Array(numdepths*numdays);

//A numcells x 3 array is easier to deal with than a 3-D array

/*
//Scaled width, constant depth increment. Cell width is stretched for entire plot.
var i;
var cell_width = Math.floor((tempmap_border[1]-tempmap_border[0])/numdays);
var cell_height_pix = Math.floor((tempmap_border[3]-tempmap_border[2])/(numdepths-1));
for (var ridx=0; ridx<numdepths; ridx++) {
	for (var cidx=0; cidx<numdays; cidx++) {
		i = ridx*numdays + cidx;
		Cellvals[i] = new Array(4);
		Cellvals[i][0] = ridx*cell_height_pix;
		Cellvals[i][1] = cell_height_pix;
		Cellvals[i][2] = cidx*cell_width;  
		Cellvals[i][3] = Temps[ridx][cidx];
	}//for cidx
}//for ridx
*/

//
// Scaled width, actual depth proportions
//

var i;
var cell_width = Math.floor((tempmap_border[1]-tempmap_border[0])/numdays);
var ppm = (tempmap_border[3]-tempmap_border[2])/Depths[numdepths-1]; //pixels per meter
//Three new arrays
var cell_y = new Array(numdepths);
var cell_bdr = new Array(numdepths);
var cell_ht = new Array(numdepths)
//The units of the following three arrays is in PIXELS; Conversion is Pixels = Math.round(meters*ppm)
//cell_y is the y location for each cell: the sum of the prior cell_y plus its height.
//cell_border are the y borders of the cells; it's not the depth, but a depth average between actual depths.
//cell_ht is the distance between cell_borders
//Init the zero index

cell_y[0] = 0; cell_bdr[0] = Math.round(ppm*Depths[1]/2); cell_ht[0] = Math.round(ppm*((Depths[1]-Depths[0])/2));;
for (var didx=1; didx<numdepths; didx++) {
   cell_y[didx] = cell_y[didx-1] + cell_ht[didx-1];
   if (didx < (numdepths - 1)) {  
      cell_bdr[didx] = Math.round(ppm*((Depths[didx+1] + Depths[didx])/2));
   } else {  //cell_bdr is different for the last cell
      cell_bdr[didx] = Math.round(ppm*Depths[didx]); //maxdepth
   }
   cell_ht[didx] = cell_bdr[didx] - cell_bdr[didx-1];
}//for didx

/*
//Debugging printout 
for (var didx=0; didx<numdepths; didx++) {
 document.write(didx," ",cell_y[didx]," ",cell_bdr[didx]," ",cell_ht[didx],"<br>");
}
*/
for (var ridx=0; ridx<numdepths; ridx++) {
	for (var cidx=0; cidx<numdays; cidx++) {
		i = ridx*numdays + cidx;
		Cellvals[i] = new Array(4);
		Cellvals[i][0] = cell_y[ridx];       //y
		Cellvals[i][1] = cell_ht[ridx];      //height
		Cellvals[i][2] = cidx*cell_width;    //x
		Cellvals[i][3] = Temps[ridx][cidx];  //temp
                //Debugging print
		//if (cidx == 0) 
                //  document.write(ridx," ",Cellvals[i][0]," ",Cellvals[i][1]," ",Cellvals[i][2]," ",Cellvals[i][3],"<br>")
	}//for cidx
}//for ridx
//Scale the y axis
var avg_cell_height = Math.floor((tempmap_border[3]-tempmap_border[2])/(numdepths-1));
var map_yaxis = d3.scale.linear()
    .domain(d3.extent(Depths))
    .range([0,avg_cell_height*(numdepths)]);

//Map temperatures to color; assuming temps range from 0-27C
//var Colormap = d3.scale.linear().domain([-1,0,5,10,15,20,25,27]).range(["white","violet","blue","green","yellow","orange","red","firebrick"]).clamp([1]);
var Colormap = d3.scale.linear().domain([-1,1,4,7.5,10,13,17,18,20,22,24,27]).range(["white","#8A2BE2","#2020FF","#00D0D0","#32CD32","#ADFF2F","yellow","gold","orange","#FF4500","red","firebrick"]).clamp([1]);
//var Colormap = d3.scale.linear().domain([-1,1,2,4,7.5,10,13,17,18,20,22,24,27]).range(["white","#9400D3","#8A2BE2","#2020FF","#00C0C0","#32CD32","#ADFF2F","yellow","gold","orange","#FF4500","red","firebrick"]).clamp([1]);
//var Colormap = d3.scale.linear().domain([-1,1,2,4,6,8,10,13,17,18,20,22,24,27]).range(["white","violet","#7B68EE","blue","#00BFFF","#00FF7F","#32CD32","#ADFF2F","yellow","gold","orange","#FF4500","red","firebrick"]).clamp([1]);

//Define the total drawing canvas
var tempmapSVG = d3.select("#mapDiv")
    .append("svg")
    .attr("width", 960)
    .attr("height", 400);    
    
//Display the temperature map
tempmapSVG.selectAll("rect")
    .data(Cellvals)
    .enter()
    .append("rect")
    .attr("x", function(d){return tempmap_border[0]+d[2]})
    .attr("y", function(d){return tempmap_border[2]+d[0]})
    .attr("height", function(d){return d[1]})
    .attr("width", cell_width)
    .attr("fill", function(d){return Colormap(d[3])});
//
//Date Axis	
//
var map_xaxis = d3.time.scale()
    .domain(d3.extent(Dates))
    .range([0, cell_width*numdays]);

var xAxis = d3.svg.axis()
    .scale(map_xaxis)
    .orient("bottom");	

tempmapSVG.append("g")
      .attr("class", "axis")
      .attr("transform", "translate("+tempmap_border[0]+","+tempmap_border[3]+")")
      .call(xAxis);

//
//Y Axis	
//
var yAxis = d3.svg.axis()
    .scale(map_yaxis)
    .orient("left");	

tempmapSVG.append("g")
      .attr("class", "axis")
      .attr("transform", "translate("+tempmap_border[0]+","+tempmap_border[2]+")")
      .call(yAxis);
		
tempmapSVG.append("text")
      .attr("class", "y label")
//      .attr("text-anchor", "end")
      .attr("y", 0)
      .attr("x", -150)
      .attr("dy", ".75em")
      .attr("transform", "rotate(-90)")
      .style("font-size","14px")
      .text("Depth (m)");
		

//	
// The Legend	
//
var legend = new Array(270);
for(var i=0; i<270; i++){ legend[i]=i/10; }        

tempmapSVG.selectAll("legend_rect")
    .data(legend)
    .enter()
    .append("rect")
    .attr("x", legend_border[0])
    .attr("y", function(d){return legend_border[2]+d*10})  //270 rects being drawn, each 1x20 pix
    .attr("height", 1)  
    .attr("width", 20)
    .attr("fill", function(d){ return Colormap(27-d)});

// Add an axis for each temperature scale: F & C
var cScale = d3.scale.linear().domain([27,0]).range([0,270]);
var fScale = d3.scale.linear().domain([80,32]).range([0,270]); //77F = 25C; 86F~30C

var cAxis = d3.svg.axis()	
    .scale(cScale)
    .tickValues([0,5,10,15,20,25])
    .orient("right");

var fAxis = d3.svg.axis()	
    .scale(fScale)
    .tickValues([32,40,50,60,70,80])
    .orient("left");

tempmapSVG.append("g")
  .attr("class","axis") 
  .attr("transform", "translate("+legend_border[1]+","+legend_border[2] +")")
  .call(cAxis);


tempmapSVG.append("g")
  .attr("class","axis") 
  .attr("transform", "translate("+legend_border[0]+","+legend_border[2]+")")
  .call(fAxis);

//Axis Labels
tempmapSVG.append("text")
  .attr("class","axis")
  .attr("x",legend_border[1]+5)
  .attr("y",legend_border[3]+20)
  .style("text-anchor","middle")
  .style("font-size","12px")
  .text("\u00B0C");

tempmapSVG.append("text")
  .attr("x",legend_border[0]-10)
  .attr("y",legend_border[3]+20)
  .style("text-anchor","middle")
  .style("font-size","12px")
  .text("\u00B0F");

    }
  };
})(jQuery);
