package lter.limnology.wisc.edu.newlakeconditions.Data;

/**
 * Created by xu on 7/22/16.
 */
public class MetricToBritishConverter implements MetricUnitConverter {

    private String msTarget;

    private String celsiusTarget;

    private String meterTarget;

    private Double missingValue;

    public MetricToBritishConverter(){
         missingValue = -10000.0;
    }

    public MetricToBritishConverter(double missingVal){
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
        if (celsius == missingValue){
            return celsius;
        }

        if (celsiusTarget.equals("f")){

            return celsius * 1.8 + 32;
        }

        return missingValue;
    }

    @Override
    public double convertMeters(double meter) {
        if (meter == missingValue){
            return meter;
        }

        if (meterTarget.equals("feet")){
            return 3.2808 * meter;
        }

        if (meterTarget.equals("inch")){
            return 39.370 * meter;
        }

        return missingValue;

    }

    @Override
    public double convertMetersPerSec(double ms) {
        if (ms == missingValue){
            return ms;
        }

        if (msTarget.equals("mph")){
            return  ms/0.44704;
        }

        return missingValue;
    }

    @Override
    public String convertCelsiusUnit() {
        if (celsiusTarget.equals("f")){
            return "°F";
        }
        return "";
    }

    @Override
    public String convertMeterPerSecUnit() {
        if (msTarget.equals("mph")){
            return "mph";
        }
        return "";
    }

    @Override
    public String convertMeterUnit() {
        if (meterTarget.equals("feet")){
            return "ft";
        }else if (meterTarget.equals("inch")){
            return "inch";
        }
        return "";
    }
}

