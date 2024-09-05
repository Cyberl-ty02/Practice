package com.tjut.util;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;

public class CommonTools {	
	//获得下拉列表的值
	public static String getComboData(String tablename,String value,String name,String confield,String convalue){
		String result="";
		DBTable dt=null;		
		try{
			String sql="select "+name+","+value+" from "+tablename+" where "+confield+"='"+convalue+"'";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
}
