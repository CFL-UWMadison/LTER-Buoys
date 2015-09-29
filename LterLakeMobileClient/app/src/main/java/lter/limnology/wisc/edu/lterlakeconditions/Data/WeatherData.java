package lter.limnology.wisc.edu.lterlakeconditions.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * "airTemp":0.0,"lakeId":"ME","lakeName":"Lake Mendota","phycoMedian":868.0,"sampleDate":"2015-07-23T00:00:00",
 * "secchiEst":1.53,"waterTemp":0.0,"windDir":0,"windSpeed":0.0}
 */
public class WeatherData implements Serializable {

    private String lakeName;
    private String lakeId;
    private Double airTemp;
    private Double waterTemp;
    private Double windSpeed;
    private Integer windDir;
    private Double secchiEst;
    private Double phycoMedian;
    private Double thermoclineDepth;
    public String sampleDate;

    public WeatherData(String sampleDate,
                       String lakeName,
                       String lakeId,
                       Double airTemp,
                       Double waterTemp,
                       Double windSpeed,
                       Integer windDir,
                       Double secchiEst,
                       Double phycoMedian,
                       Double thermoclineDepth) {
        this.lakeName = lakeName;
        this.lakeId = lakeId;
        this.airTemp = airTemp;
        this.waterTemp = waterTemp;
        this.windSpeed = windSpeed;
        this.windDir = windDir;
        this.secchiEst = secchiEst;
        this.phycoMedian = phycoMedian;
        this.thermoclineDepth = thermoclineDepth;
        this.sampleDate = sampleDate;
        // this.sampleTime = sampleTime;
    }

    public String getSampleDate() {
        return sampleDate;
    }

    public void setSampleDate(String sampleDate) {
        this.sampleDate = sampleDate;
    }

    public String getLakeName() {
        return lakeName;
    }

    public void setLakeName(String lakeName) {
        this.lakeName = lakeName;
    }

    public String getLakeId() {
        return lakeId;
    }

    public void setLakeId(String lakeId) {
        this.lakeId = lakeId;
    }

    public Double getAirTemp() {
        return airTemp;
    }

    public void setAirTemp(Double airTemp) {
        this.airTemp = airTemp;
    }

    public Double getWaterTemp() {
        return waterTemp;
    }

    public void setWaterTemp(Double waterTemp) {
        this.waterTemp = waterTemp;
    }

    public Double getWindSpeed() {
        return windSpeed;
    }

    public void setWindSpeed(Double windSpeed) {
        this.windSpeed = windSpeed;
    }

    public Integer getWindDir() {
        return windDir;
    }

    public void setWindDir(Integer windDir) {
        this.windDir = windDir;
    }

    public Double getThermoclineDepth() {
        return thermoclineDepth;
    }

    public void setThermoclineDepth(Double thermoclineDepth) {
        this.thermoclineDepth = thermoclineDepth;
    }

    public Double getSecchiEst() {
        return secchiEst;
    }

    public void setSecchiEst(Double secchiEst) {
        this.secchiEst = secchiEst;
    }

    public Double getPhycoMedian() {
        return phycoMedian;
    }

    public void setPhycoMedian(Double phycoMedian) {
        this.phycoMedian = phycoMedian;
    }

}


