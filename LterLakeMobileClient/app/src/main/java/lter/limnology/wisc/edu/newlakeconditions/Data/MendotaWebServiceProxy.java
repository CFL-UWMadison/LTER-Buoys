package lter.limnology.wisc.edu.newlakeconditions.Data;

import retrofit.http.GET;

/**
 * Created by Shweta Nagar on 8/3/15.
 */
public interface MendotaWebServiceProxy {
    final String sWeather_Service_URL_Retro =
            "http://metobs.ssec.wisc.edu/app";

    @GET("/mendota_mapimage/buoy/data/json?symbols=t:spd:dir:wt_0.0")
    MendotaData getWeatherData();

}
