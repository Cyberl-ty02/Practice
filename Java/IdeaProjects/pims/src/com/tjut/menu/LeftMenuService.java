package com.tjut.menu;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.menu.Menu;
import com.tjut.menu.MenuTree;
import com.tjut.util.WebUtil;

@WebServlet("/LeftMenuService")
public class LeftMenuService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private ArrayList<String> listtemp=null; 
    public LeftMenuService() {
        super();       
    }
    //处理post请求
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
		String caozuo=WebUtil.getRequestParam(request, "caozuo");
		String username=request.getParameter("username");
		switch (caozuo) {
		//获取子菜单信息
		case "getchildinfo":
			String menuid=WebUtil.getRequestParam(request, "menuid");
			out.print(getChildInfo(username,menuid));
			out.flush();
			out.close();
			break;
		//刷新审核信息
		case "auditrefresh":
			String temp0=WebUtil.getRequestParam(request, "menuname");
			String data=getPanelTitle(username,temp0);
			out.print(data);
			out.flush();
			out.close();
			break;
		//设置当前模块名
		case "setMName":
			setMNameSession(request);
			break;
		default:
			String temp=getUserLeftInfo(username);
			//session.setAttribute("session_moudleurl", listtemp);
			
			out.print(temp);
			out.flush();
			out.close();
			break;
		}		
	}
	//处理get请求
	private void setMNameSession(HttpServletRequest request) throws UnsupportedEncodingException {
		String mname=WebUtil.getRequestParam(request, "mname");
		HttpSession session=request.getSession();
		session.setAttribute("mname", mname);
	}
	//获得当前模块名
	private String getPanelTitle(String username,String menuname0) {
		HashMap<String, String> map=new HashMap<String, String>();
		String menuname="";
		String code="";
		if(menuname0.indexOf('(')>0)
		    menuname=menuname0.substring(0, menuname0.indexOf('('));
		else 
			menuname=menuname0;
		
		int auditcount=getAuditCount(username);
	    if(auditcount>0)
	    	 menuname=menuname+"("+auditcount+")";
	    if(menuname.equals(menuname0)) {
	    	code="0";
	    }else {
	    	code="1";
	    }
	    map.put("code", code);
	    map.put("menuname", menuname);
	    
	    return JSON.toJSONString(map);
	    
	}
	private String getChildInfo(String username,String rootid) {
		String ret="";
		DBTable table=null;
		Menu menu=null;
		Map<String,Object> result=new HashMap<String,Object>();
		List<Menu> menuList= new ArrayList<Menu>();
		String menuid;
		String menuname;
		String icon;
		String url;
		String pid;
		int count=0;
		try{
			listtemp=new ArrayList<String>();
			String sql="select mno as menuid,mname as menuname,image as icon,url,pmno as pid  from vwuserrole where mno like '"+rootid.substring(0,2)+"%' and pid<>'' and username='"+username+"' order by mno";
			DBTable dt=DBUtil.getDataSetInfo(sql);
			if(dt.size()>0){
			   for(int i=0;i<dt.size();i++){
				   menuid=dt.get(i).get("menuid").toString();
				   menuname=dt.get(i).get("menuname").toString();
				   //*******  提示有审核信息
				   if(!getTablename(menuname).equals("")) {
					   count=getAuditCount(getTablename(menuname), username);
					   if(count>0) {
						   menuname=menuname+"("+count+")";
					   }
				   }
				   icon=dt.get(i).get("icon")==null?"":dt.get(i).get("icon").toString();
				   url=dt.get(i).get("url")==null?"":dt.get(i).get("url").toString();
				   pid=dt.get(i).get("pid")==null?"":dt.get(i).get("pid").toString();
				   if(url.equals(""))
					   menu=new Menu(menuid, pid, menuname, url, icon,"closed");
				   else {
					   menu=new Menu(menuid, pid, menuname, url, icon);
				   }
				
				   menuList.add(menu);
				   if(!url.equals(""))
					   listtemp.add(url);
			   }
			   MenuTree menuTree =new MenuTree(menuList);
		       menuList=menuTree.builTree(rootid);
		       ret= JSON.toJSONString(menuList);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
	}
	private String getUserLeftInfo(String username){
		String ret="";
		DBTable table=null;
		Menu menu=null;
		Map<String,Object> result=new HashMap<String,Object>();
		List<Menu> menuList= new ArrayList<Menu>();
		String menuid;
		String menuname;
		String icon;
		String url;
		String pid;
		int auditcount=0;
		
		try{
			listtemp=new ArrayList<String>();
			String sql="select mno as menuid,mname as menuname,image as icon,url,pmno as pid  from vwuserrole where pmno='' and username='"+username+"' order by mno";
			DBTable dt=DBUtil.getDataSetInfo(sql);
			if(dt.size()>0){
			   for(int i=0;i<dt.size();i++){
				   menuid=dt.get(i).get("menuid").toString();				   
				   menuname=dt.get(i).get("menuname").toString();
				   if(menuname.equals("信息审核")){
				      auditcount=getAuditCount(username);
				      if(auditcount>0)
				    	  menuname=menuname+"("+auditcount+")";
				   }				   
				   icon=dt.get(i).get("icon")==null?"":dt.get(i).get("icon").toString();
				   url=dt.get(i).get("url")==null?"":dt.get(i).get("url").toString();
				   pid=dt.get(i).get("pid")==null?"":dt.get(i).get("pid").toString();
				   menu=new Menu(menuid, pid, menuname, url, icon);
				   menuList.add(menu);
				   if(!url.equals(""))
					   listtemp.add(url);
			   }
			   //MenuTree menuTree =new MenuTree(menuList);
		       //menuList=menuTree.builTree();
		       result.put("menus", menuList);
		       ret= JSON.toJSONString(result);
		       //System.out.println(ret);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
		/*
		String ret="";
		Map<String,Object> map=null;
		Map<String,Object> result=new HashMap<String,Object>();
		List<Object> list=new ArrayList<Object>();
		String temp;
		DBTable table=null;
		try{
			listtemp=new ArrayList<String>();
			String sql="select mno as menuid,mname as menuname,image as icon,url  from vwuserrole where pmno='' and username='"+username+"' order by mno";
			DBTable dt=DBUtil.getDataSetInfo(sql);
			if(dt.size()>0){
			   for(int i=0;i<dt.size();i++){					
					temp=dt.get(i).get("menuid").trim();					
					sql="select mno as menuid,pmno as pid,mname as menuname,image as icon,url from vwuserrole where pmno='"+temp+"' and username='"+username+"' order by mno";
					table=DBUtil.getDataSetInfo(sql);
					
					map=new HashMap<String,Object>();					
					map.put("menuname", dt.get(i).get("menuname").trim());
					map.put("icon", dt.get(i).get("icon"));
					map.put("menuid", dt.get(i).get("menuid").trim());
					map.put("menus", table);
				    list.add(map);
				    
				    for(int k=0;k<table.size();k++){				    	
				       listtemp.add(table.get(k).get("url").trim());
				    }
				}	
				result.put("menus", list);				
				ret=JSON.toJSONString(result);
				System.out.println(ret);
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return ret;*/
	}
    //获得某个审核项某人的审核数
	private int getAuditCount(String tablename,String username) {
		int count=0;
		try {			
			String sql="select * from "+tablename+" where state='01' and setauditor like '%"+username+"%'";
			count=DBUtil.getRowCount(sql);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	//获得某个用户的总数
	private int getAuditCount(String username) {
		int count=0;
		String tablename[]= {"actionitem","finaldocument","materialslibrary","projectcontract","ordertask"};
		try {
			for(int i=0;i<tablename.length;i++) {
				count=count+getAuditCount(tablename[i],username);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	//根据菜单名返回对应的表名
	private String getTablename(String menuname) {
		String tablename="";
		if(menuname.equals("行动项审核")) {
			tablename="actionitem";
		}else if(menuname.equals("素材库审核")) {
			tablename="materialslibrary";
		}else if(menuname.equals("文档审核")) {
			tablename="finaldocument";
		}else if(menuname.equals("项目合同信息审核")) {
			tablename="projectcontract";
		}else if(menuname.equals("任务单审核")) {
			tablename="ordertask";
		}
		return tablename;
	}
}
