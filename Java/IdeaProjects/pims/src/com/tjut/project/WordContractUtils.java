package com.tjut.project;


import com.spire.doc.Document;
import com.spire.doc.Section;
import com.spire.doc.Table;
import com.spire.doc.TableCell;
import com.spire.doc.TableRow;
import com.spire.doc.documents.Paragraph;
import com.spire.doc.interfaces.ITable;

import com.tjut.util.Uuid;

import java.util.regex.Pattern;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;

public class WordContractUtils {
	//获得表格数据:uid,year,表中的数据
	public static String[][] getTableData(String file,String year){
		String[][] data=null;
		String cellcontent="";
		String[] temp=null;
		int i=0;
		int n=0;
		Document document=new Document();
		document.loadFromFile(file);
		//获得第一个表格的数据
		Section section=document.getSections().get(0);
		ITable table=section.getTables().get(0);
		data=new String[table.getRows().getCount()-1][10];
		for(int m=1;m<table.getRows().getCount();m++) {
			i=m-1;
			n=0;
			//data=new String[table.getRows().getCount()][11];
			TableRow row=table.getRows().get(m);
			data[i][0]=Uuid.get();
			data[i][1]=year;
			for(int j=0;j<row.getCells().getCount();j++) {
				TableCell cell=row.getCells().get(j);
				cellcontent="";
				for(int k=0;k<cell.getParagraphs().getCount();k++) {
					Paragraph paragraph=cell.getParagraphs().get(k);
					cellcontent=cellcontent+handledata(paragraph.getText().trim());					
				}
				temp=getDigital(cellcontent);
				//判断是否为分类数据
				if(temp[0].length()==1 && j==0)
					continue;
				if(temp[0].length()==5 || temp[0].length()==7 || temp[0].length()==9) {					
					data[i][2]=temp[0];
					data[i][3]=temp[1];
					break;
				}else {			
					data[i][n+2]=cellcontent;
					n++;
				}				
			}
		}
		return data;
	}
	//获得data对应的数字编码及剩余部分
	private static String[] getDigital(String data) {
		String digital="";
		String nodigital="";
		
		Pattern pattern=Pattern.compile("^(\\d+)(.*)");
		Matcher matcher=pattern.matcher(data);
		if(matcher.find()) {			
			digital= matcher.group(1).trim();
			nodigital=matcher.group(2).trim();
		}
		
		return new String[]{digital,nodigital};
	}
	//过滤非法字符
	private static String handledata(String data) {
		return data.replaceAll("[\\p{C}]", "").replaceAll("\\u00A0+| ", "").replaceAll("[\\r\\n\\t]", "");
	}
	
	//读取word中的全部数据
	public static List<String> getParagraphData(String file){
		List<String> list=new ArrayList<String>();
		String temp="";
		try {
			Document document=new Document();
			document.loadFromFile(file);
			//遍历文档中的段落
			for(int i = 0; i < document.getSections().getCount(); i++) {
	            Section section = document.getSections().get(i);
	            //遍历段落中的文本
	            for (int j = 0; j < section.getParagraphs().getCount(); j++) {
	                Paragraph paragraph = section.getParagraphs().get(j);
	                temp=paragraph.getText();
	                list.add(temp);
	            }
	        }
			
		}catch(Exception ex) {
			ex.printStackTrace();
		}
		return list;
	}
	
	//
	//获取开始文本和结束文本之间的内容，如（一）研究目标---（2）研究内容之间的文本
	//使用于获取：研究目标，技术指标，项目成果中的：技术文件类成果和事务类成果
	
