package lter.limnology.wisc.edu.lterlakeconditions.Data;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
/**
 * Created by Shweta Nagar on 8/3/15.
 */

/**
* {"symbols": ["AIR_TEMP", "WIND_SPEED_2.0", "WIND_DIRECTION_2.0"],
 * "stamps": ["2015-08-03 19:30:00", "2015-08-03 19:30:05", "2015-08-03 19:30:10",
 * "2015-08-03 19:30:15", "2015-08-03 19:30:20", "2015-08-03 19:30:25", "2015-08-03 19:30:30",
 * "2015-08-03 19:30:35", "2015-08-03 19:30:40", "2015-08-03 19:30:45", "2015-08-03 19:30:50",
 * "2015-08-03 19:30:55"], "data": [[24.03, 7.992, 295.6], [23.95, 7.796, 289.2],
 * [24.05, 7.796, 294.9], [24.0, 7.796, 302.1], [24.05, 7.502, 288.5], [24.08, 6.129, 297.7],
 * [24.15, 8.29, 298.1], [24.1, 9.17, 283.3], [24.1, 8.97, 277.3], [24.13, 8.48, 280.0],
 * [24.1, 8.29, 282.7], [24.13, 7.698, 279.3]]}
*/
public class MendotaData {
    @SerializedName("data")
    private List<Double[]> data = new ArrayList<Double[]>();

    public List<Double[]> getData() {
        return data;
    }

    public Double getAirTemp() {
        return (data != null && data.size() > 0) ? data.get(0)[0] : null;
    }

    public Double getWindSpeed() {
        return (data != null && data.size() > 0) ? data.get(0)[1] : null;
    }

    public Integer getWindDirection() {
        return (data != null && data.size() > 0) ? data.get(0)[2].intValue() : null;
    }

    public Double getWaterTemp() {
        return (data != null && data.size() > 0) ? data.get(0)[3] : null;
    }

    public void setData(List<Double[]> data) {
        this.data = data;
    }

}