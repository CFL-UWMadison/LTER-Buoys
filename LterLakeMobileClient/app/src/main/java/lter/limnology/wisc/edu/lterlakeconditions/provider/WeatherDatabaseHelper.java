package lter.limnology.wisc.edu.lterlakeconditions.provider;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.File;

/**
 *
 */
public class WeatherDatabaseHelper extends SQLiteOpenHelper {
    /**
     * Database name.
     */
    private static String DATABASE_NAME =
            "weather_db";

    /**
     * Database version number, which is updated with each schema
     * change.
     */
    private static int DATABASE_VERSION = 1;

    /*
     * SQL create table statements.
     */

    /**
     * SQL statement used to create the Weather Values table.
     */
    private static final String CREATE_TABLE_WEATHER_VALUES =
            "CREATE TABLE "
                    + WeatherContract.WeatherValuesEntry.WEATHER_VALUES_TABLE_NAME
                    + "("
                    + WeatherContract.WeatherValuesEntry._ID
                    + " INTEGER PRIMARY KEY, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_LAKE_ID
                    + " TEXT, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_LAKE_NAME
                    + " TEXT, "
//                     + WeatherContract.WeatherValuesEntry.COLUMN_DATE
//                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_PHYCO_MEDIAN
                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_SECCHI_EST
                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_WATER_TEMP
                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_WIND_DIR
                    + " INTEGER, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_AIR_TEMP
                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_WIND_SPEED
                    + " REAL, "
                    + WeatherContract.WeatherValuesEntry.COLUMN_EXPIRATION_TIME
                    + " INTEGER)";


    /**
     * Constructor - initialize database name and version, but don't
     * actually construct the database (which is done in the
     * onCreate() hook method). It places the database in the
     * application's cache directory, which will be automatically
     * cleaned up by Android if the device runs low on storage space.
     *
     * @param context
     */
    public WeatherDatabaseHelper(Context context) {
        super(context,
                context.getCacheDir()
                        + File.separator
                        + DATABASE_NAME,
                null,
                DATABASE_VERSION);
    }

    /**
     * Hook method called when the database is created.
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        // Create the tables.
        db.execSQL(CREATE_TABLE_WEATHER_VALUES);

    }

    /**
     * Hook method called when the database is upgraded.
     */
    @Override
    public void onUpgrade(SQLiteDatabase db,
                          int oldVersion,
                          int newVersion) {
        // Delete the existing tables.
        db.execSQL("DROP TABLE IF EXISTS "
                + WeatherContract.WeatherValuesEntry.WEATHER_VALUES_TABLE_NAME);
        // Create the new tables.
        onCreate(db);
    }
}

