package com.tjut.system;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/SystemManageService")
public class SystemManageService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private ArrayList<String> listtemp=null; 
    public SystemManageService() {
        super();       
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
		
		String username=request.getParameter("username");		
		String temp=getUserLeftInfo(username);
		session.setAttribute("session_moudleurl", listtemp);
		
		out.print(temp);
		out.flush();
		out.close();
	}
	//获取用户左侧菜单
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
		try{
			listtemp=new ArrayList<String>();
			String sql="select mno as menuid,mname as menuname,image as icon,url,pmno as pid  from vwuserrole where username='"+username+"' order by mno";
			DBTable dt=DBUtil.getDataSetInfo(sql);
			if(dt.size()>0){
			   for(int i=0;i<dt.size();i++){
				   menuid=dt.get(i).get("menuid").toString();
				   menuname=dt.get(i).get("menuname").toString();
				   icon=dt.get(i).get("icon")==null?"":dt.get(i).get("icon").toString();
				   url=dt.get(i).get("url")==null?"":dt.get(i).get("url").toString();
				   pid=dt.get(i).get("pid")==null?"":dt.get(i).get("pid").toString();
				   menu=new Menu(menuid, pid, menuname, url, icon);
				   menuList.add(menu);
				   if(!url.equals(""))
					   listtemp.add(url);
			   }
			   MenuTree menuTree =new MenuTree(menuList);
		       //menuList=menuTree.builTree();
		       result.put("menus", menuList);
		       ret= JSON.toJSONString(result);
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

}
