package com.guidentifier.model;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.Ref;

@Entity
public class SpeciesInfo {
	@Id Long id;
	String description;
	String image;
	String wikipediaURL;
	
	@Index @Load Ref<Species> species;
	
	
	private SpeciesInfo() {
	}
	
	public SpeciesInfo(Species s) {
		species = Ref.create(s);
		id = null;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Species getSpecies() {
		return species.get();
	}

	public void setSpecies(Species species) {
		this.species = Ref.create(species);
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getWikipediaURL() {
		return wikipediaURL;
	}

	public void setWikipediaURL(String wikipediaURL) {
		this.wikipediaURL = wikipediaURL;
	}
}
