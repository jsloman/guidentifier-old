package com.guidentifier.model;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.Ref;

@Entity
public class FamilyInfo {
	@Id Long id;
	String description;
	String image;
	String wikipediaURL;
	
	@Index @Load Ref<Family> family;
	
	
	private FamilyInfo() {
	}
	
	public FamilyInfo(Family f) {
		family = Ref.create(f);
		id = null;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Family getFamily() {
		return family.get();
	}

	public void setFamily(Family family) {
		this.family = Ref.create(family);
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
