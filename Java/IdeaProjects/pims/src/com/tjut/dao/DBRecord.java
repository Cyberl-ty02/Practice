package com.tjut.dao;

import java.io.Serializable;
import java.util.HashMap;

public class DBRecord extends HashMap<String,String> implements Serializable {

	private static final long serialVersionUID = 1L;
	public DBRecord(){
		super();
	}
}
