package lter.limnology.wisc.edu.newlakeconditions.operations;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import java.lang.ref.WeakReference;

import lter.limnology.wisc.edu.newlakeconditions.Data.MendotaWebServiceProxy;
import lter.limnology.wisc.edu.newlakeconditions.Data.WeatherData;
import lter.limnology.wisc.edu.newlakeconditions.Data.WeatherWebServiceProxy;
import lter.limnology.wisc.edu.newlakeconditions.activities.LakeConditions;
import lter.limnology.wisc.edu.newlakeconditions.activities.MainActivity;
import lter.limnology.wisc.edu.newlakeconditions.provider.Cache.WeatherTimeoutCache;
import lter.limnology.wisc.edu.newlakeconditions.utils.ConfigurableOperations;
import lter.limnology.wisc.edu.newlakeconditions.utils.GenericAsyncTask;
import lter.limnology.wisc.edu.newlakeconditions.utils.GenericAsyncTaskOps;
import retrofit.RestAdapter;

/**
 *
 */
public class WeatherOps
        implements ConfigurableOperations,
        GenericAsyncTaskOps<String, Void, WeatherData> {

    /**
     * This update listener will return the data when the weather ops gets the new data
     */
    public interface UpdateWeatherInfoListener{

        public void onReceivingWeatherInfo(WeatherData weatherData);
    }
    UpdateWeatherInfoListener updateListener;

    /**
     * Debugging tag used by the Android logger.
     */
    protected final String TAG = getClass().getSimpleName();

    /**
     * Used to enable garbage collection.
     */
    protected WeakReference<MainActivity> mActivity;


    protected WeakReference<LakeConditions> respondLakeConditions;
    /**
     * Content Provider-based cache for the WeatherData.
     */
    private WeatherTimeoutCache mCache;

    private WeatherWebServiceProxy mWeatherWebServiceProxy;
    private MendotaWebServiceProxy mMendotaWebServiceProxy;

    private Context mContext;

    /**
     * WeatherData object that is being displayed, which is used to
     * re-populate the UI after a runtime configuration change.
     */
    private WeatherData mCurrentWeatherData;

    /**
     * The GenericAsyncTask used to get the current lake conditions from the
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

    public void setUpdateListener(UpdateWeatherInfoListener updateListener){
        this.updateListener = updateListener;
    }

    /**
     * This method helps create different Weatherops with the right configuration. Weather
     * mcache and web service should be initialized after this call; developer should use method this
     * create weatherops
     *
     * @param context
     * @return
     */
    public static WeatherOps newOps(Context context){

        WeatherOps newOps = new WeatherOps();
        newOps.onConfiguration(context,true);
        return newOps;

    }

    /**
     * Called by the WeatherOps constructor and after a runtime
     * configuration change occurs to finish the initialization steps.
     */
    public void onConfiguration(Context context,
                                boolean firstTimeIn) {
        // Reset the mActivity WeakReference.
       // mActivity = new WeakReference<>((MainActivity) activity);

        mContext = context;
        //Do I need to specify what should happen if there is already data inside.
        //I assume every time it's created, it should be set to first time in
        if (firstTimeIn) {
            // Initialize the WeatherTimeoutCache.
            // Application context is used to avoid dependencies on the
            // Activity context, which will change if/when a runtime
            // configuration change occurs.
            mCache =
                    new WeatherTimeoutCache(mContext);

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
            firstTimeIn = false;
        } else if (mCurrentWeatherData != null) {
            // Populate the display if a WeatherData object is stored
            // in the WeatherOps instance

           // mActivity.get().displayResults(mCurrentWeatherData);
        }
    }

    /**
     *
     * @return false if a call is already in progress, else true.
     */
    public boolean loadCurrentLakeWeather(String location) {
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

    }

    /**
     * Get the current conditions either from the ContentProvider cache
     * or from the web service.
     */
    public WeatherData doInBackground(String location) {
        try {

            boolean networkOn = isNetworkAvailable();
            WeatherData weatherData;
            if (!networkOn) {
                // First the cache is checked for the data.
                weatherData =
                        mCache.get(location);

                // If data is in cache return it.
                if (weatherData != null) {
                    Log.v(TAG,
                            location
                                    + ": in cache");

                    return weatherData;
                }else {
                    Log.v(TAG,
                            location
                                +": not in cache");
                    return null;
                }
            }
            // If the location's data wasn't in the cache or was
            // stale, use Retrofit to fetch it from the web service.
            else {
                // Get the weather from the web service.

                weatherData =
                        mWeatherWebServiceProxy.getWeatherData(location);
             /*  if (location == "ME") {

                   MendotaData mendotaData = mMendotaWebServiceProxy.getWeatherData();
                    weatherData.setAirTemp(mendotaData.getAirTemp());
                    weatherData.setWindSpeed(mendotaData.getWindSpeed());
                    weatherData.setWindDir(mendotaData.getWindDirection());
                    weatherData.setWaterTemp(mendotaData.getWaterTemp());

                }*/

                // Check to make sure the call to the server succeeded
                // by testing the "name" member to make sure it was
                // initialized.
                if (weatherData.getLakeId() == null)
                    return null;

                // Add to cache.
                mCache.put(location,
                        weatherData);

                // Return the data.
                return weatherData;
            }
        } catch (Exception e) {
            return null;
        }
    }


    /**
     * Display the results in the UI Thread.
     */
    @Override
    public void onPostExecute(final WeatherData weatherData,
                              String location) {
        // Store the weather data in anticipation of runtime
        // configuration changes.
        if (weatherData != null)
            mCurrentWeatherData = weatherData;
            updateListener.onReceivingWeatherInfo(weatherData);
        // If the object was found, display the results.
       // mActivity.get().displayResults(mCurrentWeatherData);

        final String error = "";
      //  mActivity.get().displayResults(weatherData,error);

        // Indicate we're done with the AsyncTask.
        mAsyncTask = null;

        // Allow another call to proceed when this method returns.
        mCallInProgress = false;



    }

    /**
     * This method is used to check whether the network is available. It needs Context to
     * work.
     *
     * @return
     */
    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();


        if (activeNetworkInfo == null) {

            Log.v(TAG,"The network connection is lost");
            return false;
        } else {
            NetworkInfo.State network = activeNetworkInfo.getState();

            if(network == NetworkInfo.State.CONNECTED){
                Log.v(TAG,"The network connection is fine");
                return true;
            }
            Log.v(TAG,"The network connection is lost");
            return false;

        }
    }
}
