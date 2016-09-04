package lter.limnology.wisc.edu.newlakeconditions.activities;

import android.content.SharedPreferences;
import android.os.Handler;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;
import android.support.v4.view.ViewPager;

import java.util.Timer;
import java.util.TimerTask;

import lter.limnology.wisc.edu.newlakeconditions.R;
import lter.limnology.wisc.edu.newlakeconditions.operations.WeatherOps;
import lter.limnology.wisc.edu.newlakeconditions.utils.GenericActivity;
import lter.limnology.wisc.edu.newlakeconditions.utils.Utils;


public class MainActivity extends GenericActivity<WeatherOps> {

    ViewPager pageRootController;
    LakeInfoAdapter lakeInfoAdapter;

    // This will be fetched from the LakeInfoAdapter
    String homePageID;
    ViewPager infoViewPager;
    String unitType;
    private static Timer autoUpdate;

    private final static String TAG = "Main Activity";

    @Override
    protected void onResume() {
        super.onResume();
        reportNetworkStatus();
        setUpAutoUpdate();
    }

    @Override
    protected void onPause() {
        super.onPause();
        stopTimer();
    }

    private void stopTimer(){

        autoUpdate.cancel();
        autoUpdate.purge();
        autoUpdate = null;
    }
    /**
     * Initialize the activity and set the view.
     *
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_tablayout);

        homePageID = getPreferences(MODE_PRIVATE).getString(UserSettingKey.HOME_PAGE_KEY, "");
        unitType = getPreferences(MODE_PRIVATE).getString(UserSettingKey.UNIT_TYPE,
                                                            UserSettingKey.BRI_UNIT_TYPE);
        lakeInfoAdapter = setUpViewPagerAdapter();

        // Info view pager implements an addOnPageChangeListener. ViewPager will send a message to
        // the will-appear fragment to react everytime time the page changes.
        infoViewPager = setUpViewPagerWithAdapter(lakeInfoAdapter);

        TabLayout lakenameTab = setUpTabLayoutWithViewpager(infoViewPager);

        // OnClickListener will set up. The homepage id will be changed to the current lakeid
        // if the button is clicked.
        FloatingActionButton settingHomeFab = setUpSetHomePageButton();

        // If network is available, the status will be logged into log file
        // If network is not available, user will receive a prompt on the user interface
        reportNetworkStatus();
        //autoUpdate.cancel();
    }

    private void setUpAutoUpdate(){
        autoUpdate = new Timer();
        autoUpdate.schedule(new TimerTask() {
            @Override
            public void run() {
                LakeConditions currentPage = (LakeConditions) getCurrentPage();
                if (currentPage != null) {
                    ((LakeConditions) getCurrentPage()).toUpdateData();
                    String lakeid = getCurrentPageLakeid();
                    Log.v(TAG, lakeid + " is getting updated");
                }
            }
        },
                1000,
                    60000);
    }

    private LakeInfoAdapter setUpViewPagerAdapter(){
        LakeInfoAdapter adapter = new LakeInfoAdapter(getSupportFragmentManager());
        adapter.setHomepageAsFirstInLakeMap(
                getPreferences(MODE_PRIVATE).getString(UserSettingKey.HOME_PAGE_KEY, ""));
        return adapter;
    }

    private ViewPager setUpViewPagerWithAdapter(LakeInfoAdapter adapter) {
        ViewPager viewPager = (ViewPager) findViewById(R.id.weather_viewer);
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                LakeConditions selectedPage = (LakeConditions) getFragment(position);
                ((LakeConditions) selectedPage).onPageAppear();
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        return viewPager;
    }

    private TabLayout setUpTabLayoutWithViewpager(ViewPager infoViewPager){
        TabLayout t = (TabLayout) findViewById(R.id.lakename_tab);
        t.setupWithViewPager(infoViewPager);
        return t;
    }

    private FloatingActionButton setUpSetHomePageButton(){
        final FloatingActionButton setHomeFab = (FloatingActionButton)findViewById(R.id.setHomeButton);
        setHomeFab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                // if the button is currently not the home page, set this thing as homepage
                // flip the icon
                if (!currentPageIsHomePage()){
                    setOnScreenLakeIDAsHomeID();
                    showFeedbackForNewHome();
                }else{
                    setHomeIDEmpty();
                }
                saveHomeIDToUserPreference();
                checkHomeButtonImage();

            }

        });
        return setHomeFab;
    }

    private void showFeedbackForNewHome(){
        Snackbar snackbar = Snackbar.make(findViewById(R.id.mainview),
                        "This page will be set as the homepage after you restart the app",
                            Snackbar.LENGTH_LONG);
        snackbar.show();

    }

    private void setOnScreenLakeIDAsHomeID(){
        this.homePageID = getCurrentPageLakeid();
    }

    private void reportNetworkStatus(){
        if (isNetworkAvailable() == false) {
            Toast.makeText(this, "No network connection. Lake conditions might be displayed from " +
                    "previously stored data and may not be current.", Toast.LENGTH_LONG).show();
        } else
            Log.d(TAG,"The network is available" );
    }

    private void saveHomeIDToUserPreference(){
        SharedPreferences setting = getPreferences(MODE_PRIVATE);
        SharedPreferences.Editor editor = setting.edit();
        editor.putString(UserSettingKey.HOME_PAGE_KEY,homePageID);
        editor.commit();
    }


    /**
     * This is a hack method for lake conditions to be used. You can delete this method
     * in the lake condition to see the bug.
     *
     * I hope someone can find a better way to fix this bug.
     */
    public void checkHomeButtonImage(){
        FloatingActionButton setHomeFab = (FloatingActionButton)findViewById(R.id.setHomeButton);
        if (currentPageIsHomePage()){
            setHomepageIconForFab(setHomeFab);
        }else{
            setNonHomepageIconForFab(setHomeFab);
        }

    }

