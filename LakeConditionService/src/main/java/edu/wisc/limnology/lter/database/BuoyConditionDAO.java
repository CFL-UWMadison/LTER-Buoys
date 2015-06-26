package edu.wisc.limnology.lter.database;

import java.util.List;

import edu.wisc.limnology.lter.model.LakeCondition;

public interface BuoyConditionDAO {
	
	public List<LakeCondition> getBuoyConditions();
	
	public LakeCondition getBuoyCondition(String lakeId);
	
}
