package lter.limnology.wisc.edu.lterlakeconditions.operations;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import java.lang.ref.WeakReference;

import lter.limnology.wisc.edu.lterlakeconditions.Data.MendotaData;
import lter.limnology.wisc.edu.lterlakeconditions.Data.MendotaWebServiceProxy;
import lter.limnology.wisc.edu.lterlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.lterlakeconditions.Data.WeatherWebServiceProxy;
import lter.limnology.wisc.edu.lterlakeconditions.activities.MainActivity;
import lter.limnology.wisc.edu.lterlakeconditions.provider.Cache.WeatherTimeoutCache;
import lter.limnology.wisc.edu.lterlakeconditions.utils.ConfigurableOperations;
import lter.limnology.wisc.edu.lterlakeconditions.utils.GenericAsyncTask;
import lter.limnology.wisc.edu.lterlakeconditions.utils.GenericAsyncTaskOps;
import retrofit.RestAdapter;

/**
 *
 */
public class WeatherOps
        implements ConfigurableOperations,
        GenericAsyncTaskOps<String, Void, WeatherData> {
    /**
     * Debugging tag used by the Android logger.
     */
    protected final String TAG = getClass().getSimpleName();

    /**
     * Used to enable garbage collection.
     */
    protected WeakReference<MainActivity> mActivity;

//    protected LakeConditions mLakeConditions;
    /**
     * Content Provider-based cache for the WeatherData.
     */
    private WeatherTimeoutCache mCache;

    /**
     * Retrofit proxy that sends requests to the Weather Service web
     * service and converts the Json response to an instance of
     * AcronymData POJO class.
     */
    private WeatherWebServiceProxy mWeatherWebServiceProxy;
    private MendotaWebServiceProxy mMendotaWebServiceProxy;

    /**
     * WeatherData object that is being displayed, which is used to
     * re-populate the UI after a runtime configuration change.
     */
    private WeatherData mCurrentWeatherData;

    /**
     * The GenericAsyncTask used to get the current weather from the
     * web service.
     */
    private GenericAsyncTask<String, Void, WeatherData, WeatherOps> mAsyncTask;

    /**
     * Keeps track of whether a call is already in progress and
     * ignores subsequent calls until the first call is done.
     */
    private boolean mCallInProgress;

    /**
     * Default constructor that's needed by the GenericActivity
     * framework.
     */
    public WeatherOps() {
    }

    /**
     * Called by the WeatherOps constructor and after a runtime
     * configuration change occurs to finish the initialization steps.
     */
    public void onConfiguration(Activity activity,
                                boolean firstTimeIn) {
        // Reset the mActivity WeakReference.
        mActivity = new WeakReference<>((MainActivity) activity);
        //      mLakeConditions = new LakeConditions();

        if (firstTimeIn) {
            // Initialize the WeatherTimeoutCache.  We use the
            // Application context to avoid dependencies on the
            // Activity context, which will change if/when a runtime
            // configuration change occurs.
            mCache =
                    new WeatherTimeoutCache(activity.getApplicationContext());

            // Build the RetroFit RestAdapter, which is used to create
            // the RetroFit service instance, and then use it to build
            // the RetrofitWeatherServiceProxy.
            mWeatherWebServiceProxy =
                    new RestAdapter.Builder()
                            .setEndpoint(WeatherWebServiceProxy.sWeather_Service_URL_Retro)
                            .build()
                            .create(WeatherWebServiceProxy.class);
            mMendotaWebServiceProxy =
                    new RestAdapter.Builder()
                            .setEndpoint(MendotaWebServiceProxy.sWeather_Service_URL_Retro)
                            .build()
                            .create(MendotaWebServiceProxy.class);
        } else if (mCurrentWeatherData != null) {
            // Populate the display if a WeatherData object is stored
            // in the WeatherOps instance.
            mActivity.get().displayResults(mCurrentWeatherData);
        }
    }

    /**
     * Initiate the synchronous weather lookup when the user presses
     * the "Get Weather" button.
     *
     * @return false if a call is already in progress, else true.
     */
    public boolean getCurrentWeather(String location) {
        if (mCallInProgress)
            return false;
        else {
            // Don't allow concurrent calls to get the weather.
            mCallInProgress = true;

            if (mAsyncTask != null)
                // Cancel an ongoing operation to avoid having two
                // requests run concurrently.
                mAsyncTask.cancel(true);

            // Execute the AsyncTask to get the weather without
            // blocking the caller.
            mAsyncTask = new GenericAsyncTask<>(this);
            mAsyncTask.execute(location);
            return true;
        }
    }

    @Override
    public void onPreExecute() {

        Log.i("***********WeatherOps.AsyncTask", "onPreExecute********");
    }

    /**
     * Get the current weather either from the ContentProvider cache
     * or from the Weather Service web service.
     */
    public WeatherData doInBackground(String location) {
        Log.i("***********WeatherOps.AsyncTask", "doInBackground********");
        try {
            // First the cache is checked for the location's weather
            // data.
            WeatherData weatherData =
                    mCache.get(location);

            // If data is in cache return it.
            if (weatherData != null) {
                Log.v(TAG,
                        location
                                + ": in cache");

                return weatherData;
            }

            // If the location's data wasn't in the cache or was
            // stale, use Retrofit to fetch it from the Weather
            // Service web service.
            else {
                Log.v(TAG,
                        location
                                + ": not in cache");

                // Get the weather from the Weather Service web
                // service.

                    weatherData =
                            mWeatherWebServiceProxy.getWeatherData(location);
                if (location == "ME") {

                   MendotaData mendotaData = mMendotaWebServiceProxy.getWeatherData();
                    weatherData.setAirTemp(mendotaData.getAirTemp());
                    weatherData.setWindSpeed(mendotaData.getWindSpeed());
                    weatherData.setWindDir(mendotaData.getWindDirection());
                    weatherData.setWaterTemp(mendotaData.getWaterTemp());

                }

                // Check to make sure the call to the server succeeded
                // by testing the "name" member to make sure it was
                // initialized.
                if (weatherData.getLakeId() == null)
                    return null;

                // Add to cache.
                mCache.put(location,
                        weatherData);

                // Return the weather data.
                return weatherData;
            }
        } catch (Exception e) {
            Log.v(TAG,
                    "doInBackground() "
                            + e);
            return null;
        }
    }


    /**
     * Display the results in the UI Thread.
     */
    @Override
    public void onPostExecute(WeatherData weatherData,
                              String location) {
        Log.i("***********WeatherOps.AsyncTask", "onPostExecute********");
        // Store the weather data in anticipation of runtime
        // configuration changes.
        if (weatherData != null)
            mCurrentWeatherData = weatherData;

        // If the object was found, display the results.
        mActivity.get().displayResults(mCurrentWeatherData);

        // Indicate we're done with the AsyncTask.
        mAsyncTask = null;

        // Allow another call to proceed when this method returns.
        mCallInProgress = false;
    }
}
