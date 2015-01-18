package com.guidentifier.dao;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;
import com.guidentifier.model.FamilyInfo;
import com.guidentifier.model.Form;
import com.guidentifier.model.Region;
import com.guidentifier.model.Species;
import com.guidentifier.model.SpeciesInfo;
import com.guidentifier.model.Type;
import com.guidentifier.model.Family;
import java.util.List;
import java.util.ArrayList;

public class DAO {
	static {
		ObjectifyService.register(Type.class);
		ObjectifyService.register(Family.class);
		ObjectifyService.register(Form.class);
		ObjectifyService.register(Species.class);
		ObjectifyService.register(FamilyInfo.class);
		ObjectifyService.register(SpeciesInfo.class);
		ObjectifyService.register(Region.class);
	}
	
	public List<Type> getTypes() {
		return ofy().load().type(Type.class).list();
	}
	
	public void add(Type t) {
		ofy().save().entity(t).now();
	}
	
	public Type getType(String idStr) {
		try {
			Long id = Long.parseLong(idStr);
			return ofy().load().type(Type.class).id(id).now();
		} catch (NumberFormatException e) {
			return null;
		}
	}
	
	public Type getType(Key<Type> key) {
		return ofy().load().key(key).now();
	}
	
	public Family getFamily(String idStr) {
		try {
			Long id = Long.parseLong(idStr);
			return ofy().load().type(Family.class).id(id).now();
		} catch (NumberFormatException e) {
			return null;
		}
	}
	
	public Iterable<Family> getFamilies(Type t) {
		return ofy().load().type(Family.class).filter("type", t);
	}
	
	public List<Family> getFamiliesList(Type t) {
		return ofy().load().type(Family.class).filter("type", t).list();
	}
	
	public Iterable<Family> getFamilies(Family f) {
		return ofy().load().type(Family.class).filter("parent =", f);
	}
	
	public Family getFamily(Key<Family> key) {
		return ofy().load().key(key).now();
	}
	
	public void add(Family f) {
		ofy().save().entity(f).now();
	}
	
	public Iterable<Form> getForms(Type t) {
		return ofy().load().type(Form.class).filter("type", t);
	}
	
	public void add(Form f) {
		ofy().save().entity(f).now();
	}
	
	public Iterable<Species> getSpecies(Family f) {
		return ofy().load().type(Species.class).filter("family", f);
	}
	
	public Species getSpecies(String idStr) {
		try {
			Long id = Long.parseLong(idStr);
			return ofy().load().type(Species.class).id(id).now();
		} catch (NumberFormatException e) {
			return null;
		}	
	}
	
	public FamilyInfo getFamilyInfo(Family f) {
		return ofy().load().type(FamilyInfo.class).filter("family", f).first().now();
	}
	
	public SpeciesInfo getSpeciesInfo(Species s) {
		return ofy().load().type(SpeciesInfo.class).filter("species", s).first().now();
	}
	
	public void add(Species s) {
		ofy().save().entity(s).now();
	}
	
	public void add(FamilyInfo fi) {
		ofy().save().entity(fi).now();
	}
	
	public void add(SpeciesInfo si) {
		ofy().save().entity(si).now();
	}
	
	public List<Family> getParents(Family f) {
		List<Family> ret = new ArrayList<Family>();
		Family fam = f;
		while (fam.getParent() != null) {
			fam = fam.getParent();
			ret.add(0, fam);
		}
		return ret;
	}
	
	public Region getRegion(String idStr) {
		try {
			Long id = Long.parseLong(idStr);
			return ofy().load().type(Region.class).id(id).now();
		} catch (NumberFormatException e) {
			return null;
		}
	}
	
	public void add(Region r) {
		ofy().save().entity(r).now();
	}
	
	public List<Region> getRegionsList() {
		return ofy().load().type(Region.class).list();
	}
}
