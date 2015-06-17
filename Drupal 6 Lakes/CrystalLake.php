<?php
$sqlstatement = 'SELECT LocalDateTime,DataValue
FROM datavalues_hourly
WHERE SiteID = 27
and VariableID = 8
and OffsetValue = -.5
order by ValueID DESC
LIMIT 1';

db_set_active('odm');

$result = db_query($sqlstatement);

If (!$result) {
    echo "No results for NTL lakes <br/>";
}
else {
	while($row = db_fetch_array($result)) { //db_fetch_object will not work in drupal 7
		$temp[] = $row['DataValue'];
		$date[] = $row['LocalDateTime'];
		
	}
	$temp_f = (9/5)*($temp[0])+32;
}

$sqlstatement = 'SELECT LocalDateTime,DataValue
FROM datavalues_hourly
WHERE SiteID = 3
and VariableID = 12
order by ValueID DESC
LIMIT 1';

$result = db_query($sqlstatement);

If (!$result) {
    echo "No results for NTL lakes <br/>";
}
else {
	while($row = db_fetch_array($result)) { //db_fetch_object will not work in drupal 7
		$air[] = $row['DataValue'];
		$date[] = $row['LocalDateTime'];
		
	}
	$air_f = (9/5)*($air[0])+32;
}

$sqlstatement = 'SELECT LocalDateTime,DataValue
FROM datavalues_hourly
WHERE SiteID = 3
and VariableID = 22
order by ValueID DESC
LIMIT 1';

$result = db_query($sqlstatement);

If (!$result) {
    echo "No results for NTL lakes <br/>";
}
else {
	while($row = db_fetch_array($result)) { //db_fetch_object will not work in drupal 7
		$wind[] = $row['DataValue'];
		$date[] = $row['LocalDateTime'];
		
	}
	$wind_mph = (2.23694)*$wind[0];
}

$sqlstatement = 'SELECT LocalDateTime,DataValue
FROM datavalues_hourly
WHERE SiteID = 3
and VariableID = 17
order by ValueID DESC
LIMIT 1';

$result = db_query($sqlstatement);

If (!$result) {
    echo "No results for NTL lakes <br/>";
}
else {
	while($row = db_fetch_array($result)) { //db_fetch_object will not work in drupal 7
		$wind_dir[] = $row['DataValue'];
		$date[] = $row['LocalDateTime'];
		
	}
	//$wind_dirr = (2.23694)*$wind_dir[0];
}
//$date = date("Y-m-d H:m:s", strtotime('-1 hours'));
db_set_active('default');
?>
<p><a href="https://www.google.com/maps?t=m&amp;q=45.999689%2C-89.610422&amp;output=classic" target="_blank"><img alt="" src="/sites/default/files/ntl/images/socialWater/CRgauge.jpg" style="width: 300px; height: 240px; float: right; margin-top: 10px; margin-bottom: 10px;" /></a></p>
<table class="icons" style="width:300px;">
	<tbody>
		<tr>
			<td colspan="3">
				<h2>
					Current Conditions</h2>
				<p style="color:red"><b>The Crystal Lake buoy is offline for the winter</b></p>
				<p>Last Updated:<?php echo $date[0]?></p>
			</td>
			<td>
				&nbsp;</td>
		</tr>
		<tr>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<a href="https://lter.limnology.wisc.edu/page/water-temperate-plot?lake=CL"><font size="4">Water Temperatures</font></a><br />
				<br />
				<font size="4"><?php echo substr(($temp_f),0,4);?>&nbsp; (&deg;F)<br />
				<?php echo substr(($temp[0]),0,4);?>&nbsp; (&deg;C) &nbsp;</font></td>
			<td style="border: 7px solid #006699; text-align: center;">
				<a href="https://lter.limnology.wisc.edu/page/temperature-map?lake=CL"><font size="4">Water Temperature Heat Map</font></a></td>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<font size="4">Air Temperature</font><br />
				<br />
				<font size="4"><?php echo substr($air_f,0,4);?>&nbsp;(&deg;F)<br />
				<?php echo substr(($air[0]),0,4);?>&nbsp;(&deg;C)</font><br />
				&nbsp;</td>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<div id="circle">
					&nbsp;</div>
				<br />
				<font size="4">Wind Speed</font><br />
				&nbsp; <font size="4"><?php echo substr($wind_mph,0,4);?>&nbsp;(mph)<br />
				<?php echo substr(($wind[0]),0,4);?>&nbsp;(m/s) </font><br />
				&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<h2>
					Long Term Data</h2>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<h4>
					Chemical Limnology</h4>
			</td>
		</tr>
		<tr>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<a href="../lakeinfo/chemistry-data?lakeid=CR&amp;chem=totnuf"><font size="4">Total<br />
				Nitrogen</font></a><br />
				&nbsp;</td>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<a href="../lakeinfo/chemistry-data?lakeid=CR&amp;chem=totpuf"><font size="4">Total<br />
				Phosphorus</font></a><br />
				&nbsp;</td>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<a href="../lakeinfo/chemistry-data?lakeid=CR&amp;chem=doc"><font size="4">Dissolved<br />
				Organic Carbon</font></a><br />
				&nbsp;</td>
		</tr>
	</tbody>
