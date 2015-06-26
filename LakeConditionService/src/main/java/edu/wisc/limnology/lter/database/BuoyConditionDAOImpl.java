package edu.wisc.limnology.lter.database;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import edu.wisc.limnology.lter.model.LakeCondition;

//@Component
public class BuoyConditionDAOImpl implements BuoyConditionDAO {

	
	//private DataSource dataSource;
	
	//private JdbcTemplate jdbcTemplate;

	
//	public void setDataSource(DataSource dataSource){
//		//this.dataSource = dataSource;
//		this.jdbcTemplate = new JdbcTemplate(dataSource);
//	}
	
	
	public List<LakeCondition> getBuoyConditions() {

	/*	
		String sql = "select * from buoy_current_conditions";
		List<LakeCondition> lakeConditions = jdbcTemplate.query(sql, 
                new Object[]{}, new LakeConditionMapper());
		System.out.println(" lakeConditions from SQL " + lakeConditions);
	*/	
		//return lakeConditions;
		/*
		Connection conn = null;
		try{
			conn = dataSource.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
		} catch (SQLException e) {
			throw new RuntimeException(e);
 
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {}
			}
		}*/
	
		List<LakeCondition> buoyConditions = new ArrayList<LakeCondition>();
		Calendar cal = Calendar.getInstance();

	
		LakeCondition buoyCondition1 = new LakeCondition();
		cal.set(2015, Calendar.MAY, 21, 15, 19, 15);
		buoyCondition1.setSampleDate(cal.getTime());
		buoyCondition1.setLakeName("Trout Lake");
		buoyCondition1.setLakeId("TR");
		buoyCondition1.setAirTemp(15.01);
		buoyCondition1.setWaterTemp(16.10);
		buoyCondition1.setWindSpeed(5.1);
		buoyCondition1.setWindDir(180);
		buoyConditions.add(buoyCondition1);

		LakeCondition buoyCondition2 = new LakeCondition();
		cal.set(2015, Calendar.JUNE, 11, 19, 00, 15);
		buoyCondition2.setSampleDate(cal.getTime());
		buoyCondition2.setLakeName("Lake Mendota");
		buoyCondition2.setLakeId("ME");
		buoyCondition2.setAirTemp(16.18);
		buoyCondition2.setWaterTemp(null);
		buoyCondition2.setWindSpeed(5.6);
		buoyCondition2.setWindDir(113);
		buoyConditions.add(buoyCondition2);

		LakeCondition buoyCondition3 = new LakeCondition();
		cal.set(2015, Calendar.JUNE, 23, 03, 00, 00);
		buoyCondition3.setSampleDate(cal.getTime());
		buoyCondition3.setLakeName("Sparkling Lake");
		buoyCondition3.setLakeId("SP");
		buoyCondition3.setAirTemp(12.90);
		buoyCondition3.setWaterTemp(19.47);
		buoyCondition3.setWindSpeed(2.8);
		buoyCondition3.setWindDir(329);
		buoyConditions.add(buoyCondition3);
		return buoyConditions;
	}

	public LakeCondition getBuoyCondition(String lakeId) {

		Calendar cal = Calendar.getInstance();

		if ("TR".equals(lakeId)) {
			LakeCondition buoyCondition1 = new LakeCondition();
			cal.set(2015, Calendar.MAY, 21, 15, 19, 15);
			buoyCondition1.setSampleDate(cal.getTime());
			buoyCondition1.setLakeName("Trout Lake");
			buoyCondition1.setLakeId("TR");
			buoyCondition1.setAirTemp(15.00);
			buoyCondition1.setWaterTemp(16.10);
			buoyCondition1.setWindSpeed(5.1);
			buoyCondition1.setWindDir(180);
			return buoyCondition1;
		} else if ("ME".equals(lakeId)) {
			LakeCondition buoyCondition2 = new LakeCondition();
			cal.set(2015, Calendar.JUNE, 11, 19, 00, 15);
			buoyCondition2.setSampleDate(cal.getTime());
			buoyCondition2.setLakeName("Lake Mendota");
			buoyCondition2.setLakeId("ME");
			buoyCondition2.setAirTemp(16.18);
			buoyCondition2.setWaterTemp(null);
			buoyCondition2.setWindSpeed(5.6);
			buoyCondition2.setWindDir(113);
			return buoyCondition2;
		} else if ("SP".equals(lakeId)) {
			LakeCondition buoyCondition3 = new LakeCondition();
			cal.set(2015, Calendar.JUNE, 23, 03, 00, 00);
			buoyCondition3.setSampleDate(cal.getTime());
			buoyCondition3.setLakeName("Sparkling Lake");
			buoyCondition3.setLakeId("SP");
			buoyCondition3.setAirTemp(12.90);
			buoyCondition3.setWaterTemp(19.47);
			buoyCondition3.setWindSpeed(2.8);
			buoyCondition3.setWindDir(329);

			return buoyCondition3;
		} else {
			return null;
		}
	}
}
