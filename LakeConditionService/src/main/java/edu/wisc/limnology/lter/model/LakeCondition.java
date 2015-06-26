package edu.wisc.limnology.lter.model;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

public class LakeCondition {

	private Date sampleDate;
	private String lakeName;
	private String lakeId;
	private Double airTemp;
	private Double waterTemp;
	private Double windSpeed;
	private Integer windDir;
	private Date sampleTime;

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	public String getFormatedSampleDate() {
		return sampleDate != null ? dateFormat.format(sampleDate) : "";
	}
	
	public Date getSampleDate() {
		return sampleDate;
	}

	public void setSampleDate(Date sampleDate) {
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

	public Date getSampleTime() {
		return sampleTime;
	}

	public void setSampleTime(Date sampleTime) {
		this.sampleTime = sampleTime;
	}

	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}