	public static String getStringData(List<String> list,String beginTextflag,String endTextflag) {
		
		StringBuilder data=new StringBuilder();
	    int beginposition=0;
	    String temp="";
		if(list.size()>0) {
			for(int i=0;i<list.size();i++) {
				if(list.get(i).trim().equals(beginTextflag)) {
					beginposition=i;
					break;
				}
			}
			for(int j=beginposition;j<list.size();j++){
				temp=list.get(j+1).trim();
				if(!temp.equals(endTextflag)) {
					if(!"".equals(temp)) {
						data.append(temp);
						data.append("\n");
					}
				}else {
					break;
				}
			}
		}
		return data.toString();
	}
	//研究内容
    public static String getStringData(List<String> list,String beginTextflag,String endTextflag,String beginrowfag) {
		
		StringBuilder data=new StringBuilder();
	    int beginposition=0;
	    int k=1;
	    boolean flag=true;   //标识分项内容开始
	    String temp="";
		if(list.size()>0) {
			for(int i=0;i<list.size();i++) {
				if(list.get(i).trim().equals(beginTextflag)) {
					beginposition=i;
					break;
				}
			}
			for(int j=beginposition;j<list.size();j++){
				temp=list.get(j+1).trim();
				
				if(!temp.equals(endTextflag)) {
					if(temp.startsWith(Integer.toString(k))){
						flag=false;
					}
					if(temp.startsWith(Integer.toString(k)) && !flag) {
						//加入分项研究内容标题
						k++;
						flag=false;
						data.append(temp);
						data.append("\n");
					}else if(flag) {
						//加入研究内容开始部分
						data.append(temp);
						data.append("\n");
					}					
				}else {
					break;
				}
			}
		}
		return data.toString();
	}
	
	//总经费
    public static String getAfterTextTableCellValue(String file,String textflag,int cellindex) {
    	String data="";
    	String temp="";
    	boolean endflag=false;
    	Document document=new Document();
		document.loadFromFile(file);
		for(int i = 0; i < document.getSections().getCount(); i++) {
            Section section = document.getSections().get(i);           
            for (int j = 0; j < section.getParagraphs().getCount(); j++) {
                Paragraph paragraph = section.getParagraphs().get(j);
                temp=paragraph.getText();
                if(temp.contains(textflag)) {
                	Table table=document.getSections().get(i).getTables().get(1);
                	TableRow row=table.getRows().get(table.getRows().getCount()-1);
                	TableCell cell=row.getCells().get(cellindex);
                	data=cell.getParagraphs().get(0).getText(); 
                	endflag=true;
                	break;
                }
            }
            if(endflag)
            	break;
        }
		
		
		/*
		TableCollection tables = document.getSections().get(0).getTables();

        // 查找包含指定文本的表格
        int tableIndex = -1;
        String searchText = "Your Text";
        for (int i = 0; i < tables.getCount(); i++) {
        	Table table = tables.get(i);
            if (table.getText().contains(searchText)) {
                tableIndex = i;
                break;
            }
        }*/
		
		return data;
    }
    
    //  获得合同内容接口
    public static Document getDocument(String file) {
    	Document document=new Document();
		document.loadFromFile(file);
		return document;
    }
    //获得承研方信息
    public static String getUnitInfo(Document document) {
    	String temp="";
    	String temp0="";
    	
    	StringBuilder sb=new StringBuilder();
    			
    	Section section = document.getSections().get(1);
    	//遍历表格中的行
        ITable table=section.getTables().get(1);
        //int rowcount=table.getRows().getCount();
        for (int i = 2; i<=11; i++){
            TableRow row = table.getRows().get(i);
            int count=row.getCells().getCount();
            if(count>=3) {
	            temp=row.getCells().get(0).getParagraphs().get(0).getText();
	            temp0=row.getCells().get(2).getParagraphs().get(0).getText();
	            if(!"".equals(temp0)) {
	            	sb.append(temp+":"+temp0);
	            	sb.append("\n");
	            }
            }
        }
        return sb.toString();
    }
    
    //获得研究总目标、研究内容、技术指标
    //sectionindex=2
    public static List<String> getInfo(Document document,int sectionindex) {
    	
    	List<String> list=new ArrayList<String>();
    	Section section = document.getSections().get(sectionindex);
    	//遍历表格中的行
        ITable table=section.getTables().get(0);
        for (int i = 0; i < table.getRows().getCount(); i++)
        {
            TableRow row = table.getRows().get(i);
            //遍历每行中的单元格
            for (int j = 0; j < row.getCells().getCount(); j++)
            {
                TableCell cell = row.getCells().get(j);
                //遍历单元格中的段落
                for (int k = 0; k < cell.getParagraphs().getCount(); k++)
                {
                    Paragraph paragraph = cell.getParagraphs().get(k);
                   list.add(paragraph.getText());
                   
                }
            }
        }
        return list;
    }
    
