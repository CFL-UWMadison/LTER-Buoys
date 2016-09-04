package lter.limnology.wisc.edu.newlakeconditions.Data;


import retrofit.http.GET;
import retrofit.http.Path;

/**
 *
 */
public interface WeatherWebServiceProxy {
    /**
     * URL to the LTER web service to use with the Retrofit
     * service.
     */
    final String sWeather_Service_URL_Retro =
            "http://thalassa.limnology.wisc.edu:8080/LakeConditionService";

    /**
     * Method used to query the web service for the
     * current lake conditions.
     */

    @GET("/webapi/lakeConditions/{lakeId}")
    WeatherData getWeatherData(@Path("lakeId") String location);


}
