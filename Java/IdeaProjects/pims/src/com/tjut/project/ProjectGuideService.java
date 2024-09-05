package com.tjut.project;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Common;
import com.tjut.util.Constant;
import com.tjut.util.FileUtil;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;
@MultipartConfig
@WebServlet("/ProjectGuideService")

public class ProjectGuideService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public ProjectGuideService() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");	
		switch(caozuo){
		
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getInfo(request,con,page,row);
			WebUtil.handleResponse(response, result);
			break;		
		case "add":			
			addinfo(request,response);
			break;		
		case "del":
			deleteInfo(request,response);			
			break;
		case "initunit":
			result=getUnitInfo();			
			WebUtil.handleResponse(response, result);
			break;
		case "print":
			print(request,response);
			break;
		}		
	}
	
	//根据条件获得满足条件信息,带分页信息
	private String getInfo(HttpServletRequest request,String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		
		String sql0,sql;
		int rows=0;	
		String code;
		String firstcode,secondcode;
		String firstname,secondname;
		String thirdcode,thirdname;
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			
			if(con.equals(""))
				sql0="select * from projectguide where length(code)=11 order by year,code";
			else
				sql0="select * from projectguide where length(code)=11 and "+con+" order by year,code";			
			dt=DBUtil.getDataSetInfoByCon(sql0,r, p);
			for(int i=0;i<dt.size();i++) {
				code=dt.get(i).get("code").toString();
				firstcode=code.substring(0,5);
				secondcode=code.substring(0,7);
				thirdcode=code.substring(0,9);
				sql="select name from projectguide where code='"+firstcode+"'";
				firstname=DBUtil.getFieldInfo(sql, "name");
				sql="select name from projectguide where code='"+secondcode+"'";
				secondname=DBUtil.getFieldInfo(sql, "name");
				sql="select name from projectguide where code='"+thirdcode+"'";
				thirdname=DBUtil.getFieldInfo(sql, "name");
				dt.get(i).put("firstcode", firstcode);
				dt.get(i).put("secondcode", secondcode);
				dt.get(i).put("thirdcode", thirdcode);
				dt.get(i).put("firstname", firstname);
				dt.get(i).put("secondname", secondname);
				dt.get(i).put("thirdname", thirdname);
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
	
	//添加信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		try{	
			String uid="";
			String year=WebUtil.getRequestParam(request, "year");
			
			//对文件的处理
			String path=getServletContext().getRealPath("");
			
			String pathfile=path+File.separator+"uploadfiles";
			String absolutepath=pathfile;
			File f=new File(absolutepath);
			if(!f.exists())
				f.mkdirs();
			Part part=request.getPart("document");
			String uploadfilename=part.getSubmittedFileName();
			
			String tempsavefilename="temp"+uid.concat(uploadfilename.substring(uploadfilename.lastIndexOf('.')));
						
			part.write(absolutepath+File.separator+tempsavefilename);
			sql="delete from projectguide where year=?";
			Object[] args0= {year};
			DBUtil.executeUpdate(sql, args0);
			Object[][] args=WordUtils.getTableData(absolutepath+File.separator+tempsavefilename, year);
			
			sql="insert into projectguide(uid,year,code,name,targetandcontent,maintarget,fund,period,publishmode,unit) values(?,?,?,?,?,?,?,?,?,?)";
				
			boolean flag=DBUtil.executeBatch(sql, args);			
			if(flag) {				
				WebUtil.respondSuccess(response);
				return;
			}else {
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "操作失败，请与系统管理员联系!");
				return;
			}
		}catch (Exception e) {
			e.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系!");
		}
			
	}
   
    //删除信息操作
	private void deleteInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			Object[] args= {uid};
			String sql="delete from projectguide where uid=?";
			DBUtil.executeUpdate(sql,args);			
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
	
	//获得承研单位信息
	private String getUnitInfo(){
		String result="";
		DBTable dt=null;
		
		try{
			String sql="select code,name from unit order by code";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//输出承研单位信息
	public String print(HttpServletRequest request,HttpServletResponse response) throws IOException{
		DBTable data=new DBTable();
		String sql="";
		String sql0="";
		String code,firstcode,secondcode,firstname,secondname;
		DBTable dt=null;
		
		try{
			String con=WebUtil.getRequestParam(request,"con");
			if(con.equals(""))
				sql0="select * from projectguide where length(code)=11 order by year,code";
			else
				sql0="select * from projectguide where length(code)=11 and "+con+" order by year,code";			
			dt=DBUtil.getDataSetInfo(sql0);
			for(int i=0;i<dt.size();i++) {
				code=dt.get(i).get("code").toString();
				firstcode=code.substring(0,5);
				secondcode=code.substring(0,7);
				sql="select name from projectguide where code='"+firstcode+"'";
				firstname=DBUtil.getFieldInfo(sql, "name");
				sql="select name from projectguide where code='"+secondcode+"'";
				secondname=DBUtil.getFieldInfo(sql, "name");
				dt.get(i).put("firstcode", firstcode);
				dt.get(i).put("secondcode", secondcode);
				dt.get(i).put("firstname", firstname);
				dt.get(i).put("secondname", secondname);
			}
			
			String path =request.getServletContext().getRealPath("")+ "/template/projectunitguide.xls";
			InputStream in = new FileInputStream(new File(path));
			HSSFWorkbook work = new HSSFWorkbook(in);
			HSSFSheet sheet = work.getSheetAt(0);         // 得到excel的第0张表
			HSSFRow row = sheet.getRow(0);
			HSSFCell cell = row.getCell(2);
			// 得到数据第1行的第一个单元格的样式  
			HSSFRow rowCellStyle = sheet.getRow(3);
			HSSFCellStyle columnOne = rowCellStyle.getCell(1).getCellStyle();
			short rowheight=20*20;			
			for(int i=0;i<dt.size();i++){
				row=sheet.createRow(i+3);
				//row.setHeight(rowheight);
				
				cell = row.createCell(0);				
				cell.setCellValue((i+1));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(1);
				cell.setCellValue(dt.get(i).get("code"));		
				cell.setCellStyle(columnOne);	
				
				cell = row.createCell(2);
				cell.setCellValue(dt.get(i).get("name"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(3);
				cell.setCellValue(dt.get(i).get("period"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(4);
				cell.setCellValue(dt.get(i).get("fund"));			
				cell.setCellStyle(columnOne);					
				
				cell = row.createCell(5);
				cell.setCellValue(dt.get(i).get("targetandcontent"));		
				cell.setCellStyle(columnOne);	
				
				cell = row.createCell(6);
				cell.setCellValue(dt.get(i).get("maintarget"));
				cell.setCellStyle(columnOne);	
				
				cell = row.createCell(7);
				cell.setCellValue(dt.get(i).get("publishmode"));		
				cell.setCellStyle(columnOne);
				cell = row.createCell(8);
				cell.setCellValue(dt.get(i).get("unit"));		
				cell.setCellStyle(columnOne);
			}
			File f1=new File("");
			if(f1.exists()){
			   f1.delete();
			}  
			response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode("项目指南信息.xls","UTF-8"));
			ServletOutputStream out=response.getOutputStream();			
			work.write(out);
			out.close();
			in.close();
			
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "处理数据出错，请与系统管理员联系");
				
		}
		return null;
	}
	
}