    public static String getText(Document document) {
    	String temp="";
		//for(int i = 0; i < document.getSections().getCount(); i++) {
            Section section = document.getSections().get(2); 
            //System.out.println("-------------------------"+i+"--------------");
            
            //遍历表格中的行
            ITable table=section.getTables().get(0);
            
            for (int i = 0; i < table.getRows().getCount(); i++)
            {
                TableRow row = table.getRows().get(i);
                //遍历每行中的单元格
                for (int j = 0; j < row.getCells().getCount(); j++)
                {
                    TableCell cell = row.getCells().get(j);
                    //遍历单元格中的段落
                    for (int k = 0; k < cell.getParagraphs().getCount(); k++)
                    {
                        Paragraph paragraph = cell.getParagraphs().get(k);
                        System.out.println(paragraph.getText());
                       
                    }
                }
                System.out.println("------------------------"+i+"-----------");
            }
            
		return temp;
    }
    //获得List某行的部分数据,且以：分割文本beginText的后部分（使用：合同文档）;注：字符串中若有空格则删除
    //应用文档：项目合同
    public static String getSingleRowStringData(List<String> list,String beginText) {
    	StringBuilder data=new StringBuilder();
	    int beginposition=0;	    
		if(list.size()>0) {
			for(int i=0;i<list.size();i++) {
				if(list.get(i).trim().replace(" ", "").startsWith(beginText)) {
					beginposition=i;
					break;
				}
			}
			data.append(list.get(beginposition).replace(" ", "").replace(beginText, "").trim());
		}
		return data.toString();
    }
    //获得List某行的部分数据,且以：分割文本beginText开始，endtext结束之间的部分（使用：合同文档）;注：字符串中若有空格则删除
    //应用文档：项目合同；目前获取合同总经费
    public static String getSingleRowStringData(List<String> list,String beginText,String endText) {
    	String data="";
    	int listindex=0;
	    int beginposition=0;	
	    int endposition=0;
		if(list.size()>0) {
			//找到所在的元素行
			for(int i=0;i<list.size();i++) {
				System.out.println(list.get(i));
				if(list.get(i).trim().replace(" ", "").indexOf(beginText)>=0) {
					listindex=i;
					break;
				}
			}
			
			if(listindex>=0) {
				System.out.println(list.get(listindex));
				beginposition=list.get(listindex).indexOf(beginText);
				endposition=list.get(listindex).indexOf(endText);
				if (beginposition != -1 && endposition != -1 && endposition > beginposition) {
		            data= list.get(listindex).substring(beginposition + beginText.length(), endposition);
		        } else {
		            data= ""; // 如果找不到匹配的内容，返回""或者其他适当的值
		        }
			}			
		}
		return data.toString();
    }
	//获得里程碑节点信息：名称name；节点时间date；研究目标aim；研究内容content；技术指标index
    public static List<HashMap<String, String>> getLCBNodeinfo(List<String> list){
    	List<HashMap<String, String>> listdata=new ArrayList<HashMap<String,String>>();
    	HashMap<String, String> hash=null;
    	String name="";
    	String date="";
    	
    	String flag="-1";
    	StringBuilder sb0=new StringBuilder();
    	StringBuilder sb1=new StringBuilder();
    	StringBuilder sb2=new StringBuilder();
    	
    	//遍历list
    	for(int i=0;i<list.size();i++) {
    		if(list.get(i).contains("里程碑节点名称")) {
    			name=list.get(i).replace("里程碑节点名称：", "");
    		}
    		//里程碑节点时间
    		if(list.get(i).contains("里程碑节点时间")) {
    			date=list.get(i).replace("里程碑节点时间：", "");
    		}
    		if(list.get(i).contains("里程碑研究目标")) {
    			flag="0";
    		}else if(list.get(i).contains("里程碑研究内容")) {
    			flag="1";
    		}else if(list.get(i).contains("里程碑技术指标")) {
    			flag="2";
    		}else if(list.get(i).contains("里程碑主要成果")) {
    			flag="end";
    		}
    		if(flag.equals("0") && !list.get(i).contains("里程碑研究目标")) {
    			sb0.append(list.get(i).trim());
    		}else if(flag.equals("1") && !list.get(i).contains("里程碑研究内容")) {
    			sb1.append(list.get(i).trim());
    		}else if(flag.equals("2") && !list.get(i).contains("里程碑技术指标")) {
    			sb2.append(list.get(i).trim());
    		}else if(flag.equals("end")) {
    			hash=new HashMap<String, String>();
    			hash.put("name", name);
    			hash.put("date",date);
    			hash.put("aim",sb0.toString());
    			hash.put("content",sb1.toString());
    			hash.put("index",sb2.toString());
    			listdata.add(hash);
    			flag="-1";
    			sb0=new StringBuilder();
    			sb1=new StringBuilder();
    			sb2=new StringBuilder();
    		}
    		if(list.get(i).contains("第4条")) {
    			break;
    		}
    	}
    	return listdata;
    }
    
