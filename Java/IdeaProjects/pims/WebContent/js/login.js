//JQuery 校验(Login)

$(function () {
	$('#UserName').keydown(function (e) {
		if (e.keyCode == 13) {        
            $("#Password").focus();           
            $("#Password").select();
        }
    });  

    $("#Password").keydown(function (event) {
        if (event.keyCode == 13) {
            $("#btn_Submit").focus();
        }
    });   

    $(document).ready(function () {
        $("input[type=text],textarea,input[type=password]").hover(function () {
            $(this).addClass("hover");
        }, function () {
            $(this).removeClass("hover");
        });

        $("input[type=text],textarea,input[type=password]").focus(function () {
            $(this).addClass("focus");
        });

        $("input[type=text],textarea,input[type=password]").blur(function () {
            $(this).removeClass("focus");
        });
    });

    focusInit();

    var log = {};
  
    $(document).ready(function () {
        $.extend($.fn, {
            reg: function (r, m) {
                $(this).bind('blur', function () {
                    $(this).rt(r.test($(this).val()), this.id, m);
                });
            },
            rt: function (r, d, m) {
                //var o = '#' + d + 'Error';
                if (r) {
                    log[d] = ''; ;
                } else {
                    log[d] = m;
                }
            }
        });
        //$('#UserName').reg(/^[a-z0-9A-Z]{1,50}$/, '用户名非法！\r用户名只能由数字和字母组成！');
        //$('#Password').reg(/^[0-9a-zA-z]{1,50}$/, '密码格式错误！\r密码只能由数字和字母组成！');
        // 中文/^[\u4E00-\u9FA5]{1,16}$/ 
    });
    
    $("#btn_Submit").click(function () { 
    	
        var flag = true;
        $('#username, #password').trigger('blur');
        for (var o in log) {
            if (log[o] != '') {
                flag = false;
                $.messager.alert('提示','登录出现异常！','error'); 
                break;
            }
        }
       
        if (flag == true) {
            $.ajax({
                type: "POST", 			 //使用POST方法访问后台
                dataType: "json",             //返回json格式的数据
                url: "LoginService",             //要访问的后台地址
                //data: {checkCode:$('#ValidCode').val(),username: $.base64.encode($('#UserName').val()), password: $.base64.encode($('#Password').val())}, //发送UserName和Password
                data: {username: $('#username').val(), password: $.base64.encode($('#password').val())},
                complete: function () {
                    $("#load").hide(3000);
                }, 	//AJAX请求完成时隐藏loading提示
                error: function () {
                    removeWaiting();
                    //showError("登陆异常！", focusInit, null);
                },
                success: function (msg) {	//msg为返回的数据，在这里做数据绑定                	
                    removeWaiting();   
                    
                    if (msg.ret == "0") {
                        window.location.href = "main.jsp";                      	
                    }
                    else {
                        var msg1 =msg.reason;
                        $.messager.alert('提示',msg1,'info');                                                
                    }
                },
                beforeSend: function (XMLHttpRequest) {
                    showWaiting();
                }
            });
        }
    });
});

function focusInit() {
    $("#UserName").focus();
}

function showWaiting() {

    $window = $(window);
    $ceng1 = $("<div id='waiting' class='grid-loading'><div>&nbsp;</div></div>")
            .height($window.height())
            .width($window.width())
            .css({ position: 'absolute', zIndex: '1000', top: '0', left: '0'
                    , padding: '0px 0px 0px 0px'
                    , margin: '0px 0px 0px 0px'
                    , display: 'none'
            })
            .appendTo("#login_body").show();
}

function removeWaiting() {
    $("#waiting").remove();
}

