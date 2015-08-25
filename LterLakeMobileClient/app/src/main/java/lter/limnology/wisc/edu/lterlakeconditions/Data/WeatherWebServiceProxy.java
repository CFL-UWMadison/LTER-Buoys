package lter.limnology.wisc.edu.lterlakeconditions.Data;


import retrofit.http.GET;
import retrofit.http.Path;
import retrofit.http.Query;

/**
 *
 */
public interface WeatherWebServiceProxy {
    /**
     * URL to the Web Search web service to use with the Retrofit
     * service.
     */
    final String sWeather_Service_URL_Retro =
            "http://argyron.limnology.wisc.edu:8080/LakeConditionService";

    /**
     * Method used to query the Weather Service web service for the
     * current weather at a city @a location.  The annotations enable
     * Retrofit to convert the @a location parameter into an HTTP
     * request, which would look something like this:
     * http://api.openweathermap.org/data/2.5/weather?q=location
     */
//    @GET("/webapi/lakeConditions/")
//    WeatherData getWeatherData(@Query("q") String location);

    @GET("/webapi/lakeConditions/{lakeId}")
    WeatherData getWeatherData(@Path("lakeId") String location);


}