 	public static void main(String[] args) {
 		/*
		List<String> list=getParagraphData("d:\\bbb.docx");
		System.out.println("-----------------研究目标------------------------");
		String temp=getStringData(list, "（一）研究目标", "（二）研究内容");
		System.out.println(temp);
		System.out.println("-----------------技术指标------------------------");
		
		String temp0=getStringData(list, "（四）技术指标", "三、拟采取的研究方法及途径");
		System.out.println(temp0);
		System.out.println("---------------研究内容------------------");
		String temp00=getStringData(list, "（二）研究内容", "（三）关键技术","0");
		System.out.println(temp00);
        System.out.println("-----------------项目成果------------------------");
		
		String temp01=getStringData(list, "（二）项目成果", "（三）应用方向");
		System.out.println(temp01);
		System.out.println("-----------------总经费------------------------");
		String temp02=getAfterTextTableCellValue("d:\\bbb.docx", "项目经费概算分配表", 1);
		System.out.println(temp02);
		//
		*/
 		//List<String> list=getParagraphData("d:\\contract.docx");
 		//System.out.println("---------------------项目名称--------------------");
		//String temp=getSingleRowStringData(list, "项目名称：");
		//System.out.println(temp);
		//System.out.println("---------------------项目编码--------------------");
		//String temp0=WordUtils.getSingleRowStringData(list, "承研方：");
		//System.out.println(temp0);
 		
 		Document document=new Document();
 		document.loadFromFile("d:\\contract.docx");
 		System.out.println(getText(document));
 		
 		List<String> list=getInfo(document,2);
		System.out.println("-----------------研究总目标------------------------");
		String temp=getStringData(list, "3.1.1 项目研究总目标", "3.1.2 项目研究内容");
		System.out.println(temp.trim());
		System.out.println("-----------------项目研究内容------------------------");
		
		String temp0=getStringData(list, "3.1.2 项目研究内容", "3.1.3 项目关键技术");
		System.out.println(temp0.trim());
 		
		List<HashMap<String, String>> list0=getLCBNodeinfo(list);
		for(int i=0;i<list0.size();i++) {
			System.out.println("-------------lcb-----------------");
			System.out.println(list0.get(i).get("name"));
			System.out.println(list0.get(i).get("date"));
			System.out.println(list0.get(i).get("aim"));
			System.out.println(list0.get(i).get("content"));
			System.out.println(list0.get(i).get("index"));
			System.out.println("--------------------------------");
		}
		List<String> list01=getInfo(document,4);
		String temp01=getSingleRowStringData(list01,"本项目合同总经费","万元");
		System.out.println(temp01);
		//String temp01=WordUtils.getAfterTextTableCellValue("d:\\contract.docx", "承研方");
		//System.out.println(temp01);
		/*
		for(int i=0;i<list.size();i++) {
			System.out.println("-----------------------------------------------------------------");
			System.out.println(i+":"+list.get(i));
		}*/
 		
	}
}
