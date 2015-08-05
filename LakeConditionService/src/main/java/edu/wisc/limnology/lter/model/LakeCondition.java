package edu.wisc.limnology.lter.model;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
@XmlRootElement
public class LakeCondition {

	private Date sampleDate;
	private String lakeName;
	private String lakeId;
	private Double airTemp;
	private Double waterTemp;
	private Double windSpeed;
	private Integer windDir;
	private Double secchiEst;
	private Double phycoMedian;
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

	@XmlElement(nillable=true)
	public Double getAirTemp() {
		return airTemp;
	}

	public void setAirTemp(Double airTemp) {
		this.airTemp = airTemp;
	}

	@XmlElement(nillable=true)
	public Double getWaterTemp() {
		return waterTemp;
	}

	public void setWaterTemp(Double waterTemp) {
		this.waterTemp = waterTemp;
	}

	@XmlElement(nillable=true)
	public Double getWindSpeed() {
		return windSpeed;
	}

	public void setWindSpeed(Double windSpeed) {
		this.windSpeed = windSpeed;
	}

	@XmlElement(nillable=true)
	public Integer getWindDir() {
		return windDir;
	}

	public void setWindDir(Integer windDir) {
		this.windDir = windDir;
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