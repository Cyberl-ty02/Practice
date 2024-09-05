package com.tjut.project;

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
import com.spire.doc.Document;
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Common;
import com.tjut.util.Constant;
import com.tjut.util.FileUtil;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;
@MultipartConfig
@WebServlet("/ProjectYearPlanService")

public class ProjectYearPlanService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public ProjectYearPlanService() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");	
		switch(caozuo){
		case "initunit":
			result=getunit(request);			
			WebUtil.handleResponse(response, result);
			break;
		
		case "initproject":
			result=getproject(request);			
			WebUtil.handleResponse(response, result);
			break;
		
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getInfo(request,con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		
		case "print":
			print(request,response);
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
		String year=Common.getDate("yyyy");
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
				sql="select sum(value) as value from projectcontractfundsbofu where contractno='"+dt.get(i).get("contractno")+"' and date<'"+year+"'";
				dt.get(i).put("lastprice", DBUtil.getFieldInfo(sql, "value"));
				sql="select sum(value) as value from projectcontractfundsbofu where contractno='"+dt.get(i).get("contractno")+"' and date>'"+year+"'";
				dt.get(i).put("nowprice", DBUtil.getFieldInfo(sql, "value"));
				
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
	
	
	//输出承研单位项目建议书信息
	public String print(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		String sql="";		
		DBTable dt=null;
		String projectcode,projectname,unitid,unitname;
		try{
			String year=Common.getDate("yyyy");
			String con=WebUtil.getRequestParam(request,"con");
			if(con.equals(""))
				sql="select * from projectcontract order by unitid,projectcode";
			else
				sql="select * from projectcontract where "+con+" order by unitid,projectcode";	
			dt=DBUtil.getDataSetInfo(sql);
			for(int i=0;i<dt.size();i++) {
				projectcode=dt.get(i).get("projectcode").toString();				
				sql="select name from projectguide where code='"+projectcode+"'";
				projectname=DBUtil.getFieldInfo(sql, "name");
				unitid=dt.get(i).get("unitid").toString();	
				sql="select name from unit where code='"+unitid+"'";
				unitname=DBUtil.getFieldInfo(sql, "name");
				dt.get(i).put("projectname", projectname);
				dt.get(i).put("unitname", unitname);
				sql="select sum(value) as value from projectcontractfundsbofu where contractno='"+dt.get(i).get("contractno")+"' and date<'"+year+"'";
				dt.get(i).put("lastprice", DBUtil.getFieldInfo(sql, "value"));
				sql="select sum(value) as value from projectcontractfundsbofu where contractno='"+dt.get(i).get("contractno")+"' and date>'"+year+"'";
				dt.get(i).put("nowprice", DBUtil.getFieldInfo(sql, "value"));
				
			}
			String path =request.getServletContext().getRealPath("")+ "/template/yearplan.xls";
			InputStream in = new FileInputStream(new File(path));
			HSSFWorkbook work = new HSSFWorkbook(in);
			HSSFSheet sheet = work.getSheetAt(0);         // 得到excel的第0张表
			HSSFRow row = sheet.getRow(0);
			HSSFCell cell = row.getCell(2);
			// 得到数据第1行的第一个单元格的样式  
			HSSFRow rowCellStyle = sheet.getRow(3);
			HSSFCellStyle columnOne = rowCellStyle.getCell(1).getCellStyle();
			
			HSSFCellStyle columntwo = rowCellStyle.getCell(5).getCellStyle();	
			for(int i=0;i<dt.size();i++){
				row=sheet.createRow(i+3);
								
				cell = row.createCell(0);				
				cell.setCellValue("");		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(1);
				cell.setCellValue(dt.get(i).get("projectcode"));		
				cell.setCellStyle(columnOne);	
				cell = row.createCell(2);
				cell.setCellValue(dt.get(i).get("projectname"));		
				cell.setCellStyle(columnOne);
				cell = row.createCell(3);
				cell.setCellValue(dt.get(i).get("beginenddate"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(4);
				cell.setCellValue(dt.get(i).get("contractunitname"));		
				cell.setCellStyle(columnOne);
				cell = row.createCell(5);
				cell.setCellValue("研究目标："+dt.get(i).get("researchtotalaim").replaceAll("\\r\\n|\\r|\\n", "")+"\n"+"研究内容："+dt.get(i).get("researchcontent").replaceAll("\\r\\n|\\r|\\n", ""));		
				cell.setCellStyle(columntwo);
				/*
				cell = row.createCell(6);
				cell.setCellValue(dt.get(i).get("researchcontent"));		
				cell.setCellStyle(columntwo);
				*/
				cell = row.createCell(6);
				cell.setCellValue(dt.get(i).get("price"));			
				cell.setCellStyle(columntwo);					
				
				cell = row.createCell(7);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);	
				
				cell = row.createCell(8);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);
				
				cell = row.createCell(9);
				cell.setCellValue(dt.get(i).get("lastprice"));		
				cell.setCellStyle(columntwo);
				cell = row.createCell(10);
				cell.setCellValue(dt.get(i).get("nowprice"));		
				cell.setCellStyle(columntwo);
				cell = row.createCell(11);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);
				cell = row.createCell(12);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);
				cell = row.createCell(13);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);
				cell = row.createCell(14);
				cell.setCellValue("");		
				cell.setCellStyle(columntwo);
				
			}
			File f1=new File("");			
			if(f1.exists()){
			   f1.delete();
			}  
			response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode("年度计划信息.xls","UTF-8"));
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
