package com.guidentifier.model;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.Ref;

@Entity
public class Region {
	@Id Long id;
	String name;
	@Index @Load Ref<Region> parent;
	
	private Region() {
	}
	
	public Region(String name) {
		this.name = name;
		parent = null;
		id = null;
	}
	
	public Region(Region r, String name) {
		parent = Ref.create(r);
		this.name = name;
		id = null;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public Region getParent() {
		return parent == null ? null : parent.get();
	}

	public void setParent(Region parent) {
		this.parent = Ref.create(parent);
	}
}
