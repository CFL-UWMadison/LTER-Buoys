package lter.limnology.wisc.edu.lterlakeconditions.activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import lter.limnology.wisc.edu.lterlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.lterlakeconditions.R;
import lter.limnology.wisc.edu.lterlakeconditions.utils.Utils;


public class LakeConditions extends Activity {

    private TextView mLakeName;
    private TextView mDay;
    private TextView mDate;
    private TextView mAirDesc;
    private TextView mAirTempCelsius;
    private TextView mAirTempFahrenheit;
    private TextView mWaterTempCelsius;
    private TextView mWaterTempFahrenheit;
    private TextView mDateUpdated;
    private TextView mWindSpeed;
    private TextView mSecchiEst;
    private TextView mThermoclineDepth;
    private TextView mThermoclineMeasure;
    private LinearLayout mMendotaData;
    private LinearLayout mMainLayout;
    Bitmap bmp, bmp1, bmp2;
    Drawable imageBackground, bigMuskyimageBackground;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lake_conditions);
        getActionBar().setDisplayHomeAsUpEnabled(true);
        mLakeName = (TextView) findViewById(R.id.lakeName);
        mDay = (TextView) findViewById(R.id.day);
        mDate = (TextView) findViewById(R.id.date);
        mAirDesc = (TextView) findViewById(R.id.airDesc);
        mAirTempCelsius = (TextView) findViewById(R.id.airTempCelsius);
        mAirTempFahrenheit = (TextView) findViewById(R.id.airTempFahrenheit);
        mWaterTempCelsius = (TextView) findViewById(R.id.waterTempCelsius);
        mWaterTempFahrenheit = (TextView) findViewById(R.id.waterTempFahrenheit);
        mDateUpdated = (TextView) findViewById(R.id.dateUpdated);
        mWindSpeed = (TextView) findViewById(R.id.windSpeed);
        mSecchiEst = (TextView) findViewById(R.id.secchiEst);
        mMendotaData = (LinearLayout) findViewById(R.id.mendotaData);
        mMainLayout = (LinearLayout) findViewById(R.id.mainlayout);
        mThermoclineDepth = (TextView) findViewById(R.id.thermoclineDepth);
        mThermoclineMeasure = (TextView) findViewById(R.id.thermoclineMeasure);
        mMendotaData.setVisibility(View.GONE);
        Display display = getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        bmp = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(
                getResources(), R.drawable.mendota_image), size.x, size.y, true);
        bmp1 = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(
                getResources(), R.drawable.bigmusky), size.x, size.y, true);
        bmp2 = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(
                getResources(), R.drawable.mendota_image), size.x, size.y, true);

        imageBackground = new BitmapDrawable(getResources(), bmp);
        bigMuskyimageBackground = new BitmapDrawable(getResources(), bmp1);

        WeatherData weatherData = (WeatherData) getIntent().getSerializableExtra("weatherData");
        displayResults(weatherData, "");
        if (isNetworkAvailable() == false) {
            Toast.makeText(this, "No network connection. Lake conditions might be displayed from " +
                    "previously stored data and may not be current.", Toast.LENGTH_LONG).show();
        }


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

    public void onTouch(View view) {
        LayoutInflater inflater = getLayoutInflater();
        View layout = inflater.inflate(R.layout.custom_toast_view, (ViewGroup) findViewById(R.id.custom_toast));

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
        Toast toast = new Toast(getApplicationContext());
        toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);

        toast.setDuration(Toast.LENGTH_LONG);
        toast.setView(layout);
        toast.show();


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu
        // This adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button
        int id = item.getItemId();


        if (id == R.id.about) {
            Intent aboutIntent = new Intent(this, About.class);
            startActivity(aboutIntent);
        }
        return super.onOptionsItemSelected(item);
    }

    public void displayResults(WeatherData wd,
                               String errorReason) {
        final String dateText =
                Utils.formatCurrentDate();

        // Update views for day of week and date.
        mDay.setText("Today ");
        mDate.setText(dateText);

        if (wd == null) {
            mLakeName.setText("Not Found");
            mAirTempCelsius.setText("0.0");
            mAirTempFahrenheit.setText("0.0");
            mWindSpeed.setText("0.0");
            mWaterTempCelsius.setText("0.0");
            mWaterTempFahrenheit.setText("0.0");
            mThermoclineMeasure.setText("0.0");

        } else {
            final String locationName =
                    wd.getLakeName();

            // Update view for lake name.
            mLakeName.setText(locationName);

            if ((wd.getLakeId()).equals("TR")) {
                mMainLayout.setBackground(bigMuskyimageBackground);
            }
            if ((wd.getLakeId()).equals("SP")) {
                mMainLayout.setBackground(imageBackground);
            }
            if ((wd.getLakeId()).equals("ME")) {
                mMainLayout.setBackground(imageBackground);
                mMendotaData.setVisibility(View.VISIBLE);
                if (wd == null) {
                    mSecchiEst.setText("0.0");
                } else {
                    final Double secchiEst = wd.getSecchiEst();
                    final String secchiText = "" + secchiEst + " m";
                    mSecchiEst.setText(secchiText);
                }
            }

            // Read  update the view.
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            try {
                Date date = dateFormat.parse(wd.getSampleDate());
                mDateUpdated.setText("Last updated " + formatter.format(date));
            } catch (ParseException pe) {
                pe.printStackTrace();
            }

            final double airTemp = wd.getAirTemp();
            final String tempCelsius = Utils.formatTemperature(this, airTemp, false) + "C";
            final String tempFahrenheit = Utils.formatTemperature(this, airTemp, true) + "F";
            mAirTempCelsius.setText(tempCelsius);
            mAirTempFahrenheit.setText(tempFahrenheit);

            // Read  update the view.
            double windDirStr = wd.getWindDir();

            // Read wind speed and direction and update the view.
            final String windSpeedText = wd.getWindSpeed() + " m/s " + Utils.getFormattedWind(this, windDirStr);
            mWindSpeed.setText(windSpeedText);

            final String thermoclineMeasure = wd.getThermoclineDepth() + " m ";
            if (wd.getThermoclineDepth() == null) {
                mThermoclineMeasure.setText("Not Found");

            } else {
                mThermoclineMeasure.setText(thermoclineMeasure);
            }

            if (null == wd.getWaterTemp()) {
                mWaterTempCelsius.setText("Not Found");

            } else {
                final double waterTemp = wd.getWaterTemp();
                final String waterTempCelsius = Utils.formatTemperature(this, waterTemp, false) + "C";
                final String waterTempFahrenheit = Utils.formatTemperature(this, waterTemp, true) + "F";
                mWaterTempCelsius.setText(waterTempCelsius);
                mWaterTempFahrenheit.setText(waterTempFahrenheit);
            }
        }
    }
}