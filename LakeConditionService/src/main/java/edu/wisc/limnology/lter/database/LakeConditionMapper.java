package edu.wisc.limnology.lter.database;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import edu.wisc.limnology.lter.model.LakeCondition;

public class LakeConditionMapper implements RowMapper<LakeCondition> {
	public LakeCondition mapRow(ResultSet rs, int rowNum) throws SQLException {
		LakeCondition lakeCondition = new LakeCondition();
		lakeCondition.setLakeId(rs.getString("lakeid"));
	      return lakeCondition;
	   }
}


