//String.prototype.trim=function() { return this.replace(/(^\s*)|(\s*$)/g,""); }
String.prototype.isEmpty = function(){return /^\s*$/.test(this);}
function funCon(vURL){
	window.parent.frames['main'].location.href=vURL;
}
function setImage(vId,vImage){
    var v=document.getElementById(vId);
    v.background=vImage;
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

// 把对象转换成JSON串
function u_GetJson(obj){
	var str = "{";
	var keystr = "";
	var o;
	for(var key in obj)
	{
		o = obj[key];
		switch(Object.prototype.toString.apply(o))
		{
			case "[object Function]":
				//如果该值得对象是函数，那么函数的返回值只能是字符串
				keystr = o();
				break;
			case "[object Array]":
				keystr = u_GetJson_Arr(o);
				break;
			case "[object Object]":
				if(o == undefined)
				{
					keystr = "\"\"";
				}
				else
				{
					keystr = u_GetJson(o);
				}
				break;
			default:
				keystr = o;
				if (keystr.isEmpty())
				{
					keystr = "\"\"";
				}
				else
				{
					keystr = keystr.replace(/\\/g,"\\\\");
					keystr = keystr.replace(/\'/g,"\\\'");
					keystr = keystr.replace(/\"/g,"\\\"");
					keystr = keystr.replace(/\r/g,"\\r");
					keystr = keystr.replace(/\n/g,"\\r");
					keystr = "\"" + keystr + "\"";
				}
				break;
		}
		str += key + ":" + keystr + ",";
	}
	str = str.substring(0, str.lastIndexOf(',')) + "}";
	return str;
}

// 把数组转换成JSON串
function u_GetJson_Arr(arr){
	var cnt = arr.length;
	if (cnt == 0)
	{
		return "[]";
	}
	var str = "[";
	var keystr = "";
	var i = 0;
	var o;
	for(i=0; i<cnt; i++)
	{
		o = arr[i];
		switch(Object.prototype.toString.apply(o))
		{
			case "[object Function]":
				//如果该值得对象是函数，那么函数的返回值只能是字符串
				keystr = o();
				break;
			case "[object Array]":
				keystr = u_GetJson_Arr(o);
				break;
			case "[object Object]":
				if(o == undefined)
				{
					keystr = "\"\"";
				}
				else
				{
					keystr = u_GetJson(o);
				}
				break;
			default:
				keystr = o;
				if (keystr.isEmpty())
				{
					keystr = "\"\"";
				}
				else
				{
					keystr = "\"" + keystr + "\"";
				}
				break;
		}
		//str += "{" + i + ":" + keystr + "},";
		str += keystr + ",";
	}

	str = str.substring(0, str.lastIndexOf(',')) + "]";
	return str;
}

// 把Table转换成JSON串(包含th的表)
function u_GetJsonfromTable_with_th(tableID)
{
	if (($("#"+tableID+" tr:not('.template, .nodata')").length < 2))
	{
		return "[]";
	}
	var str = "[";
	var o = {};
	var key = [];
	$("#"+tableID+" > thead th").each(function(i){
		key[i] = $(this).attr("colname");
	});
	$("#"+tableID+" > tbody > tr:not('.template, .nodata')").each(function(i){
		$(this).find("td").each(function(j){
			//o[key[j]] = $(this).text();
			$this1 = $(this);
			if ($this1.attr("kind") == "money")
			{
				o[key[j]] = $this1.text().replace(/\,/g,"");
			}
			else
			{
				o[key[j]] = $this1.text();
			}
		});
		str += u_GetJson(o);
		str += ",";
	});
	str = str.substring(0, str.lastIndexOf(',')) + "]";
	return str;
}

function u_GetJsonfromTable_with_Plus(tableID){
	//var tableID = "tab_xqqd";
	var o;
	var key1 = [];
	var key2 = [];
	var arr1 = [];
	var arr2 = [];
	var $this1, $this2;
	$("#"+tableID+" > thead > tr > th").each(function(i){
		key1[i] = $(this).attr("colname");
	});
	$("#"+tableID+" > tbody > tr.template.container > td > div > table > thead > tr > th").each(function(i){
		key2[i] = $(this).attr("colname");
	});
	$("#"+tableID+" > tbody > tr:not('.template, .container')").each(function(i){
		var $_this = $(this);
		var $_next = $_this.next(".container");

		o = {};
		$_this.find("> td").each(function(j){
			$this1 = $(this);
			if ($this1.attr("kind") == "money")
			{
				o[key1[j]] = $this1.text().replace(/\,/g,"");
			}
			else
			{
				o[key1[j]] = $this1.text();
			}
		});
		arr2.push(u_GetJson(o));

		$_next.find("> td > div > table > tbody > tr:not('.template')").each(function(){
			o = {};
			$(this).find("> td").each(function(j){
				$this2 = $(this);
				if ($this2.attr("kind") == "money")
				{
					o[key2[j]] = $this2.text().replace(/\,/g,"");
				}
				else
				{
					o[key2[j]] = $this2.text();
				}
			});
			arr2.push(u_GetJson(o));
		});

		arr1.push("[" + arr2.join(",") + "]");
		arr2.length = 0;
	});

	return "[" + arr1.join(",") + "]";
	
}

//通过数据库获得对应分类的下拉列表
function QueryType(Type_Id, Select_Id, Use, Scope){
	$.ajax({
			type:"post",                         //用POST方式提交数据
			dataType:"json",				     //返回JSON格式的数据
			url:"/GH/Servlet/QueryType",				 //调用后台的QueryType
			data:{LB_LB:Type_Id,Operation:Use},  //向后台传递的数据
			async: false,                        //设置成同步访问模式
			complete:function(){
				
			},
			error:function(){
			     if(Scope == null){
			         parent.parent.showError("基础类别查询失败！",null,null);
			     } else {
			         showError("基础类别查询失败！",null,null);
			     }
			},
			success:function(result){
                var Type = result.Type;
                var len = Type.length;
                if(len == 0){
                    if(Scope == null){
                        parent.parent.showError("没有可用的基础类别数据!",null,null);
                    } else {
                        showError("没有可用的基础类别数据!",null,null);
                    }
                }else{
					var obj_sel = document.getElementById(Select_Id);
                    if(Use == 'Add'){
                        var obj = new Option('请选择','0');
                        obj_sel.options.add(obj);
                    }else if(Use == 'Select'){
                        var obj = new Option('全部','0');
                        obj_sel.options.add(obj);
                    }
					for(var i=1; i<=len; i++){
						var objOption = new Option(Type[i-1].LB_MCHENG,Type[i-1].LB_NO);
						obj_sel.options.add(objOption);
					}
                }
            },
			beforeSend:function(XMLHttpRequest){
				
			}
		});
}


//通过数据库获得对应公司部门的下拉列表
function QueryTenderDepartments(Select_Id, Use, Scope){
    $.ajax({
            type:"post",                
            dataType:"json",            
            url:"/GH/Servlet/QueryTenderDepartments", 
            async: false,               
            complete:function(){
                
            },
            error:function(){
                 if(Scope == null){
                     parent.parent.showError("公司部门查询失败！",null,null);
                 } else {
                     showError("公司部门查询失败！",null,null);
                 }
            },
            success:function(result){
                var TenderDepartments = result.TenderDepartments;
                var len = TenderDepartments.length;
                if(len == 0){
                    if(Scope == null){
                        parent.parent.showError("没有可用的公司部门!",null,null);
                    } else {
                        showError("没有可用的公司部门!",null,null);
                    }
                }else{
					var obj_sel = document.getElementById(Select_Id);
                    if(Use == 'Add'){
                        var obj = new Option('请选择','0');
                        obj_sel.options.add(obj);
                    }else if(Use == 'Select'){
                        var obj = new Option('全部','0');
                        obj_sel.options.add(obj);
                    }
					for(var i=1; i<=len; i++){
						var objOption = new Option(TenderDepartments[i-1].BMH_MCHENG,TenderDepartments[i-1].BMH_NO);
						obj_sel.options.add(objOption);
					}
                }
            },
            beforeSend:function(XMLHttpRequest){
                
            }
        });
}


//查询有指定权限的人员
function QueryPermissionsPersons(RQ_ID, RQ_LB){
    var Persons = {};
    $.ajax({
            type:"post",                         //用POST方式提交数据
            dataType:"json",                     //返回JSON格式的数据
            url:"/GH/Servlet/QueryPermissionsPersons",   //调用后台的QueryType
            data:{GNQX_ID:RQ_ID,RQ_LBIE:RQ_LB}, //向后台传递的数据
            async: false,                        //设置成同步访问模式
            complete:function(){
                
            },
            error:function(){
            
            },
            success:function(result){
                Persons = result;
            },
            beforeSend:function(XMLHttpRequest){
                
            }
        });
    return Persons;
}

//获取服务器日期
function QueryDate(){
    var SYSDATE = '';
    $.ajax({
            type:"post",                        //用POST方式提交数据
            dataType:"json",                    //返回JSON格式的数据
            url:"/GH/Servlet/QueryDate",                //调用后台的QueryType
            async: false,                       //设置成同步访问模式
            complete:function(){
                
            },
            error:function(){
            
            },
            success:function(result){
                SYSDATE = result.SYSDATE;
            },
            beforeSend:function(XMLHttpRequest){
                
            }
        });
    return SYSDATE;
}


//获取显示编号
function GetViewCode(lb){
    var ViewCode = '';
    $.ajax({
            type:"post",                  
            dataType:"json",              
            url:"/GH/Servlet/GetViewCode",
            data:{P_BM_LB:lb}, 
            async: false,                 
            complete:function(){
                
            },
            error:function(){
            
            },
            success:function(result){
                ViewCode = result.ViewCode;
            },
            beforeSend:function(XMLHttpRequest){
                
            }
        });
    return ViewCode;
}

//查询指定的客户信息
function QueryGuest(KH_NO){
    var GuestInfo = {};
    $.ajax({
            type:"post",                            //用POST方式提交数据
            dataType:"json",                        //返回JSON格式的数据
            url:"/GH/Servlet/QueryGuest",                   //调用后台的QueryType
            data:{KHH_NO:KH_NO},                    //向后台传递的数据
            async: false,                           //设置成同步访问模式
            complete:function(){
                
            },
            error:function(){
            
            },
            success:function(result){
                GuestInfo = result;
            },
            beforeSend:function(XMLHttpRequest){
                
            }
        });
    return GuestInfo;
}

var vR = "";
function Ins(tab_hrc,tab_name,sty,GNQX_ID,GNQX_ID2){
	var tag = sty;
	var con =[];
	con[0] = GNQX_ID;
	con[1] = GNQX_ID2;
	var str=window.showModalDialog(tab_hrc, con, "dialogWidth="+tag[0]+";dialogHeight="+tag[1]+";help=no;");
	
	if(str!=null){
		var uTR = $("#"+tab_name+" tr");
		var row = $("#"+uTR[1].id).clone();
		row.css("display","");
	   
		row.click(function(){
			var vTR = $("#"+tab_name+" tr");
			var tr_len = vTR.length;
			for(var i=1; i<tr_len; i++)
			{
				var tr_color = vTR[i].style.backgroundColor;
				if(tr_color!=""){
					vTR[i].style.backgroundColor = "";
				}
				row.css("backgroundColor","#9CF");
			}
		});
	   
		row.onmouseover=function(){
			$(this).addClass("Browse_table_tr");
		}
		row.onmouseout=function(){
			$(this).removeClass("Browse_table_tr");
		}
	   
		var len = $("#"+tab_name+" th").length - 2;
		for(var i=0; i<len; i++){
			if(i!=(len-1)){
				row[0].cells.item(i).innerHTML = str[i];
			}else{
				try{
					if(tag[2]!=""){
						row[0].cells.item(len-1).innerHTML = tag[2];
					}else{
						row[0].cells.item(len-1).innerHTML = str[i];
					}
				}catch(e){alert(e);}
			}
		}
		//隐藏列
		row[0].cells.item(len).innerText = "";
		row[0].cells.item(len+1).innerText = "";
       
		row.mouseover(function(){
		$(this).addClass("Browse_table_tr");		   
			}).mouseout(function(){
		$(this).removeClass("Browse_table_tr");
			});
			
		row.removeClass("template").appendTo("#"+tab_name);
	}
}

var temp_tab,Row_NO;
function Del(tb_id){    
	var gll = false;
	var tb=document.getElementById(tb_id);
	temp_tab = tb;
	var len = tb.rows.length;
	for(var i=1; i<len; i++){
		try{
			var tr_color = tb.rows.item(i).style.backgroundColor;
			if(tr_color=="#9cf"){
				Row_NO = i;
				parent.parent.showDialog("确定要删除吗？", delRow,null,null);
				gll = true;
				break;
			}
		}catch(e){}
	}
	if(!gll){
		parent.parent.showWarning("请选择一条记录!",null,null);  	
	}
}

function delRow(){
	temp_tab.deleteRow(Row_NO);
}

function Upd(tab_hrc,tb_id,sty,temp,GNQX_ID,GNQX_ID2){
	var tag = sty;
	var lg = "";
	var td_len = $("#"+tb_id+" th").length;

	var tb=document.getElementById(tb_id);
	var tr_len = tb.rows.length;
	for(var i=1; i<tr_len; i++){
		var tr_color = tb.rows.item(i).style.backgroundColor;
		if(tr_color=="#9cf"){
			lg = i;
		}
	}
  
	if(lg==""){
		parent.parent.showWarning("请选择一条记录!",null,null);
		return false;
	}
  
	var con = [];
	var len = 0;
	if(temp=="0"){len=td_len-2;}else{len=td_len-1-2;}
	for(var i=0; i<len; i++){
		con[i] = tb.rows.item(lg).cells.item(i).innerHTML;
	}
	con[len] = GNQX_ID;
	con[len+1] = GNQX_ID2;
  
	var sss=window.showModalDialog(tab_hrc, con, "dialogWidth="+tag[0]+";dialogHeight="+tag[1]+";help=no;");
  
	if (sss!=null){
		for(var i=0; i<len; i++){
			tb.rows.item(lg).cells.item(i).innerHTML = sss[i];
		}
	}
}

//日期例子
function dateCase(){
	$(".Date").blur(function(){
		var val = this.value;
		if(val == "" || val == null){
			this.style.color = "#6c6c6c";
			this.value = "yyyy-mm-dd";
		}
	});
	
	$(".Date").focus(function(){
		var val = this.value;
		if(val == "yyyy-mm-dd"){
			this.style.color = "#000080";
			this.value = "";
		}
	});
	
	$(".Date").each(function(){
		var val = this.value;
		if(!$(this).attr("readonly")){
			if(val == "" || val == null){
				this.style.color = "#6c6c6c";
				this.value = "yyyy-mm-dd";
			}else{
				this.style.color = "#000080";
			}
		}
	});
}


function blockUI(){
	$.blockUI();
}
function unblockUI(){
	$.unblockUI();
}
function showWaiting(){
	//var s = 18;			 //div与body宽度
	//$body = $("#home_body");
	$body = $(window);
	$ceng1 = $("<div id='waiting' class='grid-loading'><div>&nbsp;</div></div>")
			.height($body.height())
			.width($body.width())
			.css({position:'absolute',zIndex:'1000',top:'0',left:'0'
					,padding:'0px 0px 0px 0px'
					,margin:'0px 0px 0px 0px'
					,display:'none'})
			.appendTo("body").show();
}

function removeWaiting(){
	$("#waiting").remove();
}
function fileUpload(ElementId,ResultFunction,CloseFunction,PureUpload,UploadPath){
	var parpar = parent.parent;	//指向 Home.jsp
	if(parpar==null){
		parpar = this;
	}
	if(PureUpload==null){
		showWaiting();
	}
	var result = "";
	if(UploadPath!=null){
		$.ajax({
			type:"post",							
			dataType:"json",						
			url:"/GH/Servlet/FileUploadServlet", 
			data:{OperationMark:'GH_TEMP'
			},
			complete:function(){
			},
			error:function(){
				removeWaiting();
			},
			success:function(result){
				removeWaiting();
			},
			beforeSend:function(XMLHttpRequest){
				showWaiting();
			}
		});
	}
	$.ajaxFileUpload({
		url:'/GH/Servlet/FileUploadServlet',		//需要链接到服务器地址
		secureuri:false,
		fileElementId:ElementId,					//文件选择框的id属性
		dataType: 'json',							//服务器返回的格式，可以是json
		success: function (data, status)			//相当于java中try语句块的用法
		{
			if(PureUpload==null){
				removeWaiting();
			}
			if(status=="success"){
				result = data.complete;
			}else{
				result = status;
			}
			ResultFunction(result);
			if(PureUpload==null){
				if(result.filePath==null || result.filePath==""){
					parpar.showError("上传失败，详细信息请查看日志!",CloseFunction);
				}else{
					parpar.showSuccess("上传成功",CloseFunction);
				}
			}
		},
		error: function (data, status, e)			//相当于java中catch语句块的用法
		{
			if(PureUpload==null){
				removeWaiting();
			}
			result = "error"
			ResultFunction(result);
			parpar.showError(e,CloseFunction);
		}
	});
}

function fileDownLoad(jspPath,fileAddress,filename){
	var parpar = parent.parent;	//指向 Home.jsp
	if(parpar==null){
		parpar = this;
	}
	var url1 = jspPath+"jsp/00_public/FileDownLoad.jsp"+"?fileAddress="+escape(encodeURIComponent(fileAddress))+"&filename="+escape(encodeURIComponent(filename));
	//var url1 = encodeURI(jspPath+"jsp/00_public/FileDownLoad.jsp"+"?fileAddress="+fileAddress+"&filename="+filename);
	$.ajax({
		dataType:"json",					//返回json格式的数据
		url:url1,			//要访问的后台地址
		data:{OPTION:"testExist"
		},
		complete:function(){
		},
		error:function(e){
			removeWaiting();
			parpar.showError("下载失败，ajax异常");
			
		},
		success:function(result){
			removeWaiting();
			if(result!=null && result.RESULT!=""){
				parpar.showError(result.RESULT);
				
			}else{
				window.document.location.href = url1+"&OPTION=downLoad";
			}
		},
		beforeSend:function(){
			showWaiting();
		}
	});
}

function setSelect(ID, Use, DATA, Scope) {

    var len = DATA.length;
    var obj_sel = document.getElementById(ID);
    if(len == 0){
        if(Use == 'Add'){
            var obj = new Option('请选择','0');
            obj_sel.options.add(obj);
        }else if(Use == 'Select'){
            var obj = new Option('全部','0');
            obj_sel.options.add(obj);
        }
        //if(Scope == null){
        //    parent.parent.showError("没有可用的基础类别数据!",null,null);
        //} else {
        //    showError("没有可用的基础类别数据!",null,null);
        //}
    }else{
        
        if(Use == 'Add'){
            var obj = new Option('请选择','0');
            obj_sel.options.add(obj);
        }else if(Use == 'Select'){
            var obj = new Option('全部','0');
            obj_sel.options.add(obj);
        }
        for(var i=1; i<=len; i++){
            var objOption = new Option(DATA[i-1].TEXT,DATA[i-1].VALUE);
            objOption.TXT1 = DATA[i-1].LB_TXT1;
            obj_sel.options.add(objOption);
        }
    }
}

//------------------------------------------------------------------ 用于格式化货币
   function Format_outputMoney(number) {
		number=number.replace(/\,/g,"");
	   if (isNaN(number)||number=="") return "";
		number = Math.round(  number*100) /100;
	   if(number<0)
		return '-'+outputDollars(Math.floor(Math.abs(number)-0) + '') + outputCents(Math.abs(number) - 0);
	   else
		return outputDollars(Math.floor(number-0) + '') + outputCents(number - 0);
   }
  function outputDollars(number)
  {
	  if (number.length<= 3)
		return (number == '' ? '0' : number);
	  else
	  {
		  var mod = number.length%3;
		  var output = (mod == 0 ? '' : (number.substring(0,mod)));
		  for (i=0 ; i< Math.floor(number.length/3) ; i++)
	  {
		  if ((mod ==0) && (i ==0))
			output+= number.substring(mod+3*i,mod+3*i+3);
		  else
			output+= ',' + number.substring(mod+3*i,mod+3*i+3);
		  }
		  return (output);
	  }
  }
  function outputCents(amount)
  {
	  amount = Math.round( ( (amount) - Math.floor(amount) ) *100);
	  return (amount<10 ? '.0' + amount : '.' + amount);
  }
//------------------------------------------------------------------ 用于格式化货币 end
//------------------------------------------------------------------ 用于格式化数量
	function Format_outputNumber(number) {
		number=number.replace(/\,/g,"");
	   if (isNaN(number)||number=="") return "";
		number = Math.round(  number*100) /100;
	   if(number<0)
		return '-'+outputDollars(Math.floor(Math.abs(number)-0) + '') + outputNum(Math.abs(number) - 0);
	   else
		return outputDollars(Math.floor(number-0) + '') + outputNum(number - 0);
   }
  function outputNum(amount)
  {
	  amount = Math.round( ( (amount) - Math.floor(amount) ) *100);
	  if (amount == 0)
	  {
	  	return "";
	  }
	  else if ((amount>10) && ((amount%10) == 0))
	  {
	  	return '.' + (amount/10);
	  }
	  else
	  {
	  	return (amount<10 ? '.0' + amount : '.' + amount);
	  }
  }
//------------------------------------------------------------------ 用于格式化数量 end

//------------------------------------------------------------------ 用于检验
/**
* 得到字符串的字符长度（一个汉字占两个字符长）
*/
function U_getBytesLength(str) {
	// 在GBK编码里，除了ASCII字符，其它都占两个字符宽
	return str.replace(/[^\x00-\xff]/g, 'xx').length;
}

function U_Validate(arr)
{
	var retarr = [];
	var i = 0;
	var cnt = arr.length;
	var obj, _CtrlID, _CtrlName, _required
	, _minlength, _maxlength, _kind, _value, _len, regexpValue;
	for(i=0; i<cnt; i++)
	{
		obj = arr[i];
		_CtrlID = obj.CtrlID;
		_CtrlName = obj.CtrlName;
		_required = obj.required;
		_minlength = obj.minlength;
		_maxlength = obj.maxlength;
		_kind = obj.kind;
		
		_value = $.trim($("#"+_CtrlID).val());
		_len = U_getBytesLength(_value);
		
		if(_kind == "日期"){
			var val = $("#"+_CtrlID).val();
			if(val == "yyyy-mm-dd"){
				$("#"+_CtrlID).val("");
				document.getElementById(_CtrlID).style.color = "#000080";
				_value = "";
				_len = U_getBytesLength(_value);
			}
		}

		if (_len == 0)
		{
			if(_required != undefined)
			{//_CtrlName + "不能为空！"
				retarr.push(_CtrlName + "不能为空！");
			}
			continue;
		}
		

		if(_kind != undefined)
		{//_CtrlName + "为非法的"+ _kind + "！"
			switch(_kind)
			{
				case "email":
					regexpValue = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(_value);
					break;
				case "url":
					regexpValue = /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(_value);
					break;
				case "数字":
					regexpValue = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(_value);
					break;
					//上面都是根据jquery.validate.js中的算法
					//下面是张博识编写的算法
				case "日期":
					//regexpValue = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/.test(_value);
					regexpValue = /^((((1[6-9]|[2-9]\d)\d{2})(-|\/)(0?[13578]|1[02])(-|\/)(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})(-|\/)(0?[13456789]|1[012])(-|\/)(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})(-|\/)0?2(-|\/)(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))(-|\/)0?2(-|\/)29))$/.test(_value);
					break;
				case "金额":
					regexpValue = /^(([0-9]{1,3}(,[0-9]{3}){0,})|([0-9]{1,}))(\.[0-9]{1,})?$/.test(_value);
					break;
				case "身份证号":
					regexpValue = /^[\d]{6}(18|19|20)*[\d]{2}((0[1-9])|(11|12))([012][\d]|(30|31))[\d]{3}[xX\d]*$/.test(_value);
					break;
				case "电话":
					regexpValue = /^[0-9,+]{1,}(-[0-9]{1,})*$/.test(_value);
					break;
				case "护照":
					regexpValue = /^((14|15)|(G\d)|(P\.)|(S\.)|(S\d))\d{7}$/.test(_value);
				default:
					regexpValue = false;
					break;
			}
			
			if (!regexpValue)
			{
				retarr.push(_CtrlName + "为非法的"+ _kind + "格式！");
				continue;
			}
		}
		
		if(_maxlength != undefined)
		{//_CtrlName + "不能超过" + _maxlength + "个字节！"
			if (_len > _maxlength)
			{
				retarr.push(_CtrlName + "不能超过" + _maxlength + "个字节！");
				continue;
			}
		}
		
		if(_minlength != undefined)
		{//_CtrlName + "不能少于" + _minlength + "个字节！"
			if (_len < _minlength)
			{
				retarr.push(_CtrlName + "不能少于" + _minlength + "个字节！");
				continue;
			}
		}
	}
	
	return retarr;
}


//------------------------------------------------------------------ 用于检验 end