package edu.wisc.limnology.lter.database;

import java.util.List;

import edu.wisc.limnology.lter.model.LakeCondition;

public interface LakeConditionDAO {
	
	public List<LakeCondition> getLakeConditions();
	
	public LakeCondition getLakeCondition(String lakeId);
	
}
