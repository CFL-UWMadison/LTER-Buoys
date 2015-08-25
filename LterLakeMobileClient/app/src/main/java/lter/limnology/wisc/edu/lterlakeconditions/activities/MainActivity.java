package lter.limnology.wisc.edu.lterlakeconditions.activities;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import lter.limnology.wisc.edu.lterlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.lterlakeconditions.R;
import lter.limnology.wisc.edu.lterlakeconditions.operations.WeatherOps;
import lter.limnology.wisc.edu.lterlakeconditions.utils.GenericActivity;
import lter.limnology.wisc.edu.lterlakeconditions.utils.Utils;


public class MainActivity extends GenericActivity<WeatherOps> {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_main);
        super.onCreate(savedInstanceState,
                WeatherOps.class);

    }

    public void onClick(View v) {
        String lakeId = "";
        switch (v.getId()) {
            case R.id.TR:
                lakeId = "TR";
                break;
            case R.id.SP:
                lakeId = "SP";
                break;
            case R.id.ME:
                lakeId = "ME";
                break;
        }
        getWeather(lakeId);

    }

    public void getWeather(String lakeId) {
        // Try to the current weather from either the cache or the
        // Weather Service web service.
        if (getOps().getCurrentWeather(lakeId) == false)
            // Pop an error toast if there's already a call in
            // progress.
            Utils.showToast(this,
                    "Call currently in progress");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
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

    public void displayResults(WeatherData weatherData) {
        Intent intent = new Intent(this, LakeConditions.class);
        intent.putExtra("weatherData", weatherData);
        startActivity(intent);
    }
}
