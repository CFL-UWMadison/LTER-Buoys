package lter.limnology.wisc.edu.newlakeconditions.utils;

import android.content.Context;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import lter.limnology.wisc.edu.newlakeconditions.R;

/**
 *
 */
public class Utils {
    /**
     * Show a toast message.
     */
    public static void showToast(Context context, String message) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }

    private Utils() {
        throw new AssertionError();
    }

    public static String formatCurrentDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM  dd ");
        Calendar c = Calendar.getInstance();
        return sdf.format(c.getTime());
    }

    public static String formatTemperature(Context context, double temperature,
                                           boolean isFahrenheit) {
        if (isFahrenheit)
            temperature = ((temperature / 5) * 9) + 32;

        return String.format(context.getString(R.string.format_temperature),
                temperature);
    }

    public static String getFormattedWind(Context context, double windDirStr) {
        // From wind direction in degrees, determine compass direction
        // as a string (e.g., NW).
        String direction = "Unknown";
        if (windDirStr >= 337.5 || windDirStr < 22.5)
            direction = "N";
        else if (windDirStr >= 22.5 && windDirStr < 67.5)
            direction = "NE";
        else if (windDirStr >= 67.5 && windDirStr < 112.5)
            direction = "E";
        else if (windDirStr >= 112.5 && windDirStr < 157.5)
            direction = "SE";
        else if (windDirStr >= 157.5 && windDirStr < 202.5)
            direction = "S";
        else if (windDirStr >= 202.5 && windDirStr < 247.5)
            direction = "SW";
        else if (windDirStr >= 247.5 && windDirStr < 292.5)
            direction = "W";
        else if (windDirStr >= 292.5 && windDirStr < 337.5)
            direction = "NW";
        return direction;
    }

}