</table>
<table class="icons" style="width:300px;">
	<tbody>
		<tr>
			<td colspan="3">
				<h4>
					Biology</h4>
			</td>
		</tr>
		<tr>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/fish-species?lakeid=CR"><img alt="fish icon" src="/sites/default/files/ntl/images/lakes/fishIcon.jpg" style="width: 100px; height: 64px; margin: 10px;" /></a></td>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/macrophyte-species?lakeid=CR"><img alt="macrophyte icon" src="/sites/default/files/ntl/images/lakes/macrophyteIcon.jpg" style="width: 100px; height: 64px; margin: 10px;" /></a></td>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/phytoplankton-species?lakeid=CR"><img alt="phytoplankton icon" src="/sites/default/files/ntl/images/lakes/phytoplanktonIcon.jpg" style="width: 100px; height: 64px; margin: 10px;" /></a></td>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/zooplankton-species?lakeid=CR"><img alt="zooplankton icon" src="/sites/default/files/ntl/images/lakes/zooplanktonIcon.jpg" style="width: 100px; height: 64px; margin: 10px;" /></a></td>
			<td style=" border: 7px solid #006699; text-align: center;">
				<br />
				<a href="../lakeinfo/chemistry-data?lakeid=CR&amp;chem=chlor"><font size="4">Chlorophyll<br />
				Concentration</font></a><br />
				&nbsp;</td>
		</tr>
		<tr>
			<td>
				<h4>
					Physical Limnology</h4>
			</td>
		</tr>
		<tr>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/ice-data?lakeid=CR"><img alt="ice icon" src="/sites/default/files/ntl/images/lakes/iceIcon.jpg" style="width: 100px; height: 64px; margin: 10px; float: left;" /></a></td>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/lake-levels?lakeid=CR&amp;system=NTL"><img alt="ice icon" src="/sites/default/files/ntl/images/lakes/waterlevelIcon.jpg" style="width: 100px; height: 64px; margin: 10px; float: left;" /></a></td>
			<td style=" border: 7px solid #006699;">
				<a href="../lakeinfo/secchi-depths?lakeid=CR"><img alt="ice icon" src="/sites/default/files/ntl/images/lakes/secchiIcon.jpg" style="width: 100px; height: 64px; margin: 10px; float: left;" /></a></td>
		</tr>
	</tbody>
</table>
<p>&nbsp;</p>
<p><script type="text/javascript" src="../../d3/d3.min.js"></script><script type="text/javascript" src="../../d3/d3.geom.contour.v0.min.js"></script><script type="text/javascript">



