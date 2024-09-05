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
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Common;
import com.tjut.util.Constant;
import com.tjut.util.FileUtil;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;
@MultipartConfig
@WebServlet("/ProjectProposalService")

public class ProjectProposalService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public ProjectProposalService() {
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
		//专家评分表部分
		case "initscoreinfo":
			result=getScoreInfo(request);
			WebUtil.handleResponse(response, result);
			break;
		case "scoreadd":
			addscoreinfo(request,response);
			break;
		case "scoredel":
			delscoreinfo(request,response);
			break;
		case "downloadscore":
			downloadScoreInfo(request,response);
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
				sql0="select * from projectproposal order by unitid,projectcode";
			else
				sql0="select * from projectproposal where "+con+" order by unitid,projectcode";	
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
	
	//添加信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		try{	
			String uid=Uuid.get();
			String prosalname=WebUtil.getRequestParam(request, "prosalname");
			String unitid=WebUtil.getRequestParam(request, "unit");
			String projectcode=WebUtil.getRequestParam(request, "project");
			String edition=WebUtil.getRequestParam(request, "edition");
			String createdate=Common.getDate("yyyy-MM-dd");
			String secretlevel=WebUtil.getRequestParam(request, "secretlevel");
			String reviewdate=WebUtil.getRequestParam(request, "reviewdate");
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
			//专家意见文件处理
			String expertopinionfilename="";
			String expertopinionsavepathfilename="";
			part=request.getPart("expertopinion");
			if(part!=null) {
				String uploadexpertopinionfilename=part.getSubmittedFileName();			
				String saveexpertopinionfilename=uid.concat("expertopinion").concat(uploadexpertopinionfilename.substring(uploadexpertopinionfilename.lastIndexOf('.')));						
				part.write(absolutepath+File.separator+saveexpertopinionfilename);
				expertopinionfilename=uploadexpertopinionfilename;
				expertopinionsavepathfilename=saveexpertopinionfilename;
			}
			//专家意见采纳文件处理
			String expertopinionadoptfilename="";
			String expertopinionadoptsavepathfilename="";
			part=request.getPart("expertopinionadopt");
			if(part!=null) {
				String uploadexpertopinionadoptfilename=part.getSubmittedFileName();			
				String saveexpertopinionadoptfilename=uid.concat("expertopinionadopt").concat(uploadexpertopinionadoptfilename.substring(uploadexpertopinionadoptfilename.lastIndexOf('.')));						
				part.write(absolutepath+File.separator+saveexpertopinionadoptfilename);
				expertopinionadoptfilename=uploadexpertopinionadoptfilename;
				expertopinionadoptsavepathfilename=saveexpertopinionadoptfilename;
			}
			sql="delete from projectproposal where unitid=? and projectcode=? and edition=?";
			Object[] args0= {unitid,projectcode,edition};
			DBUtil.executeUpdate(sql, args0);
			
			List<String> list=WordUtils.getParagraphData(absolutepath+File.separator+savewordfilename);
			
			//研究目标
			String researchtarget=WordUtils.getStringData(list, "（一）研究目标", "（二）研究内容");
			//研究内容
			String researchcontent=WordUtils.getStringData(list, "（二）研究内容", "（三）关键技术","0");
			//研究指标
			String technicalindex=WordUtils.getStringData(list, "（四）技术指标", "三、拟采取的研究方法及途径");
			//研究成果
			String projectachievment=WordUtils.getStringData(list, "（二）项目成果", "（三）应用方向");
			//总经费
			String funds=WordUtils.getAfterTextTableCellValue(absolutepath+File.separator+savewordfilename, "项目经费概算分配表", 1);
			
			
			sql="insert into projectproposal(uid,prosalname,unitid,unitname,projectcode,projectname,researchtarget,researchcontent,technicalindex,projectachievment,funds,createdate,edition,wordfilename,wordfilesavepathname,pdffilename,pdffilesavepathname,secretlevel,reviewdate,expertopinionfilename,expertopinionsavepathfilename,expertopinionadoptfilename,expertopinionadoptsavepathfilename) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			Object args[]= {uid,prosalname,unitid,"",projectcode,"",researchtarget,researchcontent,technicalindex,projectachievment,funds,createdate,edition,wordfilename,wordfilesavepathname,pdffilename,pdffilesavepathname,secretlevel,reviewdate,expertopinionfilename,expertopinionsavepathfilename,expertopinionadoptfilename,expertopinionadoptsavepathfilename};	
			boolean flag=DBUtil.executeUpdate(sql, args);
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
			sql="delete from projectproposal where uid=?";
			
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
				sql0="select * from projectproposal order by unitid,projectcode";
			else
				sql0="select * from projectproposal where "+con+" order by unitid,projectcode";	
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
			
			String path =request.getServletContext().getRealPath("")+ "/template/projectunitproposal.xls";
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
				cell.setCellValue(dt.get(i).get("projectcode"));		
				cell.setCellStyle(columnOne);	
				
