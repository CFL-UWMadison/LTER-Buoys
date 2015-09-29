package lter.limnology.wisc.edu.lterlakeconditions.provider;

import android.content.ContentUris;
import android.content.UriMatcher;
import android.net.Uri;
import android.provider.BaseColumns;

/**
 *
 */
public final class WeatherContract {
    /**
     * The WeatherProvider's unique authority identifier.
     */
    public static final String AUTHORITY =
            "lter.limnology.wisc.edu";

    /**
     * The base of all URIs that are used to communicate with the
     * WeatherProvider.
     */
    private static final Uri BASE_URI =
            Uri.parse("content://"
                    + AUTHORITY);

    /**
     * Constant for a directory MIME type.
     */
    private static final String MIME_TYPE_DIR =
            "cfluw.android.cursor.dir/";

    /**
     * Constant for a single item MIME type.
     */
    private static final String MIME_TYPE_ITEM =
            "cfluw.android.cursor.item/";

    /**
     * Path that accesses all the WeatherData for a given location,
     *
     */
    public static final String ACCESS_ALL_DATA_FOR_LOCATION_PATH =
            "access_all_for_location";

    public static final Uri ACCESS_ALL_DATA_FOR_LOCATION_URI =
            BASE_URI.buildUpon().appendPath
                    (ACCESS_ALL_DATA_FOR_LOCATION_PATH).build();


    /**
     * UriMatcher code for the Weather Values table.
     */
    public static final int WEATHER_VALUES_ITEMS = 100;

    /**
     * UriMatcher code for a specific row in the Weather Values table.
     */
    public static final int WEATHER_VALUES_ITEM = 110;

    public static final int ACCESS_ALL_DATA_FOR_LOCATION_ITEM = 300;


    public static final UriMatcher sUriMatcher =
            buildUriMatcher();

    /**
     * Build the UriMatcher for this Content Provider.
     */
    public static UriMatcher buildUriMatcher() {
        // Add default 'no match' result to matcher.
        final UriMatcher matcher =
                new UriMatcher(UriMatcher.NO_MATCH);

        // Initialize the matcher with the URIs used to access each
        // table.
        matcher.addURI(WeatherContract.AUTHORITY,
                WeatherContract.WeatherValuesEntry.WEATHER_VALUES_TABLE_NAME,
                WEATHER_VALUES_ITEMS);
        matcher.addURI(WeatherContract.AUTHORITY,
                WeatherContract.WeatherValuesEntry.WEATHER_VALUES_TABLE_NAME
                        + "/#",
                WEATHER_VALUES_ITEM);


        matcher.addURI(WeatherContract.AUTHORITY,
                WeatherContract.ACCESS_ALL_DATA_FOR_LOCATION_PATH,
                ACCESS_ALL_DATA_FOR_LOCATION_ITEM);

        return matcher;
    }

    /**
     * Inner class defining the contents of the Weather Values table.
     */
    public static final class WeatherValuesEntry
            implements BaseColumns {
        /**
         * Weather Values's Table name.
         */
        public static String WEATHER_VALUES_TABLE_NAME =
                "weather_values";

        /**
         * Unique URI for the Weather Values table.
         */
        public static final Uri WEATHER_VALUES_CONTENT_URI =
                BASE_URI.buildUpon()
                        .appendPath(WEATHER_VALUES_TABLE_NAME)
                        .build();

        /**
         * MIME type for multiple Weather Values rows.
         */
        public static final String WEATHER_VALUES_ITEMS =
                MIME_TYPE_DIR
                        + AUTHORITY
                        + "/"
                        + WEATHER_VALUES_TABLE_NAME;

        /**
         * MIME type for a single Weather Values row
         */
        public static final String WEATHER_VALUES_ITEM =
                MIME_TYPE_ITEM
                        + AUTHORITY
                        + "/"
                        + WEATHER_VALUES_TABLE_NAME;

        /*
         * Weather Values Table's Columns.
         */

        public static final String COLUMN_LAKE_ID = "lakeId";
        public static final String COLUMN_LAKE_NAME = "lakeName";
        public static final String COLUMN_AIR_TEMP = "airTemp";
        public static final String COLUMN_WATER_TEMP = "waterTemp";
        public static final String COLUMN_WIND_SPEED = "windSpeed";
        public static final String COLUMN_WIND_DIR = "windDir";
        public static final String COLUMN_SECCHI_EST = "secchiEst";
        public static final String COLUMN_PHYCO_MEDIAN = "phycoMedian";
        public static final String COLUMN_EXPIRATION_TIME = "expiration_time";
        public static final String COLUMN_THERMOCLINE_MEASURE = "thermoclineDepth";
        public static final String COLUMN_DATE = "sampleDate";

        /**
         * Return a URI that points to the row containing the given
         * ID.
         */
        public static Uri buildRowAccessUri(Long id) {
            return ContentUris.withAppendedId(WEATHER_VALUES_CONTENT_URI,
                    id);
        }
    }


}
