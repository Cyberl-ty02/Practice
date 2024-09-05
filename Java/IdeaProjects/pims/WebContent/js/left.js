var selectedpaneltitle="";
var selectedPanelname = '';
var flag=false;
window.onload = function(){
	$('#loading-mask').fadeOut();
}
var onlyOpenTitle="欢迎使用";//不允许关闭的标签的标题
var _menus;
$(function(){
	
	InitLeftMenu();
	tabClose();
	tabCloseEven();
	
	$("#savepassword").click(function(){
		var firstpassword=$("#firstpassword").val();
		var secondpassword=$("#secondpassword").val();
		if(firstpassword=="" || secondpassword==""){
			$.messager.alert("提示", "输入的密码不能为空，请重新输入！", 'info');   
            return;
		}
		if(firstpassword!=secondpassword){
			$.messager.alert("提示", "两次输入的密码不一致，请重新输入！", 'info');   
            return;
		}
		var pattern ="^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,}$";
		if(!firstpassword.match(pattern)){
			$.messager.alert("提示", "输入的密码和规则不一致，请重新输入！", 'info');   
            return;
		}
		$.post("PassWordCheckService?caozuo=add",
			{"username":username,"password":firstpassword},                        
            function (data) {	                	
                var value=eval("("+data+")")
            	if (value.ret == "0") {
                	$.messager.alert("提示", "操作成功！", 'info');
                	$("#dlgpassword").dialog('close');	                        
                    return;
                }else {
                    $.messager.alert("提示",value.reason, 'info');
                    return;
                }             
         });
	});
	
	$("#tabs").tabs({
		onSelect:function(title,index){		 
		  $.post("LeftMenuService?caozuo=setMName",
		  {"mname":title});
	    }
	});
})
//密码不符合规则操作
function UpdatePassword(){
	$('#dlgpassword').dialog('open').dialog('center').dialog('setTitle','修改密码信息');
}

function changeauditinfo(){
	var sel=$("#nav").accordion("panels");	
	if(sel.length>0){
		for(var i=0;i<sel.length;i++){
			var sa=$("#nav").accordion("getPanel",i);
			
			if(sa.panel("options").title.indexOf("信息审核")==0){
				
				$.post("LeftMenuService?caozuo=auditrefresh&username="+username,
				{"menuname":sa.panel("options").title},
			    function(data){
					var val=eval('('+data+')');
					code=val.code;
					
					if(code==1){
						sa.panel("setTitle",val.menuname);				
						if(flag){					
							$('#nav').accordion('unselect',sa.panel("options").title);
						    $('#nav').accordion('select',sa.panel("options").title);
						}
					}
				});
				break;
			}				
						
		}
	}	
}
//心跳
function heartbeat(){
	$.post("HeartBeatService",
	function(data){
		console.log(data);
	});
}
//初始化左侧
function InitLeftMenu() {	
	var selectedpanel=$("#nav").accordion("getSelected");	
	if(selectedpanel!=null)
		selectedpaneltitle=selectedpanel.panel('options').title;
	/*
	var sel=$("#nav").accordion("panels");
	if(sel.length>0)
		for(var i=sel.length-1;i>=0;i--){
			$("#nav").accordion("remove",i);
		}
	*/
	$("#nav").accordion({
		animate:true,
		fit:true,
		border:false,
		onSelect:function(title,index){
			var pp=$("#nav").accordion('getSelected');
			var id=pp.panel('options').id;
		    var seltitle=pp.panel('options').title;
		    if(seltitle.indexOf("信息审核")==0){
		    	flag=true;
		    }else{
		    	flag=false;
		    }
			//if((flag==true && selectedpaneltitle!=selectedPanelname) || selectedpaneltitle=="" || (selectedpaneltitle!="" && title==selectedpaneltitle)){
				
				$("#tree"+id).tree({
					url:"LeftMenuService?caozuo=getchildinfo&username="+encodeURI(username)+"&menuid="+id,
					onClick:function(node){
						var nodeid=node.id;
						var titlename;
						var pos=node.text.indexOf('(');
						if(pos>0){
						   titlename=node.text.substring(0,pos);
						}else{
						   titlename=node.text;
						}
						var tabTitle=titlename;
						var url=node.url;
						var icon=node.iconCls;
						
						if(node.url!="")
						  addTab(tabTitle,url,icon,nodeid);
					},
					onSelect:function(node){
						//$(this).tree('expand',node.target);
						$(this).tree(node.state === 'closed' ? 'expand' : 'collapse', node.target);
					}
				});				
			//}
			
		}
	}); 
	
    $.post("LeftMenuService?username="+encodeURI(username),
    function(data){
	   _menus=eval("("+data+")")
	   var flag=false;
	   
	    $.each(_menus.menus, function(i, n) {
			var menulist ='';
			
			$("#nav").accordion('add',{
				title:n.text,
				content:"<ul id='tree"+n.id+"'></ul>",
				selected:flag,
				border:false,
	            iconCls:n.iconCls,
	            id:n.id
			})	
			//flag=false;
			if(i==0)
				selectedPanelname =n.text;

	    });
	    //alert(selectedpaneltitle);
	    if(selectedpaneltitle!=""){
	       $('#nav').accordion('select',selectedpaneltitle);	    	
	    }else{
	        $('#nav').accordion('select',selectedPanelname);	     
	    }
    });

}


