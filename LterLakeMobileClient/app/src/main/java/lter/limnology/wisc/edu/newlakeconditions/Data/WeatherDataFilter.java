package lter.limnology.wisc.edu.newlakeconditions.Data;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * This class will be used to make the data in the unit the user wants
 * The original data is in SI. It also changes nonsense data into MISSING_VAL passed
 * by the creator, which should be displayed as a flag in the application
 *
 * Created by xu on 7/22/16.
 */
public class WeatherDataFilter {

    private final double METRIC_TEMP_UPPER = 40;
    private final double METRIC_TEMP_LOWER = -5;

    private final double METRIC_WIND_SPEED_UPPER = 12;
    private final double METRIC_WIND_SPEED_LOWER = 0;

    private final double METRIC_THERMO_UPPER = 20;
    private final double METRIC_THERMO_LOWER = 0;

    private final double METRIC_SECCHI_UPPER = 10;
    private final double METRIC_SECCHI_LOWER = 0;
    private final double MISSING_VAL;

    WeatherData wd;

    public WeatherDataFilter(WeatherData wd, double missingVal){
        this.wd = wd;
        MISSING_VAL = missingVal;

    }

    public WeatherData filter() {

        //The sample is also required to be changed, because the origin one is hard to understand
        //Simple date formatter 2016-09-30T18:20:55
        SimpleDateFormat oldTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
        System.out.print(wd.getSampleDate());
        SimpleDateFormat newTimeFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
        try {
            Date time = oldTimeFormat.parse(wd.getSampleDate());
            wd.setSampleDate(newTimeFormat.format(time));
        } catch (ParseException e){
            //Log.e("Weather Data Filter", "Error when parsing the format");
        }
        wd.setAirTemp(filterData(wd.getAirTemp(),METRIC_TEMP_UPPER,METRIC_TEMP_LOWER));
        wd.setWaterTemp(filterData(wd.getWaterTemp(),METRIC_TEMP_UPPER,METRIC_TEMP_LOWER));
        wd.setWindSpeed(filterData(wd.getWindSpeed(),METRIC_WIND_SPEED_UPPER,METRIC_WIND_SPEED_LOWER));
        wd.setThermoclineDepth(filterData(wd.getThermoclineDepth(),METRIC_THERMO_UPPER,METRIC_THERMO_LOWER));

        if(wd.getLakeId().equals("ME")){
            wd.setSecchiEst(filterData(wd.getSecchiEst(),METRIC_SECCHI_UPPER,METRIC_SECCHI_LOWER));
        }

        return wd;
    }

    public double filterData(Object dataObj,double upperBound, double lowerBound){

        try {

            double data = ((Double) dataObj);
            if (data >= lowerBound && data <= upperBound) {
                return data;
            }
        } catch (Exception e){

        }

        return MISSING_VAL;
    }

}
