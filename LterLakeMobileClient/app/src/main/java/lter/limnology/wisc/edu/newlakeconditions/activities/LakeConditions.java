package lter.limnology.wisc.edu.newlakeconditions.activities;

import lter.limnology.wisc.edu.newlakeconditions.Data.MetricToBritishConverter;
import lter.limnology.wisc.edu.newlakeconditions.Data.MetricToMetricConverter;

import android.content.Context;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DecimalFormat;

import lter.limnology.wisc.edu.newlakeconditions.Data.MetricUnitConverter;
import lter.limnology.wisc.edu.newlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.newlakeconditions.Data.WeatherDataFilter;
import lter.limnology.wisc.edu.newlakeconditions.R;
import lter.limnology.wisc.edu.newlakeconditions.operations.WeatherOps;
import lter.limnology.wisc.edu.newlakeconditions.utils.LakeTermWiki;


public class LakeConditions extends Fragment{

    private TextView mLakeName;

    // Every block for a weather will be shown in user interface as three parts
    // Prompt: the name of a variable to remind user what this block is.
    // Unit: the unit of this variable. In the future, it will be used to change between the metric and British
    // Variable data: the data is the actual value in one of metric.

    private TextView mAirTempPrompt;
    private TextView mAirTemp;
    private TextView mAirTempUnit;

    private TextView mWaterTempPrompt;
    private TextView mWaterTemp;
    private TextView mWaterTempUnit;

    private TextView mWindSpeed;
    private TextView mWindSpeedPrompt;
    private TextView mWindSpeedUnit;

    private TextView mWindDirPrompt;
    private TextView mWindDir;
    private TextView mWindDirUnit;

    private TextView mThermocline;
    private TextView mTherPrompt;
    private TextView mTherUnit;

    private TextView mSecchiEst;
    private TextView mSecchiPrompt;
    private TextView mSecchiUnit;

    private ImageView tempImage;
    private ImageView waterImage;
    private ImageView windImage;
    private ImageView lakeImage;
    private TextView lakeImageTitle;

    private TextView mDateUpdated;
    private LinearLayout mMendotaData;
    private LinearLayout mMainLayout;
    private Button refreshButton;

    private FloatingActionButton setHomeButton;

    SwipeRefreshLayout swipeRefreshLayout;

    private static final double DATA_MISSING_VAL = 999;
    private static final String DATA_MISSING_STRING ="N/A";
    private static final String LAKEID = "lake id";
    private static final String WEATHER_DATA = "weather data";
    private static final String IS_HOME = "is home";
    public static String TAG = "Lake Conditions";

    private WeatherOps ops;
    private String lakeid;
    private WeatherData wd;
    private boolean isHome;
    private LakeTermWiki lakeTermWiki;

    public static LakeConditions newinstance(final String lakeid){
        LakeConditions lakeCondition = new LakeConditions();
        lakeCondition.setRetainInstance(true);
        Log.v(TAG,"********"+ " New Lake Condition has been created " + "********" );

        //I haven't thought argument that needs to be added.
        Bundle args = new Bundle();
        args.putString(LAKEID, lakeid);
       // args.putString(ARG_PARAM2, param2);
        lakeCondition.setArguments(args);


        return lakeCondition;
    }

    public void setWeatherOps (WeatherOps ops){
        this.ops = ops;
    }

    public String getLakeid(){ return lakeid;}

    /**
     * This initializes many instance variable.
     * @param savedInstanceState
     */
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        lakeid = (String) getArguments().get(LAKEID);
        wd = (WeatherData) getArguments().get(WEATHER_DATA);
        ops = setUpWeatherOpsWithUpdate();

