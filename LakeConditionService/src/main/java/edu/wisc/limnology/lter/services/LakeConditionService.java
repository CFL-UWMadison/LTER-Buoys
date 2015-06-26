package edu.wisc.limnology.lter.services;

import java.util.List;

import edu.wisc.limnology.lter.database.BuoyConditionDAO;
import edu.wisc.limnology.lter.database.BuoyConditionDAOImpl;
import edu.wisc.limnology.lter.model.LakeCondition;

//@Component
public class LakeConditionService {
	
	//@Autowired
	private BuoyConditionDAO buoyConditionsDAO = new BuoyConditionDAOImpl();
	
	public List<LakeCondition> getLakeConditions() {
		return buoyConditionsDAO.getBuoyConditions(); 
	}
	
	public LakeCondition getLakeCondition(String lakeId) {
		return buoyConditionsDAO.getBuoyCondition(lakeId); 
	}
}
