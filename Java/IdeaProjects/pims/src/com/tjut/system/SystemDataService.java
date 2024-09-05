package com.tjut.system;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.WebUtil;

@WebServlet("/SystemDataService")
public class SystemDataService extends HttpServlet {
	private static final long serialVersionUID = 1L;     
    public SystemDataService() {
        super();       
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){		
		case "init":			
			String con=WebUtil.getRequestParam(request,"con");
			result=getDataInfo(con);
			WebUtil.handleResponse(response, result);
			break;
		case "delete":
			deleteDataInfo(request,response);			
			break;
		}		
	}
	
	//根据条件获得满足条件部门信息,带分页信息
	private String getDataInfo(String con){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql;
		String sql1;
		int rows=0;
		int count=0;
		try{
			
			if(con.equals(""))
				sql="select name as tablename from sysobjects where type='U' order by name";
			else
				sql="select name as tablename from sysobjects where type='U' order by name";
			dt=DBUtil.getDataSetInfo(sql);			
			for(int i=0;i<dt.size();i++){
				sql1="select * from "+dt.get(i).get("tablename");
				count=DBUtil.getRowCount(sql1);
				dt.get(i).put("count", Integer.toString(count));
			}
			rows=DBUtil.getRowCount(sql);
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	
    //删除信息操作
	private void deleteDataInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String tablename="";
		String sql="";
		ArrayList<String> list=new ArrayList<String>();
		try{
			String data=WebUtil.getRequestParam(request,"data");
			JSONArray jsonarray=JSONArray.parseArray(data);
			int len=jsonarray.size();
			for(int i=0;i<len;i++){
				JSONObject obj=jsonarray.getJSONObject(i);
				tablename=obj.getString("tablename").trim();
				sql="delete from "+tablename;
				list.add(sql);
			}
			DBUtil.executeBatch(list);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