var data = [{ name: "WindDir", dist: 0, angle: 250 }];
//var dataa = <?php echo json_encode($temp_arr);?>;

//console.log((dataa));

//var angle = parseInt(dataa['wind_dir']);
//var speed =  parseInt(dataa['wind_speed']);

var angle = <?php echo json_encode($wind_dir);?>;
var speed =  <?php echo json_encode($wind_mph);?>;
var speed = speed.toFixed(2);
var w = 100;
var h = 100;


var svg = d3.select("#circle").append("svg").attr("width",w).attr("height",h);
var g = svg.append('g').attr('transform', 'translate(' + w/2 + ',' + h/2 + ')');

var group = g.selectAll('.strike')
  .data(data).enter()
  .append('g')
  .attr('class', 'strike')
  .attr('transform', function (d) { 
 return "rotate(" + d.angle + ") " + 
        "translate(" + d.dist + ",0) " + 
        "rotate(" + (-1 * d.angle) + ")";
  });

var radius = 35;

group
  .append('circle')
  .attr("fill","#fff").attr("stroke","#C0C0C0")
  .attr("stroke-width","4px")
  .attr('r', radius );


//var angle = 250;
var y = (Math.sin(angle*(Math.PI/180)))*radius ;
var x = (Math.cos(angle*(Math.PI/180)))*radius ;

//round the angle first

angle = Math.round(angle);
console.log(Math.abs(radius)+2);
console.log(Math.abs(radius)-2);
if (angle >= 2 && angle <= 88){
  dir = "NE";
}
if (angle >= 92 && angle <= 178){
  dir = "SE";
}
if (angle >= 182 && angle <= 268){
  dir = "SW";
}
if (angle >= 272 && angle <= 358){
  dir = "NW";
}
console.log(y);
console.log(x);
if (y<=(-radius+2) && y >=(-radius-2)  ){
dir = "W";

}

if (x<=(-radius+2) && x >=(-radius-2)  ){
dir = "S";

}
if (y<=Math.abs(radius)+2 && y >=Math.abs(radius)-2 ){
dir = "E";

}

if (y<=2 && y >=-2 && x<=Math.abs(radius)+2 && x >=Math.abs(radius)-2  ){
dir = "N";

}

group
  .append('text')
  .style("text-anchor","middle")
.attr("y","4")
  .text(speed)
  .style("font-face","bold")
 .style("font-size","15px");
  //.attr('dy', "-1em");
  
  group
  .append('text')
  .style("text-anchor","middle")
.attr("y","-24")
  .text("N")
  .style("font-face","bold")
 .style("font-size","8px");


  group
  .append('text')
  .style("text-anchor","middle")
.attr("y","27")
  .text("S")
  .style("font-face","bold")
 .style("font-size","8px");


  group
  .append('text')
.style("text-anchor","middle")
.attr("x","-27")
.attr("y","3")
  .text("W")
  .style("font-face","bold")
 .style("font-size","8px");

  group
  .append('text')
.style("text-anchor","middle")
.attr("x","27")
.attr("y","3")
  .text("E")
  .style("font-face","bold")
 .style("font-size","8px");


var diff = (45-angle);

var diffx = (45-angle);

var originx = -30;
var originy= 30;
var diag = Math.sqrt(7);

var y = (Math.sin(angle*(Math.PI/180)))*radius ;

var test = angle-90;
var trigx;
var trigy;

//triangle origin points.
x = -5;
y = -40;

var rotation = angle;

//draw a triangle
  group.append('path')     
      .attr('d', function(d) { 
        return 'M ' + x+' '+ y+ ' l 5 15 l  5 -15 z';
      })

//rotate it
.attr("transform", "rotate("+ (rotation) +","+ (0) + ","+ (0) +")");
 
document.write("Wind from ", dir);
document.write ("<br>");
//document.write("updated: ", dataa['sampledate']);
</script></p>
