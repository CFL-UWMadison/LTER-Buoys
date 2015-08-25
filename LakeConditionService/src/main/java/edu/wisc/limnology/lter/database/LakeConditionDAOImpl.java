package edu.wisc.limnology.lter.database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import edu.wisc.limnology.lter.model.LakeCondition;
import edu.wisc.limnology.lter.utils.DbUtil;

public class LakeConditionDAOImpl implements LakeConditionDAO {

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
					lakeCondition.setSampleDate(DbUtil.toDate(rs.getTimestamp("sampledate")));
					lakeCondition.setLakeName(rs.getString("lakename"));
					lakeCondition.setLakeId(rs.getString("lakeid"));
					lakeCondition.setAirTemp(DbUtil.toDouble(rs.getBigDecimal("airtemp")));
					lakeCondition.setWaterTemp(DbUtil.toDouble(rs.getBigDecimal("watertemp")));
					lakeCondition.setWindSpeed(DbUtil.toDouble(rs.getBigDecimal("windspeed")));
					lakeCondition.setWindDir((Integer)rs.getObject("winddir"));
					if ("ME".equals(DbUtil.trim(rs.getString("lakeid")))){
					lakeCondition.setSecchiEst(DbUtil.toDouble(rs.getBigDecimal("secchi_est")));
					lakeCondition.setPhycoMedian(DbUtil.toDouble(rs.getBigDecimal("phyco_median")));
					}
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
					lakeCondition.setSampleDate(DbUtil.toDate(rs.getTimestamp("sampledate")));
					lakeCondition.setLakeName(rs.getString("lakename"));
					lakeCondition.setLakeId(rs.getString("lakeid"));
					lakeCondition.setAirTemp(DbUtil.toDouble(rs.getBigDecimal("airtemp")));
					lakeCondition.setWaterTemp(DbUtil.toDouble(rs.getBigDecimal("watertemp")));
					lakeCondition.setWindSpeed(DbUtil.toDouble(rs.getBigDecimal("windspeed")));
					lakeCondition.setWindDir((Integer)rs.getObject("winddir"));
					if ("ME".equals(DbUtil.trim(rs.getString("lakeid")))){
					lakeCondition.setSecchiEst(DbUtil.toDouble(rs.getBigDecimal("secchi_est")));
					lakeCondition.setPhycoMedian(DbUtil.toDouble(rs.getBigDecimal("phyco_median")));
					}
					
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
