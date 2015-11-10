<?php
/*
 *  Implements hook_menu();
*/

function d3_tempmap_menu() {
  $items = array();

  //"lakeTempMap" will be the URL
  $items['lakeTempMap/%'] = array(
    'title' => '',
    'page callback' => 'd3_tempmap_basic', //php function name
    'page arguments' => array(1),  //mult. args are (1,2,3)...
    'access arguments' => array('access content'),
    //can put callback function in separate file: see 'file' or Drupalize video 9
  );
  return $items;
}


function d3_tempmap_basic($lakeid) {

  //Get the water temp data from the database.
  get_waterTemps($lakeid);

  $content = array();

  //Display a lake name title
  if ($lakeid == 'TR') $lakename = '  Trout Lake';
  if ($lakeid == 'SP') $lakename = '  Sparkling Lake';
  $content['raw_markup'] = array(
    '#type' => 'markup',
    '#markup' => $lakename,
    '#prefix' => '<h4 style="margin-left:50px;">',
    '#suffix' => '</h4>',
  );

  //Use a container
  $content['div_container'] = array(
    '#type' => 'container',
    '#attributes' => array(
       'id' => array('mapDiv'),
     ),
  );

  $content['div_container']['css_content'] = array(
    '#type' => 'markup',
    '#attached' => array(
      'css' => array(
        drupal_get_path('module','d3_tempmap').'/d3_tempmap.css',
      ),
    ),  
  );

  $content['div_container']['js_content'] = array(
    '#type' => 'markup',
    '#attached' => array(
      'js' => array(
        drupal_get_path('module','d3_tempmap').'/tempmap.js',
        array(
 	  'type' => 'setting', 
	  'data' => array(
 	    'numdays' => $GLOBALS['numdays'], 
	    'numdepths' => $GLOBALS['numdepths'],
            'depths_array' => $GLOBALS['Depths'],
            'temps_array' => $GLOBALS['Temps'],
            'dates_array' => $GLOBALS['Dates'],
           )
         ),
       ),
     ),
  );

  return $content;
}

function get_waterTemps($lakeid) { 

$php_cur_year = 2015;

if ($lakeid == 'SP') {
  //SP data
  $table_name = "sensor_sparkling_lake_watertemp_daily";
  $php_depths = array(0,0.25,0.5,0.75,1,1.25,1.5,2,2.5,3,3.5,4,4.5,5,6,7,8,9,10,11,12,13,14,16,18); 
  $php_num_depths = 25;
}
else if ($lakeid == 'TR') {
  //TR data
  $table_name = "sensor_trout_lake_russ_watertemp_daily";
  $php_depths = array(0,0.25,0.5,0.75,1,1.5,2,2.5,3,3.5,4,5,6,7,8,9,10,11,12,13,14,16,20,25,30); 
  $php_num_depths = 25;
}

$sql_getdays = "(SELECT min(daynum) as minday, max(daynum) as maxday FROM `".$table_name."` where year4 = 2015)";
db_set_active('dbmaker');
$result = db_query($sql_getdays);

foreach ($result as $row) {  
  $php_min_day = $row->minday;
  $php_max_day = $row->maxday;
}
$php_numdays = $php_max_day-$php_min_day+1;

//Initialize the temps array to -1; null values to appear as white
$php_dates = array();
$php_temps = array();
for ($col=0; $col<$php_numdays; $col++) { for ($row=0; $row<$php_num_depths; $row++) { $php_temps[$row][$col]=-1; }}

//Loop days; build an sql query seperately for each day.
for ($col=0; $col<$php_numdays; $col++) {
     $curday = $php_min_day + $col;

     $sqlstatement = "(SELECT sampledate, depth, wtemp FROM `".$table_name."` where year4=2015 and daynum=" .$curday .")";
     $result = db_query($sqlstatement); 
	 foreach ($result as $row) { 
        $php_dates[$col] = $row->sampledate;	 		
		$depth = $row->depth;
		$wtemp = $row->wtemp;
		//Brute force way to order depths but doesn't require that depth order in the table remain constant.
		for ($i=0; $i<$php_num_depths; $i++) {
			if ($depth==$php_depths[$i]) {			    
                $php_temps[$i][$col] = $wtemp;  //2d array of [depths][days]
            }//if
		}//for $i			
	}//foreach	 
}//for $col
db_set_active('default');

$GLOBALS['numdays'] = $php_numdays; 
$GLOBALS['numdepths'] = $php_num_depths;
$GLOBALS['Depths'] = $php_depths;
$GLOBALS['Temps'] = $php_temps;
$GLOBALS['Dates'] = $php_dates;

}

