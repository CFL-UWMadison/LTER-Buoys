package edu.wisc.limnology.lter.database;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Before;
import org.junit.Test;

import edu.wisc.limnology.lter.model.LakeCondition;

public class BuoyConditionDAOTest {
	
	BuoyConditionDAO buoyConditionDAO;
	
	@Before
	public void init(){
		buoyConditionDAO = new BuoyConditionDAOImpl();
	}
	
	@Test
	public void getBuoyConditions() {
		List<LakeCondition> buoyConditions = buoyConditionDAO.getBuoyConditions();
		assertNotNull(buoyConditions);
		assertEquals(3, buoyConditions.size());
		
		LakeCondition buoyCondition = buoyConditions.get(0);
		assertEquals("2015-05-21 15:19:15", buoyCondition.getFormatedSampleDate());
		assertEquals("Trout Lake", buoyCondition.getLakeName());
		assertEquals("TR",buoyCondition.getLakeId());
		assertTrue(15.00 == buoyCondition.getAirTemp());
		assertTrue(16.10 == buoyCondition.getWaterTemp());
		assertTrue(5.1 == buoyCondition.getWindSpeed());
		assertTrue(180 == buoyCondition.getWindDir());
	}
	
	@Test
	public void getBuoyCondition() {
		LakeCondition buoyCondition = buoyConditionDAO.getBuoyCondition("TR");
		assertEquals("2015-05-21 15:19:15", buoyCondition.getFormatedSampleDate());
		assertEquals("Trout Lake", buoyCondition.getLakeName());
		assertEquals("TR",buoyCondition.getLakeId());
		assertTrue(15.00 == buoyCondition.getAirTemp());
		assertTrue(16.10 == buoyCondition.getWaterTemp());
		assertTrue(5.1 == buoyCondition.getWindSpeed());
		assertTrue(180 == buoyCondition.getWindDir());
	}
}
