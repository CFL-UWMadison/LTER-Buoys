package lter.limnology.wisc.edu.newlakeconditions.Data;

/**
 * This interface regulates the convert how the data is converted ONLY FROM SI to other unit
 * such as itself, or british
 *
 * Created by xu on 7/22/16.
 */
public interface MetricUnitConverter {

    public void setMetersTargetUnit(String target);
    public void setMetersPerSecTarget(String target);
    public void setCelsiusTarget(String target);

    public void setMissingValue(double missingValue);

    public double convertMetersPerSec(double ms);
    public double convertMeters(double meter);
    public double convertCelsius(double celsius);

    public String convertMeterUnit();
    public String convertMeterPerSecUnit();
    public String convertCelsiusUnit();


}
