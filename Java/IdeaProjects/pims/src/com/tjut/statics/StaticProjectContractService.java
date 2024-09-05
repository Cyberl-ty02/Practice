package com.tjut.statics;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Common;
import com.tjut.util.Constant;
import com.tjut.util.FileUtil;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;
@MultipartConfig
@WebServlet("/StaticProjectContractService")

public class StaticProjectContractService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public StaticProjectContractService() {
        super();
    }
    //初始化
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");	
		switch(caozuo){
		case "initunit":
			result=getunit(request);			
			WebUtil.handleResponse(response, result);
			break;
		//初始化文档密级
		case "initcombobox":
			String code=WebUtil.getRequestParam(request, "code");
			result=WebUtil.getComboData("basedata", "name", "name", "code",code);			
			WebUtil.handleResponse(response, result);
			break;
		case "initproject":
			result=getproject(request);			
			WebUtil.handleResponse(response, result);
			break;
		case "initcompleteinfoproject":
			result=getproject();			
			WebUtil.handleResponse(response, result);
			break;
		case "initedition":
			result=WebUtil.getComboData("basedata", "name","name","code", "002");
			WebUtil.handleResponse(response, result);
			break;
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getInfo(request,con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "initcomplete":
			String con0=WebUtil.getRequestParam(request,"con");
			String row0=WebUtil.getRequestParam(request,"rows");
			String page0=WebUtil.getRequestParam(request,"page");
			result=getCompleteInfo(request,con0,page0,row0);
			WebUtil.handleResponse(response, result);
			break;
		
		case "download":
			downloadInfo(request,response);
			break;
		}		
	}
	//获得单位信息
	private String getunit(HttpServletRequest request){
		String result="";
		DBTable dt=null;
		String sql;
		try{
			String rolename=request.getSession().getAttribute("rolename").toString();
			String unitid=request.getSession().getAttribute("unitid").toString();
			if(rolename.equals("unit")) {
				sql="select code as unitid,name as unitname from unit where code='"+unitid+"' order by code";
			}else {
			    sql="select code as unitid,name as unitname from unit order by code";
			}
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//获得项目信息
	private String getproject(){
		String result="";
		DBTable dt=null;
		String sql;
		try{
			sql="select code as projectcode,name as projectname from projectguide where length(code)=11 order by code";
			
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//获得项目信息
	private String getproject(HttpServletRequest request){
		String result="";
		DBTable dt=null;
		String sql;
		try{
			String unitid=WebUtil.getRequestParam(request, "unitid");
			String unitname=DBUtil.getFieldInfo("select name as unitname from unit where code='"+unitid+"'", "unitname");
			if(unitid.equals(""))
			   sql="select code as projectcode,name as projectname from projectguide where length(code)=11 order by code";
			else
			   sql="select code as projectcode,name as projectname from projectguide where length(code)=11 and unit like '%"+unitname+"%' order by code";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件信息,带分页信息
	private String getInfo(HttpServletRequest request,String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		
		String sql0,sql;
		int rows=0;	
		String projectcode,projectname;		
		String unitid,unitname;
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			
			if(con.equals(""))
				sql0="select * from projectcontract order by unitid,projectcode";
			else
				sql0="select * from projectcontract where "+con+" order by unitid,projectcode";	
			dt=DBUtil.getDataSetInfoByCon(sql0,r, p);
			for(int i=0;i<dt.size();i++) {
				projectcode=dt.get(i).get("projectcode").toString();				
				sql="select name from projectguide where code='"+projectcode+"'";
				projectname=DBUtil.getFieldInfo(sql, "name");
				unitid=dt.get(i).get("unitid").toString();	
				sql="select name from unit where code='"+unitid+"'";
				unitname=DBUtil.getFieldInfo(sql, "name");
				dt.get(i).put("projectname", projectname);
				dt.get(i).put("unitname", unitname);				
			}
			rows=DBUtil.getRowCount(sql0);
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	
	//下载文件操作
	private void downloadInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		DBTable dt=null;
		String url;
		String displayfilename;		
		String savedocumentname="";
		
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			String type=WebUtil.getRequestParam(request, "type");
			sql="select * from projectproposal where uid=?";
			Object[] args= {uid};
			dt=DBUtil.executeQuery(sql, args);
			if(dt.size()>0) {				
				//2023-04-13修改，根目录改成配置的路径
				String serverroot=Common.getFilePath()+File.separator+"uploadfiles";				
				if(type.equals("word")) {
					if(dt.get(0).get("wordfilesavepathname")!=null) {
						savedocumentname=dt.get(0).get("wordfilesavepathname");									
						displayfilename=dt.get(0).get("wordfilename");
					}else {
						WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "文件不存在,请和管理员联系！");
						return;
					}
				}else if(type.equals("pdf")) {
					if(dt.get(0).get("pdffilesavepathname")!=null) {
						savedocumentname=dt.get(0).get("pdffilesavepathname");										
						displayfilename=dt.get(0).get("pdffilename");
					}else {
						WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "文件不存在,请和管理员联系！");
						return;
					}
				}else {
					if(dt.get(0).get("expertopinionsavepathfilename")!=null) {
						savedocumentname=dt.get(0).get("expertopinionsavepathfilename");										
						displayfilename=dt.get(0).get("expertopinionfilename");
					}else {
						WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "文件不存在,请和管理员联系！");
						return;
					}
				}
				url=serverroot+File.separator+savedocumentname;
				//解密文档过程
				
				//解密后的文件路径及文件名	
				/*
				String enfile=url.substring(0, url.lastIndexOf(File.separator)+1)+"entemp"+url.substring(url.lastIndexOf(File.separator)+1);					
				File src=new File(url);
				File dest=new File(enfile);
				FileUtil.cryptoFile(src, dest);   //解密文件，明文文件路径及文件名enfile
				*/
				FileUtil fileUtil=new FileUtil();
				fileUtil.downloadsinglefile(response,displayfilename,url);//未动
				//dest.delete();//删除解密后的明文文件
				
			}else {
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "操作失败，请与系统管理员联系!");
				return;
			}
		}catch (Exception e) {
			e.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系!");
		}
	}
	//根据条件获得满足条件信息,带分页信息
	private String getCompleteInfo(HttpServletRequest request,String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String unit,sql;
		int rows=0;	
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			
			String edition=WebUtil.getRequestParam(request, "edition");
			
			if(con.equals(""))
				sql="select * from projectguide where length(code)=11 order by year,code";
			else
				sql="select * from projectguide where length(code)=11 and "+con+" order by year,code";			
			dt=DBUtil.getDataSetInfoByCon(sql,r, p);
			for(int i=0;i<dt.size();i++) {
				unit=dt.get(i).get("unit").toString();
				String data[]=getCompeteInfo(edition,dt.get(i).get("code"),unit);
				dt.get(i).put("completeunit", data[0]);
				dt.get(i).put("nocompleteunit", data[1]);
				dt.get(i).put("edition", edition);
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
	
	private String[] getCompeteInfo(String edition,String projectcode,String unit) {
		String[] data=new String[2];
		String completeunit="";
		String nocompleteunit="";
		String unitname="";
		try {
			//获得已经完成的单位
			String sql="select * from projectproposal where projectcode=? and edition=?";
			Object[] args= {projectcode,edition};
			DBTable dt=DBUtil.executeQuery(sql, args);
			if(dt.size()>0) {
				for(int i=0;i<dt.size();i++) {
					sql="select name as unitname from unit where code='"+dt.get(i).get("unitid")+"'";
					unitname=DBUtil.getFieldInfo(sql, "unitname");
					if(completeunit.equals("")) {
						completeunit=unitname;
					}else {
						completeunit=completeunit+","+unitname;
					}
					unit=unit.replace(unitname+",", "").replace(unitname+"，", "").replace(unitname, "");
				}
				nocompleteunit=unit;
			}else {
				completeunit="";
				nocompleteunit=unit;
			}
			data[0]=completeunit;
			data[1]=nocompleteunit;
		}catch (Exception e) {
			e.printStackTrace();
		}
		return data;
	}
}
