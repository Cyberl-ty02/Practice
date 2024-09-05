package com.tjut.dao;

import java.io.Serializable;
import java.util.ArrayList;

public class DBTable extends ArrayList<DBRecord> implements Serializable {

	private static final long serialVersionUID = 1L;
	public DBTable(){
		super();
	}	
}
//ArrayList<HashMap<String,String>> DBTable