				cell = row.createCell(2);
				cell.setCellValue(dt.get(i).get("projectname"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(3);
				cell.setCellValue(dt.get(i).get("unitname"));		
				cell.setCellStyle(columnOne);
				
				cell = row.createCell(4);
				cell.setCellValue(dt.get(i).get("researchtarget"));		
				cell.setCellStyle(columntwo);
				
				cell = row.createCell(5);
				cell.setCellValue(dt.get(i).get("researchcontent"));			
				cell.setCellStyle(columntwo);					
				
				cell = row.createCell(6);
				cell.setCellValue(dt.get(i).get("technicalindex"));		
				cell.setCellStyle(columntwo);	
				
				cell = row.createCell(7);
				cell.setCellValue(dt.get(i).get("projectachievment"));		
				cell.setCellStyle(columntwo);	
				
				cell = row.createCell(8);
				cell.setCellValue(dt.get(i).get("funds"));		
				cell.setCellStyle(columnOne);
				
			}
			File f1=new File("");			
			if(f1.exists()){
			   f1.delete();
			}  
			response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode("项目建议书信息.xls","UTF-8"));
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
	
	//专家评分部分开始
	//根据条件获得满足条件信息,带分页信息
	private String getScoreInfo(HttpServletRequest request){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		
		String sql;
		int rows=0;	
		
		try{			
			String puid=request.getParameter("puid");
			sql="select * from projectproposalexpertscore where puid='"+puid+"'";			
			dt=DBUtil.getDataSetInfo(sql);//.getDataSetInfoByCon(sql,r, p);			
			rows=DBUtil.getRowCount(sql);
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	
	//添加专家评分信息操作	
	private void addscoreinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		try{
			String uid=Uuid.get();
			String puid=WebUtil.getRequestParam(request, "puid");			
			String expertname=WebUtil.getRequestParam(request, "expertname");
			String score=WebUtil.getRequestParam(request, "score");	
			String createdate=Common.getDate("yyyy-MM-dd");
			//对文件的处理
			//String path=getServletContext().getRealPath("");
			String path=Common.getFilePath();
			String pathfile=path+File.separator+"uploadfiles"+File.separator+"scores";
			String absolutepath=pathfile;
			File f=new File(absolutepath);
			if(!f.exists())
				f.mkdirs();
			//评分表文件处理
			Part part=request.getPart("scoredocument");
			String uploadfilename=part.getSubmittedFileName();			
			String savewordfilename=uid.concat(uploadfilename.substring(uploadfilename.lastIndexOf('.')));						
			part.write(absolutepath+File.separator+savewordfilename);
			String expertscorefilename=uploadfilename;
			String expertscoresavepathfilename=savewordfilename;
			
			sql="insert into projectproposalexpertscore(uid,puid,expertname,score,expertscorefilename,expertscoresavepathfilename,createdate) values(?,?,?,?,?,?,?)";
			Object args[]= {uid,puid,expertname,score,expertscorefilename,expertscoresavepathfilename,createdate};	
			boolean flag=DBUtil.executeUpdate(sql, args);
			if(flag) {	
				//计算平均值
				handlescore(puid);
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
	//处理专家评分：生成平均值
	private void handlescore(String puid) {
		String sql="";
		try {
			sql="select avg(score) as avgscore from projectproposalexpertscore where puid='"+puid+"'";
			String score=DBUtil.getFieldInfo(sql, "avgscore");
			score=score.substring(0, score.indexOf("."));
			int avgscore=Integer.parseInt(score);
			sql="update projectproposal set score='"+avgscore+"' where uid='"+puid+"'";
			DBUtil.executeUpdate(sql);
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	
	//删除信息操作
	private void delscoreinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			Object[] args= {uid};
			sql="select * from projectproposalexpertscore where uid=?";
			String sourcefile=DBUtil.getFieldInfo(sql, args, "expertscoresavepathfilename");
			String puid=DBUtil.getFieldInfo(sql, args, "puid");
			sql="delete from projectproposalexpertscore where uid=?";			
			boolean flag=DBUtil.executeUpdate(sql,args);
			if(flag) {
				handlescore(puid);
				//String path=getServletContext().getRealPath("");
				//2023-04-13修改，根目录改成配置的路径
				String path=Common.getFilePath();
				String pathfile=path+File.separator+"uploadfiles"+File.separator+"scores";				
				File file=new File(pathfile+File.separator+sourcefile);
				if(file.exists()) {
					file.delete();
				}				
			}
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}	
	//下载文件操作
	private void downloadScoreInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		DBTable dt=null;
		String url;
		String displayfilename;		
		String savedocumentname="";
		
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			sql="select * from projectproposalexpertscore where uid=?";
			Object[] args= {uid};
			dt=DBUtil.executeQuery(sql, args);
			if(dt.size()>0) {				
				//2023-04-13修改，根目录改成配置的路径
				String serverroot=Common.getFilePath()+File.separator+"uploadfiles"+File.separator+"scores";				
				if(dt.get(0).get("expertscoresavepathfilename")!=null) {
					savedocumentname=dt.get(0).get("expertscoresavepathfilename");										
					displayfilename=dt.get(0).get("expertscorefilename");
				}else {
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "文件不存在,请和管理员联系！");
					return;
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
}
