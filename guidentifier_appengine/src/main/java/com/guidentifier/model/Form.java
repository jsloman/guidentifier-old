package com.guidentifier.model;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.Ref;

@Entity
public class Form {
	@Id Long id;
	String name;
	@Index @Load Ref<Type> type;
	
	private Form() {
	}
	
	public Form(Type t, String name) {
		type = Ref.create(t);
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
}
