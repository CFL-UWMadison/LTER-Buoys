package edu.wisc.limnology.lter.services;

import java.util.List;

import edu.wisc.limnology.lter.database.LakeConditionDAO;
import edu.wisc.limnology.lter.database.LakeConditionDAOImpl;
import edu.wisc.limnology.lter.model.LakeCondition;

//@Component
public class LakeConditionService {
	
	//@Autowired
	private LakeConditionDAO buoyConditionsDAO = new LakeConditionDAOImpl();
	
	public List<LakeCondition> getLakeConditions() {
		return buoyConditionsDAO.getLakeConditions(); 
	}
	
	public LakeCondition getLakeCondition(String lakeId) {
		return buoyConditionsDAO.getLakeCondition(lakeId); 
	}
}
