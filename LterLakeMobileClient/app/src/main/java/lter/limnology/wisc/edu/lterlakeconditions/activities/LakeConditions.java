package lter.limnology.wisc.edu.lterlakeconditions.activities;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import lter.limnology.wisc.edu.lterlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.lterlakeconditions.R;
import lter.limnology.wisc.edu.lterlakeconditions.utils.Utils;


public class LakeConditions extends Activity {

    private TextView mLakeName;
    private TextView mDay;
    private TextView mDate;
    private TextView mAirTempCelsius;
    private TextView mAirTempFahrenheit;
    private TextView mWaterTempCelsius;
    private TextView mWaterTempFahrenheit;
    private TextView mWindSpeed;
    private TextView mSecchiEst;
   // private TextView mPhycoMedian;
    private LinearLayout mMendotaData;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lake_conditions);
        mLakeName = (TextView) findViewById(R.id.lakeName);
        mDay = (TextView) findViewById(R.id.day);
        mDate = (TextView) findViewById(R.id.date);
        mAirTempCelsius = (TextView) findViewById(R.id.airTempCelsius);
        mAirTempFahrenheit = (TextView) findViewById(R.id.airTempFahrenheit);
        mWaterTempCelsius = (TextView) findViewById(R.id.waterTempCelsius);
        mWaterTempFahrenheit = (TextView) findViewById(R.id.waterTempFahrenheit);
        //  mWindDirection = (TextView) findViewById(R.id.windDirection);
        mWindSpeed = (TextView) findViewById(R.id.windSpeed);
        mSecchiEst = (TextView) findViewById(R.id.secchiEst);
       // mPhycoMedian = (TextView) findViewById(R.id.phycoMedian);
        mMendotaData = (LinearLayout) findViewById(R.id.mendotaData);
        mMendotaData.setVisibility(View.GONE);
        WeatherData weatherData = (WeatherData) getIntent().getSerializableExtra("weatherData");
        displayResults(weatherData, "");

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_lake_conditions, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void displayResults(WeatherData wd,
                               String errorReason) {
        System.out.println("#### LakeConditions Activity -- displayResults mLakeName = " + mLakeName);
        final String dateText =
                Utils.formatCurrentDate();

        // Update views for day of week and date.
        mDay.setText("Today");
        mDate.setText(dateText);

        if (wd == null) {
            mLakeName.setText("Not Found");
            mAirTempCelsius.setText("0.0");
            mAirTempFahrenheit.setText("0.0");
            // mWindDirection.setText("0.0");
            mWindSpeed.setText("0.0");
            mWaterTempCelsius.setText("0.0");
            mWaterTempFahrenheit.setText("0.0");

        } else {
            final String locationName =
                    wd.getLakeName();

            // Update view for lake name.
            mLakeName.setText(locationName);
            if ((wd.getLakeId()).equals("ME")) {
                mMendotaData.setVisibility(View.VISIBLE);
                if (wd == null) {
                    //mPhycoMedian.setText("0.0");
                    mSecchiEst.setText("0.0");
                } else {
                    final Double phycoMedian = wd.getPhycoMedian();
                    //final String phycoText = "Phyco Median : " + phycoMedian;
                    //mPhycoMedian.setText(phycoText);
                    final Double secchiEst = wd.getSecchiEst();
                    final String secchiText = "" + secchiEst + " m";

                    mSecchiEst.setText(secchiText);
                }
            }
            // Read update the view.


            final double airTemp = wd.getAirTemp();
            final String tempCelsius = Utils.formatTemperature(this, airTemp, false) + "C";
            final String tempFahrenheit = Utils.formatTemperature(this, airTemp, true) + "F";
            mAirTempCelsius.setText(tempCelsius);
            mAirTempFahrenheit.setText(tempFahrenheit);

            // Read  update the view.
            double windDirStr = wd.getWindDir();
        /*    final String windDirectionText = "Wind Direction:  "
                  + windDirStr;
             mWindDirection.setText(windDirectionText);
        */
            // Read wind speed and direction and update the view.

            final String windSpeedText = "Wind :  "
                    + wd.getWindSpeed() + " m/s " + Utils.getFormattedWind(this, windDirStr);
            mWindSpeed.setText(windSpeedText);

            final double waterTemp = wd.getWaterTemp();
            final String waterTempCelsius = Utils.formatTemperature(this, waterTemp, false) + "C";
            final String waterTempFahrenheit = Utils.formatTemperature(this, waterTemp, true) + "F";
            mWaterTempCelsius.setText(waterTempCelsius);
            mWaterTempFahrenheit.setText(waterTempFahrenheit);


        }
    }
}