    private void setHomepageIconForFab(FloatingActionButton setHomeFab){
        setHomeFab.setImageResource(R.drawable.ic_star_white_24dp);
    }

    private void setNonHomepageIconForFab(FloatingActionButton setHomeFab){
        setHomeFab.setImageResource(R.drawable.ic_star_border_white_24dp);
    }

    private void setHomeIDEmpty(){
        this.homePageID = "";
    }

    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        if (activeNetworkInfo == null) {
            return false;
        } else {
            return true;
        }
    }

    public void getWeather(String lakeId) {
        //The current lake conditions from either the cache or the
        // LTER web service.
        // http://argyron.limnology.wisc.edu:8080/LakeConditionService/
        // http://thalassa.limnology.wisc.edu:8080/LakeConditionService/
        if (getOps().loadCurrentLakeWeather(lakeId) == false)
            // Pop an error toast if there's already a call in progress.
            Utils.showToast(this,
                    "Call currently in progress");
    }

    private boolean currentPageIsHomePage(){
        return this.homePageID.equals(getCurrentPageLakeid());
    }

    private Fragment getCurrentPage(){
        return getFragment(getCurrentPageFragmentID());
    }

    private Fragment getFragment(int position){
        Fragment item = getSupportFragmentManager().findFragmentByTag("android:switcher:"
                + R.id.weather_viewer
                + ":" + position );

        return (LakeConditions) item;
    }

    private String getCurrentPageLakeid(){
        String currentLakeid = ((LakeConditions)getCurrentPage()).getLakeid();
        return currentLakeid;
    }

    private int getCurrentPageFragmentID(){
        return infoViewPager.getCurrentItem();
    }

    /**
     *
     * @param menu
     * @return
     */
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu
        // This adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);

        //set up default
        setCheckedUnit(menu);

        return true;
    }

    private void setCheckedUnit(Menu menu){
        MenuItem briOption = menu.findItem(R.id.bri);
        MenuItem metOption = menu.findItem(R.id.metri);
        switch (unitType){
            case UserSettingKey.BRI_UNIT_TYPE:
                briOption.setChecked(true);
                break;

            case UserSettingKey.METRIC_UNIT_TYPE:
                metOption.setChecked(true);
                break;
        }

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        switch (id){
            case R.id.about:
                Intent aboutIntent = new Intent(this, About.class);
                startActivity(aboutIntent);
                break;

            //for the unit type. There must be one being checked
            //if it's already been checked, don't do anything
            //if it's not, check it.
            case R.id.bri:
                if (!item.isChecked()){
                    item.setChecked(true);
                    unitType = UserSettingKey.BRI_UNIT_TYPE;
                    saveUnitTypeToPreference(unitType);
                    ((LakeConditions) getCurrentPage()).refreshView();

                }
                break;

            case R.id.metri:
                if (!item.isChecked()) {
                    item.setChecked(true);
                    unitType = UserSettingKey.METRIC_UNIT_TYPE;
                    saveUnitTypeToPreference(unitType);
                    ((LakeConditions) getCurrentPage()).refreshView();

                }
                break;

            case R.id.refresh:
                this.currentPageRefresh();
                Snackbar refreshBar = Snackbar.make(findViewById(R.id.mainview),"Data refreshing", Snackbar.LENGTH_SHORT);
                refreshBar.show();

        }
        return super.onOptionsItemSelected(item);
    }

    private void saveUnitTypeToPreference(String unitType){
        SharedPreferences setting = getPreferences(MODE_PRIVATE);
        SharedPreferences.Editor editor = setting.edit();
        editor.putString(UserSettingKey.UNIT_TYPE,unitType);
        editor.commit();
    }

    private void currentPageRefresh(){
        ((LakeConditions)(this.getCurrentPage())).toUpdateData();

    }


    //////////////////////////////////////////////////////
    //
    // Set up methods
    //
    /////////////////////////////////////////////////////


    ////////////////////////////////////////////////////////////
    //                                                        //
    //  Util for configuring the onclick for setHomeFab       //
    //                                                        //
    ////////////////////////////////////////////////////////////

}
