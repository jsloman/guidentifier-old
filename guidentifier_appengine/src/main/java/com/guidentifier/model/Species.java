package com.guidentifier.model;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.Ref;

@Entity
public class Species {
	@Id Long id;
	String name;
	@Index @Load Ref<Type> type;
	@Index @Load Ref<Family> family;
	
	
	private Species() {
	}
	
	public Species(Family f, String name) {
		family = Ref.create(f);;
		type = Ref.create(f.getType());
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
	
	public Type getType() {
		return type.get();
	}

	public void setType(Type type) {
		this.type = Ref.create(type);
	}

	public Family getFamily() {
		return family.get();
	}

	public void setFamily(Family family) {
		this.family = Ref.create(family);
	}
}
