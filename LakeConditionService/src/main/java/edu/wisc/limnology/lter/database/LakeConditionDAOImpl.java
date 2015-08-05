package edu.wisc.limnology.lter.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import edu.wisc.limnology.lter.model.LakeCondition;
import edu.wisc.limnology.lter.utils.DbUtil;


//@Component
public class LakeConditionDAOImpl implements LakeConditionDAO {

	// private DataSource dataSource;

	// private JdbcTemplate jdbcTemplate;

	// public void setDataSource(DataSource dataSource){
	// //this.dataSource = dataSource;
	// this.jdbcTemplate = new JdbcTemplate(dataSource);
	// }



	public List<LakeCondition> getLakeConditions() {

		String sql = "select * from buoy_current_conditions";
		List<LakeCondition> lakeConditions = new ArrayList<LakeCondition>();

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DbUtil.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs != null) {

				while (rs.next()) {

					LakeCondition lakeCondition = new LakeCondition();
					lakeCondition.setSampleDate(rs.getDate("sampledate"));
					lakeCondition.setLakeName(rs.getString("lakename"));
					lakeCondition.setLakeId(rs.getString("lakeid"));
					//lakeCondition.setAirTemp((rs.getObject("airtemp")) == null?null:rs.getBigDecimal("airtemp").doubleValue());
					lakeCondition.setAirTemp(rs.getDouble("airtemp"));
					lakeCondition.setWaterTemp(rs.getDouble("watertemp"));
					lakeCondition.setWindSpeed(rs.getDouble("windspeed"));
					lakeCondition.setWindDir(rs.getInt("winddir"));
					lakeCondition.setSecchiEst(rs.getDouble("secchi_est"));
					lakeCondition.setPhycoMedian(rs.getDouble("phyco_median"));
					lakeConditions.add(lakeCondition);
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				System.err.println("ERROR while closing connection.");
			}
		}
		return lakeConditions;
	}

	public LakeCondition getLakeCondition(String lakeId) {
		String sql = "select * from buoy_current_conditions where lakeid = '"+lakeId+"' " ;
		
		LakeCondition lakeCondition = new LakeCondition();

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = DbUtil.getConnection();
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);

			if (rs != null) {
				while (rs.next()) {
					lakeCondition.setSampleDate(rs.getDate("sampledate"));
					lakeCondition.setLakeName(rs.getString("lakename"));
					lakeCondition.setLakeId(rs.getString("lakeid"));
					lakeCondition.setAirTemp(rs.getDouble("airtemp"));
					//lakeCondition.setAirTemp(rs.getObject("airtemp")==null?null:rs.getBigDecimal("airtemp").doubleValue());
					lakeCondition.setWaterTemp(rs.getDouble("watertemp"));
					lakeCondition.setWindSpeed(rs.getDouble("windspeed"));
					lakeCondition.setWindDir(rs.getInt("winddir"));
					lakeCondition.setSecchiEst(rs.getDouble("secchi_est"));
					lakeCondition.setPhycoMedian(rs.getDouble("phyco_median"));
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		} finally {
			try {

				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				System.err.println("ERROR while closing connection.");
			}
		}
		return lakeCondition;
	}
	
}