        ops.loadCurrentLakeWeather(lakeid);
    }

    private WeatherOps setUpWeatherOpsWithUpdate(){
        WeatherOps ops = WeatherOps.newOps(getActivity().getApplicationContext());
        ops.setUpdateListener(new WeatherOps.UpdateWeatherInfoListener() {
            @Override
            public void onReceivingWeatherInfo(WeatherData weatherData) {
                // Make the data a part of the bundle, in case the data inside the fragment
                // get destroyed.
                getArguments().putSerializable(WEATHER_DATA, dataAfterClean(weatherData));
                refreshView();
                swipeRefreshLayout.setRefreshing(false);
            }
        });
        return ops;
    }

    private WeatherData dataAfterClean(WeatherData weatherData){
        if (weatherData != null) {
            System.out.println("******Data received for" + lakeid + "******");
            WeatherDataFilter filter = new WeatherDataFilter(weatherData, DATA_MISSING_VAL);
            weatherData = filter.filter();
        }
        return weatherData;
    }

    /**
     * This method is called to initialize the view component.
     * It will not call the ops to get data.
     *
     * @param inflater
     * @param container
     * @param savedInstanceState
     * @return
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_lakeinfo,container , false);
        swipeRefreshLayout = setRootviewToRefreshLayout(rootView);
        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                toUpdateData();
                swipeRefreshLayout.setRefreshing(true);
            }
        });

        initializeStaticTextView(rootView);
        setUpImageToImageView();
        setUpPromptExplanation(rootView);
        setHomeButtonIcon();
        ((MainActivity)getActivity()).checkHomeButtonImage();
        refreshView();

        /*
        //WeatherData weatherData = (WeatherData) getIntent().getSerializableExtra("weatherData");
        displayResults(lakeData, "");
        /*if (isNetworkAvailable() == false) {
            Toast.makeText(this, "No network connection. Lake conditions might be displayed from " +
                    "previously stored data and may not be current.", Toast.LENGTH_LONG).show();
        }*/

        return swipeRefreshLayout;
    }
    //I put almost initialization to this view to make the onCreateView easy to be read in the future.
    private void initializeStaticTextView(final View rootView){
        mLakeName = (TextView) rootView.findViewById(R.id.lakeName_tab);

        mDateUpdated = (TextView) rootView.findViewById(R.id.updateTime_tab);

        mAirTempPrompt = (TextView) rootView.findViewById(R.id.air_temp_prompt);
        mAirTemp = (TextView) rootView.findViewById(R.id.air_temp);
        mAirTempUnit = (TextView) rootView.findViewById(R.id.air_unit);

        mWaterTemp = (TextView) rootView.findViewById(R.id.water_temp);
        mWaterTempPrompt = (TextView) rootView.findViewById(R.id.water_temp_prompt);
        mWaterTempUnit = (TextView) rootView.findViewById(R.id.water_temp_unit);

        mWindSpeed = (TextView) rootView.findViewById(R.id.wind_speed);
        mWindSpeedPrompt = (TextView) rootView.findViewById(R.id.wind_speed_prompt);
        mWindSpeedUnit = (TextView) rootView.findViewById(R.id.wind_speed_unit);

        mWindDirPrompt = (TextView) rootView.findViewById(R.id.wind_dir_prompt);
        mWindDir = (TextView) rootView.findViewById(R.id.wind_dir);
        mWindDirUnit = (TextView) rootView.findViewById(R.id.wind_dir_unit);

        mThermocline = (TextView) rootView.findViewById(R.id.thermo);
        mTherPrompt = (TextView) rootView.findViewById(R.id.thermo_prompt);
        mTherUnit = (TextView) rootView.findViewById(R.id.thermo_unit);

        mSecchiEst = (TextView) rootView.findViewById(R.id.secchi);
        mSecchiPrompt = (TextView) rootView.findViewById(R.id.secchi_prompt);
        mSecchiUnit = (TextView) rootView.findViewById(R.id.secchi_unit);

        windImage = (ImageView) rootView.findViewById(R.id.wind_image);
        waterImage = (ImageView) rootView.findViewById(R.id.water_image);
        tempImage = (ImageView) rootView.findViewById(R.id.temp_image);
    }

    private void setUpImageToImageView(){
        windImage.setImageResource(R.drawable.wind_icon);
        waterImage.setImageResource(R.drawable.water_icon);
        tempImage.setImageResource(R.drawable.temp_image);

        /*
        if (lakeid.equals("ME")){
            lakeImage.setImageResource(R.drawable.me);
            lakeImageTitle.setText("Lake Mendota Map");
        } else if (lakeid.equals("TR")){
            lakeImage.setImageResource(R.drawable.tr);
            lakeImageTitle.setText("Trout Lake Map");
        } else if (lakeid.equals("SP")){
            lakeImage.setImageResource(R.drawable.sp);
            lakeImageTitle.setText("Sparkling Lake Map");
        }
        */

    }

    private void setUpPromptExplanation(View containerView){
        this.lakeTermWiki = new LakeTermWiki(containerView);
        lakeTermWiki.clickViewToShowToastWIKI(mAirTempPrompt,LakeTermWiki.AIR_TEMP_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(mWaterTempPrompt,LakeTermWiki.WATER_TEMP_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(mWindSpeedPrompt,LakeTermWiki.WIND_SPEED_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(mWindDirPrompt,LakeTermWiki.WIND_DIR_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(mTherPrompt, LakeTermWiki.THERMO_EXPLAIN, Toast.LENGTH_LONG);
        lakeTermWiki.clickViewToShowToastWIKI(waterImage,LakeTermWiki.WATER_IMAGE_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(windImage,LakeTermWiki.WIND_IMAGE_EXPLAIN);
        lakeTermWiki.clickViewToShowToastWIKI(tempImage,LakeTermWiki.TEMP_IMAGE_EXPLAIN);

        if (this.lakeid == "ME"){
            lakeTermWiki.clickViewToShowToastWIKI(mSecchiPrompt,LakeTermWiki.SECCHI_EXPLAIN, Toast.LENGTH_LONG);
        }
    }

    private SwipeRefreshLayout setRootviewToRefreshLayout(View rootView){
        SwipeRefreshLayout swipeRefreshLayout = new SwipeRefreshLayout(getActivity());
        swipeRefreshLayout.addView(rootView,ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        swipeRefreshLayout.setLayoutParams( new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));
        return swipeRefreshLayout;

    }

    /**
     * This function set the text for those text views.It will also handle the convert of the metric
     */
    public void refreshView(){

        wd = (WeatherData) getArguments().get(WEATHER_DATA);
        MetricUnitConverter converter= getConverter(DATA_MISSING_VAL);


        //A class called WeatherDataFilter will be created to help get the right data based on the unit.
        if(wd != null) {

            //The prompt has already been set statically. No need to be set during the runtime

            //Assign the unit to the unit textview
            mAirTempUnit.setText(converter.convertCelsiusUnit());
            mWaterTempUnit.setText(converter.convertCelsiusUnit());
            mTherUnit.setText(converter.convertMeterUnit());
            mWindSpeedUnit.setText(converter.convertMeterPerSecUnit());
            if (wd.getLakeId().equals("ME")){
                mSecchiUnit.setText(converter.convertMeterUnit());
            }

            //Assign text to the textview.
            mDateUpdated.setText("" + this.wd.sampleDate);
            setTextAfterChecking(mAirTemp,converter.convertCelsius(wd.getAirTemp()));
            setTextAfterChecking(mWaterTemp,converter.convertCelsius(wd.getWaterTemp()));
            setTextAfterChecking(mWindSpeed,converter.convertMetersPerSec(wd.getWindSpeed()));
            setTextAfterChecking(mWindDir,(double)((int) wd.getWindDir()));
            setTextAfterChecking(mThermocline,converter.convertMeters(wd.getThermoclineDepth()));
            if(wd.getLakeId().equals("ME")){
                setTextAfterChecking(mSecchiEst,converter.convertMeters(wd.getSecchiEst()));
                mSecchiPrompt.setText("Clarity");
            }else{
                mSecchiPrompt.setText("");
                mSecchiEst.setText("");
                mSecchiUnit.setText("");
            }

            //Customize some text in the TextView
            mWindDir.setText(mWindDir.getText()+ "°");

            //end
        }else{
            //If there is no data, then use data missing string to tell user
            //that the data is unavailable right now.
            mDateUpdated.setText("Network issue");
            mAirTemp.setText(DATA_MISSING_STRING);
            mWaterTemp.setText(DATA_MISSING_STRING);
            mWindDir.setText(DATA_MISSING_STRING);
            mWindSpeed.setText(DATA_MISSING_STRING);
            mThermocline.setText(DATA_MISSING_STRING);
            mSecchiPrompt.setText("Clarity");
            mSecchiEst.setText("N/A");
        }
    }

    private MetricUnitConverter getConverter(double missingValue){
        String unitType = getActivity().getPreferences(Context.MODE_PRIVATE).getString(UserSettingKey.UNIT_TYPE,"british");
        MetricUnitConverter converter = null;

        if (unitType.equals("british")) {
            converter = new MetricToBritishConverter(missingValue);
            converter.setCelsiusTarget("f");
            converter.setMetersPerSecTarget("mph");
            converter.setMetersTargetUnit("feet");
        }

        if (unitType.equals("metric")) {
            converter = new MetricToMetricConverter(missingValue);
        }

        return converter;
    }

    private void setTextAfterChecking(TextView textView,Double data ){

        DecimalFormat df = new DecimalFormat("#");

        if(data == DATA_MISSING_VAL){
            textView.setText(DATA_MISSING_STRING);
        }else{
            textView.setText("" +  df.format(data));
        }

    }

    /**
     * This method regulates how each fragment will prepare itself when the it show up on the user screen
     * This method should only be called by activity, in its on SelectPageListener
     *
     * Current function:
     *    1: Refresh the page when the user scroll to the page
     *    2: Set the home button
     *
     */
    public void onPageAppear(){

        //Refresh
        toUpdateData();

        //Set the home button
        setHomeButtonIcon();

    }

    private void setHomeButtonIcon(){
        FloatingActionButton setHomeButton =
                (FloatingActionButton) getActivity().findViewById(R.id.setHomeButton);

        if (isHomeInUserSetting()){
            setHomeButton.setImageResource(R.drawable.ic_star_white_24dp);
        }else
            setHomeButton.setImageResource(R.drawable.ic_star_border_white_24dp);
    }

    private boolean isHomeInUserSetting(){
        String homeId = getActivityHomeId();
        String thisLakeId =(String) getArguments().get(LAKEID);
        return thisLakeId.equals(homeId);
    }

    private String getActivityHomeId(){
        SharedPreferences pref = getActivity().getPreferences(Context.MODE_PRIVATE);
        String keyForHomeidInPref = UserSettingKey.HOME_PAGE_KEY;
        String id = pref.getString(keyForHomeidInPref,"");
        return id;
    }

    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getActivity().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        if (activeNetworkInfo == null) {
            return false;
        } else {
            return true;
        }
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu
        // This adds items to the action bar if it is present.
        //getActivity().getMenuInflater().inflate(R.menu.menu_main, menu);
        return false;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up
        return false;
    }

    /**
     * This call will be used to update the data.
     *
     */
    public void toUpdateData(){
        ops.loadCurrentLakeWeather(lakeid);
    }

    public void onTouch(View view) {
        LayoutInflater inflater = getActivity().getLayoutInflater();
        View layout = inflater.inflate(R.layout.custom_toast_view, (ViewGroup) getActivity().findViewById(R.id.custom_toast));

        ImageView image = (ImageView) layout.findViewById(R.id.image);
        TextView text = (TextView) layout.findViewById(R.id.text);
        switch (view.getId()) {
            case R.id.airDesc:
                image.setImageResource(R.drawable.air_temp);
                text.setText("Air Temperature");
                break;

            case R.id.waterDesc:
                text.setText("Water Temperature");
                break;

            case R.id.windDirection:
                image.setImageResource(R.drawable.wind_dir);
                text.setText("Wind Direction");
                break;

            case R.id.thermoclineDepth:
                text.setText("The depth of a steep temperature gradient in the lake marked by a layer above and below which the water is at different temperatures.");
                break;

            case R.id.secchiDepthEst:
                image.setImageResource(R.drawable.secchi_icon);
                text.setText("The depth at which a Secchi disk (a black & white circular plate) disappears from view as it is lowered into the water. It is used to measure water transparency.");
                break;

        }
        Toast toast = new Toast(getActivity().getApplicationContext());
        toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);
        toast.setDuration(Toast.LENGTH_LONG);
        toast.setView(layout);
        toast.show();
    }

}