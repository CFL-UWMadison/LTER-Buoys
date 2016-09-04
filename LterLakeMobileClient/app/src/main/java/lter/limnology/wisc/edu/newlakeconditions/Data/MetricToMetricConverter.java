package lter.limnology.wisc.edu.newlakeconditions.Data;

/**
 * Created by xu on 7/22/16.
 */
public class MetricToMetricConverter implements MetricUnitConverter {

    private String msTarget;

    private String celsiusTarget;

    private String meterTarget;

    private Double missingValue;

    public MetricToMetricConverter(){
        missingValue = null;
    }

    public MetricToMetricConverter(double missingVal){
        this.setMissingValue(missingVal);
    }

    @Override
    public void setMissingValue(double missingValue) {
        this.missingValue = missingValue;
    }

    @Override
    public void setMetersPerSecTarget(String target) {
        this.msTarget = target;
    }

    @Override
    public void setMetersTargetUnit(String target) {
        this.meterTarget = target;
    }

    @Override
    public void setCelsiusTarget(String celsiusTarget) {
        this.celsiusTarget = celsiusTarget;
    }

    @Override
    public double convertCelsius(double celsius) {
        return celsius;
    }

    @Override
    public double convertMetersPerSec(double ms) {
        return ms;
    }

    @Override
    public double convertMeters(double meter) {
        return meter;
    }

    @Override
    public String convertMeterUnit() {
        return "m";
    }

    @Override
    public String convertMeterPerSecUnit() {
        return "m/s";
    }

    @Override
    public String convertCelsiusUnit() {
        return "°C";
    }
}
