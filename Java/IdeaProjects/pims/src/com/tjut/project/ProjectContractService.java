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
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Common;
import com.tjut.util.Constant;
import com.tjut.util.FileUtil;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;
@MultipartConfig
@WebServlet("/ProjectContractService")

public class ProjectContractService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public ProjectContractService() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");	
		switch(caozuo){
		//初始化单位信息
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
			//初始化项目信息
		case "initcompleteinfoproject":
			result=getproject();			
			WebUtil.handleResponse(response, result);
			break;
			//初始化版本信息
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
		case "add":			
			addinfo(request,response);
			break;		
		case "del":
			deleteInfo(request,response);			
			break;		
		case "print":
			print(request,response);
			break;
		case "download":
			downloadInfo(request,response);
			break;
		case "initcontractinfo":
			result=getContractLCBInfo(request);
			WebUtil.handleResponse(response, result);
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
	//获得合同中其它信息：里程碑等
	private String getContractLCBInfo(HttpServletRequest request){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql="";
		try{
			String uid=WebUtil.getRequestParam(request, "uid");
			sql="select * from projectcontractlcbinfo where puid='"+uid+"' order by no";			
			dt=DBUtil.getDataSetInfo(sql);			
			int rows=DBUtil.getRowCount(sql);
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
			String uid=Uuid.get();
			String unitid=WebUtil.getRequestParam(request, "unit");
			String projectcode=WebUtil.getRequestParam(request, "project");
			String edition=WebUtil.getRequestParam(request, "edition");
			String createdate=Common.getDate("yyyy-MM-dd");
			String secretlevel=WebUtil.getRequestParam(request, "secretlevel");
			//对文件的处理
			//String path=getServletContext().getRealPath("");
			String path=Common.getFilePath();
			String pathfile=path+File.separator+"uploadfiles";
			String absolutepath=pathfile;
			File f=new File(absolutepath);
			if(!f.exists())
				f.mkdirs();
			//word文件处理
			Part part=request.getPart("document");
			String uploadfilename=part.getSubmittedFileName();			
			String savewordfilename=uid.concat(uploadfilename.substring(uploadfilename.lastIndexOf('.')));						
			part.write(absolutepath+File.separator+savewordfilename);
			String wordfilename=uploadfilename;
			String wordfilesavepathname=savewordfilename;
			//pdf文件处理
			part=request.getPart("pdfdocument");
			String uploadpdffilename=part.getSubmittedFileName();			
			String savepdffilename=uid.concat("pdf").concat(uploadpdffilename.substring(uploadpdffilename.lastIndexOf('.')));						
			part.write(absolutepath+File.separator+savepdffilename);
			String pdffilename=uploadpdffilename;
			String pdffilesavepathname=savepdffilename;
			
			sql="delete from projectcontract where unitid=? and projectcode=? and edition=?";
			Object[] args0= {unitid,projectcode,edition};
			DBUtil.executeUpdate(sql, args0);
			//合同提取处理
			List<String> list=WordContractUtils.getParagraphData(absolutepath+File.separator+savewordfilename);
			//合同编号
			String contractno=WordContractUtils.getSingleRowStringData(list, "合同编号：");
			//合同中的项目编号
			String contractprojectcode=WordContractUtils.getSingleRowStringData(list, "项目编号：");			
			//合同中的项目名称
			String contractprojectname=WordContractUtils.getSingleRowStringData(list, "项目名称：");			
			//合同中的承研方	名称		
			String contractunitname=WordContractUtils.getSingleRowStringData(list, "承研方：");
			//起止时间
			String beginenddate=WordContractUtils.getSingleRowStringData(list, "起止时间：");
			//承研方信息
			Document document=WordUtils.getDocument(absolutepath+File.separator+savewordfilename);
			String unitinfo=WordUtils.getUnitInfo(document);
			//项目研究总目标
			list=WordUtils.getInfo(document,2);
			String researchtotalaim=WordContractUtils.getStringData(list, "3.1.1 项目研究总目标", "3.1.2 项目研究内容");
		    //项目研究内容
			String researchcontent=WordContractUtils.getStringData(list, "3.1.2 项目研究内容", "3.1.3 项目关键技术");
			//项目关键技术
			String keytechnology=WordContractUtils.getStringData(list, "3.1.3 项目关键技术", "3.1.4 项目技术指标");
			//项目技术指标
			String technologyindex=WordContractUtils.getStringData(list, "3.1.4 项目技术指标", "3.1.5 项目主要成果");
			//里程碑节点信息			
			List<HashMap<String, String>> lcblistinfo=WordContractUtils.getLCBNodeinfo(list);
			//合同价款
			list=WordUtils.getInfo(document,4);
			String price=WordContractUtils.getSingleRowStringData(list,"本项目合同总经费","万元");
			
			sql="insert into projectcontract(uid,unitid,projectcode,createdate,edition,wordfilename,wordfilesavepathname,pdffilename,pdffilesavepathname,secretlevel,"
					+ "contractno,contractprojectcode,contractprojectname,contractunitname,unitinfo,beginenddate,researchtotalaim,researchcontent,keytechnology,technologyindex,price) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			Object args[]= {uid,unitid,projectcode,createdate,edition,wordfilename,wordfilesavepathname,pdffilename,pdffilesavepathname,secretlevel,contractno,contractprojectcode,contractprojectname,contractunitname,unitinfo,beginenddate,researchtotalaim,researchcontent,keytechnology,technologyindex,price};	
			boolean flag=DBUtil.executeUpdate(sql, args);
			if(flag) {
				if(lcblistinfo.size()>0) {
					Object[][] data=new String[lcblistinfo.size()][8];					
					for(int i=0;i<lcblistinfo.size();i++) {
						String uid0=Uuid.get();
						data[i][0]=uid0;
						data[i][1]=uid;
						data[i][2]=lcblistinfo.get(i).get("name");						
						data[i][3]=lcblistinfo.get(i).get("date");
						data[i][4]=lcblistinfo.get(i).get("aim");
						data[i][5]=lcblistinfo.get(i).get("content");
						data[i][6]=lcblistinfo.get(i).get("index");
						data[i][7]=Integer.toString(i+1);
					}
					sql="insert into projectcontractlcbinfo(uid,puid,name,completedate,aim,content,index,no) values(?,?,?,?,?,?,?,?)";
					DBUtil.executeBatch(sql, data);
				}
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
		String sql="";
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			Object[] args= {uid};
			/*
			String sql="select * from projectproposal where uid=?";
			String sourcefile=DBUtil.getFieldInfo(sql, args, "savefilename");			
			//String path=getServletContext().getRealPath("");
			//2023-04-13修改，根目录改成配置的路径
			String path=Common.getFilePath();
			String soucepdffile=sourcefile.substring(0, sourcefile.lastIndexOf("."))+".pdf";
			File file=new File(path+File.separator+sourcefile);
			if(file.exists()) {
				file.delete();
			}
			file=new File(path+File.separator+soucepdffile);
			if(file.exists()) {
				file.delete();
			}*/
			sql="delete from projectcontract where uid=?";
			DBUtil.executeUpdate(sql,args);
			sql="delete from projectcontractlcbinfo where puid=?";
			DBUtil.executeUpdate(sql,args);
					
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}	
	
	//输出承研单位项目建议书信息
	public String print(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		String sql="";
		String sql0="";
		DBTable dt=null;
		String projectcode,projectname,unitid,unitname;
		try{
			String con=WebUtil.getRequestParam(request,"con");
			if(con.equals(""))
				sql0="select * from projectcontract order by unitid,projectcode";
			else
				sql0="select * from projectcontract where "+con+" order by unitid,projectcode";	
			dt=DBUtil.getDataSetInfo(sql0);
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
			
			String path =request.getServletContext().getRealPath("")+ "/template/projectunitcontract.xls";
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
				cell.setCellValue((i+1));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(1);
				cell.setCellValue(dt.get(i).get("contractno"));		
				cell.setCellStyle(columnOne);	
				cell = row.createCell(2);
				cell.setCellValue(dt.get(i).get("contractprojectcode"));		
				cell.setCellStyle(columnOne);
				cell = row.createCell(3);
				cell.setCellValue(dt.get(i).get("contractprojectname"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(4);
				cell.setCellValue(dt.get(i).get("contractunitname"));		
				cell.setCellStyle(columnOne);
				cell = row.createCell(5);
				cell.setCellValue(dt.get(i).get("beginenddate"));		
				cell.setCellStyle(columntwo);
				
				cell = row.createCell(6);
				cell.setCellValue(dt.get(i).get("researchtotalaim"));		
				cell.setCellStyle(columntwo);
				
				cell = row.createCell(7);
				cell.setCellValue(dt.get(i).get("researchcontent"));			
				cell.setCellStyle(columntwo);					
				
				cell = row.createCell(8);
				cell.setCellValue(dt.get(i).get("technologyindex"));		
				cell.setCellStyle(columntwo);	
				
				cell = row.createCell(9);
				cell.setCellValue(dt.get(i).get("keytechnology"));		
				cell.setCellStyle(columntwo);
				
				cell = row.createCell(10);
				cell.setCellValue(dt.get(i).get("price"));		
				cell.setCellStyle(columntwo);
				
			}
			File f1=new File("");			
			if(f1.exists()){
			   f1.delete();
			}  
			response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode("项目合同信息.xls","UTF-8"));
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
			sql="select * from projectcontract where uid=?";
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
				}else if(type.equals("expertopinion")){
					if(dt.get(0).get("expertopinionsavepathfilename")!=null) {
						savedocumentname=dt.get(0).get("expertopinionsavepathfilename");										
						displayfilename=dt.get(0).get("expertopinionfilename");
					}else {
						WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "文件不存在,请和管理员联系！");
						return;
					}
				}else {
					if(dt.get(0).get("expertopinionadoptsavepathfilename")!=null) {
						savedocumentname=dt.get(0).get("expertopinionadoptsavepathfilename");										
						displayfilename=dt.get(0).get("expertopinionadoptfilename");
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
			String sql="select * from projectcontract where projectcode=? and edition=?";
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
