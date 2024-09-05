package com.tjut.util;

import java.util.UUID;

public class Uuid {
	public static String get(){
		return UUID.randomUUID().toString().replace("-", "");
	}
}