function addTab(subtitle,url,icon,nodeid){
	var tabs=$("#tabs").tabs("tabs");
	var flag=false;
	var index;
	if(tabs.length>=1){
		for(var i=0;i<tabs.length;i++){
			if(tabs[i].panel('options').id==nodeid){
				index=i;
				flag=true;
				break;
			}
		}
	}
	//alert(tabs[tabs.length-1].panel('options').id);
	//if(!$('#tabs').tabs('exists',subtitle)){
	if(!flag){
		$('#tabs').tabs('add',{
			title:subtitle,
			content:createFrame(url),
			closable:true,
			icon:icon,
			id:nodeid
		});
	}else{
		//$('#tabs').tabs('select',subtitle);
		$('#tabs').tabs('select',index);
		var tab = $('#tabs').tabs('getSelected');
		$('#mm-tabupdate').click();
	}
	
	tabClose();
}

function createFrame(url)
{	
	var s = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	return s;
}

function tabClose()
{
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close',subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});

		var subtitle =$(this).children(".tabs-closable").text();

		$('#mm').data("currtab",subtitle);
		$('#tabs').tabs('select',subtitle);
		return false;
	});
}


//绑定右键菜单事件
function tabCloseEven() {

    $('#mm').menu({
        onClick: function (item) {
            closeTab(item.id);
        }
    });

    return false;
}

function closeTab(action)
{
    var alltabs = $('#tabs').tabs('tabs');
    var currentTab =$('#tabs').tabs('getSelected');
	var allTabtitle = [];
	$.each(alltabs,function(i,n){
		allTabtitle.push($(n).panel('options').title);
	})


    switch (action) {
        case "refresh":
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
            $('#tabs').tabs('update', {
                tab: currentTab,
                options: {
                    content: createFrame(src)
                }
            })
            break;
        case "close":
            var currtab_title = currentTab.panel('options').title;
            $('#tabs').tabs('close', currtab_title);
            break;
        case "closeall":
            $.each(allTabtitle, function (i, n) {
                if (n != onlyOpenTitle){
                    $('#tabs').tabs('close', n);
				}
            });
            break;
        case "closeother":
            var currtab_title = currentTab.panel('options').title;
            $.each(allTabtitle, function (i, n) {
                if (n != currtab_title && n != onlyOpenTitle)
				{
                    $('#tabs').tabs('close', n);
				}
            });
            break;
        case "closeright":
            var tabIndex = $('#tabs').tabs('getTabIndex', currentTab);

            if (tabIndex == alltabs.length - 1){
                
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i > tabIndex) {
                    if (n != onlyOpenTitle){
                        $('#tabs').tabs('close', n);
					}
                }
            });

            break;
        case "closeleft":
            var tabIndex = $('#tabs').tabs('getTabIndex', currentTab);
            if (tabIndex == 1) {
                
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i < tabIndex) {
                    if (n != onlyOpenTitle){
                        $('#tabs').tabs('close', n);
					}
                }
            });

            break;
        case "exit":
            $('#closeMenu').menu('hide');
            break;
    }
}



	