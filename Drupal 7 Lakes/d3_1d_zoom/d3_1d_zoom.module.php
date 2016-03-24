<?php
/*
 *  Implements hook_menu();
*/

function d3_1d_zoom_menu() {
  $items = array();

  //"1dPlot" will be the URL
  $items['1dPlotzoom/%/%'] = array(
    'title' => '',
    'page callback' => 'd3_1d_zoom', //php function name
    'page arguments' => array(1,2),  //mult. args are (1,2,3)...
    'access arguments' => array('access content'),
  );
  return $items;
}

function d3_1d_zoom($lakeid,$variable) {

  //Get data from the database
  get_data1d($lakeid, $variable);
  //Get a plain language string for title
  $plain_title = get_plain_title($lakeid, $variable);

  $content = array();

  $content['plot_title'] = array(
    '#type' => 'markup',
    '#markup' => $plain_title,
    '#prefix' => '<h4 style="margin-left:50px;">',
    '#suffix' => '</h4>',
  );

  //Use a container
  $content['div_container'] = array(
    '#type' => 'container',
    '#attributes' => array(
       'id' => array('plotDiv'),
     ),
  );

  $content['div_container']['css_content'] = array(
    '#type' => 'markup',
    '#attached' => array(
      'css' => array(
        drupal_get_path('module','d3_1d_zoom').'/d3_1d_zoom.css',
      ),
    ),  
  );

  $content['div_container']['js_content'] = array(
    '#type' => 'markup',
    '#attached' => array(
      'js' => array(
        drupal_get_path('module','d3_1d_zoom').'/1dplot_zoom.js',
        array(
 	      'type' => 'setting', 
	      'data' => array(
 	         'numsamps' => $GLOBALS['numsamps'], 
 	         'Dates' => $GLOBALS['Dates'],
             'datetype' => $GLOBALS['datetype'],			 
 	         'Values' => $GLOBALS['Values'],
             'units' => $GLOBALS['units'],
           ),
         ),
       ),
     ),
  );

  return $content;
}
//Get the data from the database: sampledates and values
function get_data1d($lakeid, $variable) { 

    $sqlstatement = get_sql_query($lakeid, $variable);
	db_set_active('dbmaker');
	$result = db_query($sqlstatement);

	//Initialize arrays
	$idx = 0;
	$Dates = array();
	$Values = array();

	foreach ($result as $row) {  
	  $Dates[$idx] = $row->sampledate;
	  $Values[$idx++] = $row->$variable;
	}
	db_set_active('default');

	$GLOBALS['numsamps'] = $idx;
	$GLOBALS['Dates'] = $Dates;
	$GLOBALS['Values'] = $Values;
   
}
//Create the database query based on the metric being plotted. Different variables use different tables, flag names, etc. 
function get_sql_query($lakeid, $variable) {

	//$lakeid = 'ME';        //test cases
	//$variable = 'totnuf';
	//Defaults
	$lakestr = "'".$lakeid."'";
	$flag = 'flag'.$variable;
	$datetype = 'Ymd';  //%Y-%m-%d
	
	switch ($variable) {
	   case 'totnuf':
	   case 'totpuf':
	   case 'chlor':
	   case 'doc':
		$table_name = 'chemphys'; 
	    $sqlstatement = "(SELECT sampledate , $variable FROM `".$table_name."` WHERE depth=0 AND $variable IS NOT NULL AND $flag IS NULL AND lakeid=$lakestr)";
	   break;	   
	   case 'ice_duration':
	    $lakename = get_lakename($lakeid);
		$lakestr = "'".$lakename."'";
		$table_name = 'icedata';
		$datetype = 'Y';
        $sqlstatement = "(SELECT start_year as sampledate, $variable FROM `".$table_name."` WHERE lakename=$lakestr AND $variable > -1 ORDER BY sampledate ASC)"; 		 
       break;
	   case 'lake_level':
        $table_name = 'sample';
		$var_fieldname = 'llevel_elevation';
	    $sqlstatement = "(SELECT sampledate , $var_fieldname as $variable FROM `".$table_name."` WHERE $var_fieldname IS NOT NULL AND lakeid=$lakestr)";
	   break;
	   case 'secchi':
        $table_name = 'sample';
		$var_fieldname = 'secnview';
	    $sqlstatement = "(SELECT sampledate , $var_fieldname as $variable FROM `".$table_name."` WHERE $var_fieldname IS NOT NULL AND lakeid=$lakestr)";	     
	   break;
	   //Get Fish
	   case 'fish':
	     $table_name = 'fish_richness';
		 $var_fieldname = 'richness';
		 $datetype = 'Y';
        $sqlstatement = "(SELECT year4 as sampledate, $var_fieldname as $variable FROM `".$table_name."` WHERE $var_fieldname IS NOT NULL AND lakeid=$lakestr)"; 		 
		 
	   break;
	  
	}

   $GLOBALS['datetype'] = $datetype;
   return $sqlstatement;

}

function get_plain_title($lakeid, $variable) {

  $lakename = get_lakename($lakeid);
  
  switch ($variable) {
	  case 'totnuf':
		$data_type = "Surface Concentration of Total N, Unfiltered";
		$units = "micrograms per liter";
      break;			
	  case 'totpuf':
		$data_type = "Surface Concentration of Total P, Unfiltered";
		$units = "micrograms per liter";
	  break;
	  case 'doc':
		$data_type = "Surface Concentration of Dissolved Organic Carbon";
		$units = "milligrams per liter";
	  break;
	  case 'chlor':
		$data_type = "Surface Concentration of Chlorophyll";
		$units = "micrograms per liter";
	  break;
	  case 'ice_duration':
		$data_type = "Duration of Ice Cover";
		$units = "days";	  
	  break;
	  case 'lake_level':
		$data_type = "Lake Level Elevation";
		$units = "meters above sea level";	  
	  break;
	  case 'secchi':
		$data_type = "Secchi Depth";
		$units = "meters";	  
	  break;
	  case 'fish':
	    $data_type = "Species Richness";
		$units = "number of species";
	  break;
  }
  //The units get sent to the js file, so set as a global variable.
  $GLOBALS['units'] = $units;

   $title = $lakename.": ".$data_type;
   return $title;
 
}
//Get the plain language lake name from lakeid
function get_lakename($lakeid) {

  //Get a lake name
  if ($lakeid == 'TR') $lakename = 'Trout Lake';
  if ($lakeid == 'SP') $lakename = 'Sparkling Lake';
  if ($lakeid == 'CR') $lakename = 'Crystal Lake';
  if ($lakeid == 'AL') $lakename = 'Allequash Lake';
  if ($lakeid == 'BM') $lakename = 'Big Muskellunge';
  if ($lakeid == 'CB') $lakename = 'Crystal Bog';
  if ($lakeid == 'TB') $lakename = 'Trout Bog';
  if ($lakeid == 'ME') $lakename = 'Lake Mendota';
  if ($lakeid == 'MO') $lakename = 'Lake Monona';
  if ($lakeid == 'WI') $lakename = 'Lake Wingra';
  if ($lakeid == 'FI') $lakename = 'Fish Lake';
  return $lakename;
}
