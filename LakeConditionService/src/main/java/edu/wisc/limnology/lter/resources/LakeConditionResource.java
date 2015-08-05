package edu.wisc.limnology.lter.resources;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import edu.wisc.limnology.lter.model.LakeCondition;
import edu.wisc.limnology.lter.services.LakeConditionService;

//@Component
@Path("/lakeConditions")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class LakeConditionResource {
	
	//@Autowired
	private LakeConditionService lakeConditionService = new LakeConditionService();
	
	@GET	
	public List<LakeCondition> getLakeConditions() {
		return lakeConditionService.getLakeConditions(); 
	}
	
	@GET
	@Path("/{lakeId}")
	public LakeCondition getLakeCondition(@PathParam("lakeId") String lakeId) {
		return lakeConditionService.getLakeCondition(lakeId); 
	}
}