
var projectno;  
$(function () {
		
    inittop();//顶部数据
    /*
    myChart_table_1();
    myChart_table_2();
    
    myChart_left_1();
    myChart_left_2();
    myChart_left_3();
    myChart_right_1();
    myChart_right_2();
    myChart_right_3();
    myChart_right_4();
    myChart_right_5();
    myChart_right_6();
    */
    //计算出所有项目的完成率
    function inittop(){    	
		
		$.getJSON('/pims/CockpitFundsService?caozuo=inittopinfo', function (res) {
		    document.getElementById("myChart_top_1").innerHTML=res[0].contractcount;
		    document.getElementById("myChart_top_2").innerHTML=res[0].totalfunds;
		    document.getElementById("myChart_top_3").innerHTML=res[0].departcount;
		    document.getElementById("myChart_top_4").innerHTML=res[0].lcbnodecount;		    
		});
		
    }       

    function myChart_left_1() {
        var myChart = echarts.init(document.getElementById('myChart_left_1'));

        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
					tooltip: {
						trigger: 'item'
					},
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 15,
						textStyle: {
							color: "#1f2937",
							fontSize: 14,
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['40%', '55%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {
							//show: true,
							//position: 'right'
							show: true,
	                        formatter: function () {
	
	                                var complete = option.series[0].data[0].value;
	                                var nocomplete = option.series[0].data[1].value;
	                                if((complete==0)&&(nocomplete==0)){
		                                 return  "0%";
	                                }else{
		                                 var degree = complete/(complete+nocomplete);
	                                     return degree.toFixed(2) * 100 + "%";
	                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        /*formatter:'{d}%',*/
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '14',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitService?caozuo=initlcb', function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }
            setEchart(newArr);
        });
    }

    function myChart_left_2() {
        var myChart = echarts.init(document.getElementById('myChart_left_2'));

        function setEchart(data){
	// 指定图表的配置项和数据
        var option = {
				tooltip: {
					trigger: 'item'
				},
				legend: {
					orient: 'horizontal',
					x: 'center',
					y: 'bottom',
					data: ['完成', '未完成'],
					itemGap: 15,
					textStyle: {
						color: "#1f2937",
						fontSize: 14,
						align: "center"
					}
				},
				
				series: [{
					//name: '节点完成度',
					type: 'pie',
					radius: ['40%', '55%'],
					avoidLabelOverlap: true,
					clockWise: false,
					label: {
						//show: true,
						//position: 'right'
						show: true,
                        formatter: function () {

                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0)&&(nocomplete==0)){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(complete+nocomplete);
                                     return degree.toFixed(2) * 100 + "%";
                                }
                        },
                        fontSize: 14,
                        color: '#2563eb',
                        /*formatter:'{d}%',*/
                        position: 'center',
					},
					emphasis: {
						label: {
							show: true,
							fontSize: '14',
							fontWeight: 'bold',
						}
					},
					labelLine: {
						show: false
					},
					data: data
				}],
			};

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
        window.addEventListener("resize", function () {
            myChart.resize();
        });
	
};

        $.getJSON('/kygl/CockpitService?caozuo=initgj', function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }

            setEchart(newArr);
        });
    }
    
    
    function myChart_left_3() {
        var myChart = echarts.init(document.getElementById('myChart_left_3'));

        function setEchart(data) { // 指定图表的配置项和数据
        var option = {
				tooltip: {
					trigger: 'item'
				},
				legend: {
					orient: 'horizontal',
					x: 'center',
					y: 'bottom',
					data: ['完成', '未完成'],
					itemGap: 15,
					textStyle: {
						color: "#1f2937",
						fontSize: 14,
						align: "center"
					}
				},
				
				series: [{
					//name: '节点完成度',
					type: 'pie',
					radius: ['40%', '55%'],
					avoidLabelOverlap: true,
					clockWise: false,
					label: {
						//show: true,
						//position: 'right'
						show: true,
                        formatter: function () {

                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0)&&(nocomplete==0)){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(complete+nocomplete);
                                     return degree.toFixed(2) * 100 + "%";
                                }
                        },
                        fontSize: 14,
                        color: '#2563eb',
                        /*formatter:'{d}%',*/
                        position: 'center',
					},
					emphasis: {
						label: {
							show: true,
							fontSize: '14',
							fontWeight: 'bold',
						}
					},
					labelLine: {
						show: false
					},
					data: data
				}],
			};

            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
            window.addEventListener("resize", function () {
                myChart.resize();
            });
        };

        $.getJSON('/kygl/CockpitService?caozuo=inityb', function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }

            setEchart(newArr);
        });
    }
    

    //以下是完成率细化的函数及操作
    function initproject(){
		$('#queryproject').combobox({
	            url:'CockpitService?caozuo=initproject',        
	            editable:false,        
	            hasDownArrow:true,
	            valueField: 'projectno',
	            textField: 'contractname',
		    });
    }

    $("#querydata").click(function () {
	        if ($("#queryproject").combobox('getValue') == "") {
				$.messager.alert("提示", "请选择项目信息！", 'info');
				return;
			}
			
			//计算出当前项目的节点数
		    var qprojectno = $("#queryproject").combobox("getValue");
            $.getJSON('CockpitService?caozuo=inittotalxh&projectno='+qprojectno, function (res) {
	    		document.getElementById("counttotalxh").innerHTML="总结点："+res[0].count+"个";
	       });	    		
    		
            mycss_body_right_1_xh(qprojectno);
            mycss_body_right_2_xh(qprojectno);
            mycss_body_right_3_xh(qprojectno);
    	});
    

function mycss_body_right_1_xh(qprojectno) {
        var myChart = echarts.init(document.getElementById('mycss_body_right_1_xh'));

        function setEchart(data){
	
	// 指定图表的配置项和数据
        var option = {
            title: {

                text: '里程碑节点完成度',
                textStyle: {
                    color: '#ffffff',

                },
                textAlign: 'left'
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                //top: '5%',
                left: 'right',
                orient: 'vertical',
                textStyle: {
                    color: '#ffffff'
                }
            },
            color: ['#B22222', '#FFFFFF'],
            series: [{
                    name: '',
                    type: 'pie',
                    radius: ['50%', '70%'],
                    center: ['50%', '50%'],
                    avoidLabelOverlap: false,
                    clockWise: false,
                    label: {
                        show: true,
                        formatter: function () {

                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0)&&(nocomplete==0)){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(complete+nocomplete);
                                     return degree.toFixed(2) * 100 + "%";
                                }
                        },
                        fontSize: '20',
                        color: '#ffffff',
                        /*formatter:'{d}%',*/
                        position: 'center',

                    },
                    emphasis: {
                        label: {
                            show: false,
                            fontSize: '32',
                            fontWeight: 'bold'
                        }
                    },
                    labelLine: {
                        show: false
                    },
                    data: data,
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
        window.addEventListener("resize", function () {
            myChart.resize();
        });
	
}

        $.getJSON('CockpitService?caozuo=queryinitlcb&projectno='+qprojectno, function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }

            setEchart(newArr);
        });
    }

    function mycss_body_right_2_xh(qprojectno) {
        var myChart = echarts.init(document.getElementById('mycss_body_right_2_xh'));

        function setEchart(data){
	// 指定图表的配置项和数据
        var option = {
            title: {

                text: '关键节点完成度',
                textStyle: {
                    color: '#ffffff',

                },
                textAlign: 'left'
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                //top: '5%',
                left: 'right',
                orient: 'vertical',
                textStyle: {
                    color: '#ffffff'
                }
            },
            color: ['#FFD700', '#FFFFFF'],
            series: [{
                    name: '',
                    type: 'pie',
                    radius: ['50%', '70%'],
                    center: ['50%', '50%'],
                    avoidLabelOverlap: false,
                    clockWise: false,
                    label: {
                        show: true,
                        formatter: function () {
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0)&&(nocomplete==0)){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(complete+nocomplete);
                                     return degree.toFixed(2) * 100 + "%";
                                }
                        },
                        fontSize: '20',
                        color: '#ffffff',
                        position: 'center',

                    },
                    emphasis: {
                        label: {
                            show: false,
                            fontSize: '32',
                            fontWeight: 'bold'
                        }
                    },
                    labelLine: {
                        show: false
                    },
                    data: data,
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
        window.addEventListener("resize", function () {
            myChart.resize();
        });
	
};

        $.getJSON('CockpitService?caozuo=queryinitgj&projectno='+qprojectno, function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }

            setEchart(newArr);
        });
    }

    function mycss_body_right_3_xh(qprojectno) {
        var myChart = echarts.init(document.getElementById('mycss_body_right_3_xh'));

        function setEchart(data) { // 指定图表的配置项和数据
            var option = {
                title: {

                    text: '一般节点完成度',
                    textStyle: {
                        color: '#ffffff',

                    },
                    textAlign: 'left'
                },
                tooltip: {
                    trigger: 'item'
                },
                legend: {
                    left: 'right',
                    orient: 'vertical',
                    textStyle: {
                        color: '#ffffff'
                    }
                },
                color: ['#228B22', '#FFFFFF'],
                series: [{
                        name: '',
                        type: 'pie',
                        radius: ['50%', '70%'],
                        center: ['50%', '50%'],
                        avoidLabelOverlap: false,
                        clockWise: false,
                        label: {
                            show: true,
                            formatter: function () {
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0)&&(nocomplete==0)){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(complete+nocomplete);
                                     return degree.toFixed(2) * 100 + "%";
                                }
                            },
                            fontSize: '20',
                            color: '#ffffff',
                            position: 'center',

                        },
                        emphasis: {
                            label: {
                                show: false,
                                fontSize: '32',
                                fontWeight: 'bold'
                            }
                        },
                        labelLine: {
                            show: false
                        },
                        data: data,
                    }
                ]
            };

            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
            window.addEventListener("resize", function () {
                myChart.resize();
            });
        };

        $.getJSON('CockpitService?caozuo=queryinityb&projectno='+qprojectno, function (res) {
            let newArr = [];
            for (let i = 0; i < res.length; i++) {
                let obj = {
                    name: res[i].name,
                    value: res[i].count,
                }
                newArr.push(obj);
            }
            setEchart(newArr);
        });
    }
    
    
    //中间的在研项目信息
    function myChart_table_1(){
    	var pcontainer=document.getElementById("table_1");
    	var v1="";
    	$.getJSON('/kygl/CockpitFundsService?caozuo=initzyprojectinfo', function (data) {
    		var obj=data;
    		var features = "height=500, width=800, top=100, left=100, toolbar=no, menubar=no,scrollbars=no,resizable=no, location=no, status=no";
    		for(let i=0;i<obj.length;i++){
				v1=v1+'<div class="d-flex justify-between font-14 text-black font-14" style="margin: 0 10px;padding: 9px 5px;background-color: #FFFFFF; border-bottom: 1px solid #eeeeee;border-left: 1px solid #eeeeee;border-right: 1px solid #eeeeee;">';
				v1=v1+'<div style="width: 50px; text-align: center;">'+(i+1)+'</div>';
				v1=v1+'<div style="width: 200px; text-align: left; margin-left: 10px;">'+obj[i].projectname+'</div>';
				v1=v1+'<div style="width: 80px; text-align: center;">'+obj[i].total+'</div>';
				v1=v1+'<div style="width: 160px; text-align: center;">'+obj[i].projectunit+'</div>';
				v1=v1+'<div style="width: 60px; text-align: center;">'+obj[i].period+'</div>';
				v1=v1+'<div style="width: 100px; text-align: center;">';				
				v1=v1+'<a href="javascript:void(0);" onClick="showprojectinfo(\''+obj[i].projectno+'\')">项目详细信息</a>';
				
				v1=v1+'</div>';
				v1=v1+'</div>';			
			}
			pcontainer.innerHTML=pcontainer.innerHTML+v1;
        });
    } 
    
    //中间的告警项目信息
    function myChart_table_2(){
    	var pcontainer=document.getElementById("table_2");
    	var v1="";
    	$.getJSON('/kygl/CockpitService?caozuo=initwarning', function (data) {
    		var obj=data;
    		console.log(obj);
    		for(let i=0;i<obj.length;i++){
				v1=v1+'<div class="d-flex justify-between font-14 text-black font-14" style="margin: 0 10px;padding: 9px 5px;background-color: #FFFFFF; border-bottom: 1px solid #eeeeee;border-left: 1px solid #eeeeee;border-right: 1px solid #eeeeee;">';
				v1=v1+'<div style="width: 50px; text-align: center;">'+(i+1)+'</div>';
				v1=v1+'<div style="width: 200px; text-align: left; margin-left: 10px;">'+obj[i].contractname+'</div>';
				v1=v1+'<div style="width: 120px; text-align: center;">'+obj[i].ketiname+'</div>';
				v1=v1+'<div style="width: 60px; text-align: center;">'+obj[i].taskjxname+'</div>';
				v1=v1+'<div style="width: 60px; text-align: center;">'+obj[i].nodelevel+'</div>';
				v1=v1+'<div style="width: 100px; text-align: center;">';
				v1=v1+'<div style="width: 100px; text-align: center;">'+obj[i].responsibledepartmentname+'</div>';
								
				v1=v1+'</div>';
				v1=v1+'</div>';
			}
			pcontainer.innerHTML=pcontainer.innerHTML+v1;
        });
    }
    
    function myChart_right_1() {
        var myChart = echarts.init(document.getElementById('myChart_right_1'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{                                	 
	                                 var degree = complete/(eval(complete)+eval(nocomplete));                                    
	                                 return degree.toFixed(2) * 100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initfundsexceute', function (res) {
            let newArr = [];           
            let obj = {
            	name:'完成',
                value: res.achievfunds0,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: res.noachievfunds0,
            }
            newArr.push(obj);
            setEchart(newArr);
        });
    }
    function myChart_right_2() {
        var myChart = echarts.init(document.getElementById('myChart_right_2'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{                                	
	                                 var degree = complete/(eval(complete)+eval(nocomplete));
                                    
	                                 return degree.toFixed(2) * 100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initfundsexceute', function (res) {
            let newArr = [];           
            let obj = {
            	name:'完成',
                value: res.achievfunds1,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: res.noachievfunds1,
            }
            newArr.push(obj);
            setEchart(newArr);
        });
    }
    function myChart_right_3() {
        var myChart = echarts.init(document.getElementById('myChart_right_3'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{                                	
	                                 var degree = complete/(eval(complete)+eval(nocomplete));
                                    
	                                 return degree.toFixed(2) * 100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initfundsexceute', function (res) {
            let newArr = [];           
            let obj = {
            	name:'完成',
                value: res.achievfunds2,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: res.noachievfunds2,
            }
            newArr.push(obj);           
            setEchart(newArr);
        });
    }
    
    function myChart_right_4() {
        var myChart = echarts.init(document.getElementById('myChart_right_4'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{
	                                 var degree = complete/(eval(complete)+eval(nocomplete));
                                    
	                                 return degree.toFixed(2) * 100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initpurchaseplan', function (res) {
            let newArr = [];           
            let obj = {
            	name:'完成',
                value: res.achievfunds,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: eval(res.fundstotal)-eval(res.achievfunds),
            }
            newArr.push(obj);
            setEchart(newArr);
        });
    }
    function myChart_right_5() {
        var myChart = echarts.init(document.getElementById('myChart_right_5'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{                                	
	                                 var degree = complete/(eval(complete)+eval(nocomplete));
                                   
	                                 return degree.toFixed(2)*100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initpurchaseplan', function (res) {
            let newArr = [];
            let obj = {
            	name:'完成',
                value: res.htqdcount,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: eval(res.htcounttotal)-eval(res.htqdcount),
            }
            newArr.push(obj);
            setEchart(newArr);
        });
    }
    function myChart_right_6() {
        var myChart = echarts.init(document.getElementById('myChart_right_6'));
        function setEchart(data){	
		    // 指定图表的配置项和数据
	        var option = {
	        		tooltip: {
						trigger: 'item'
					},
					color: ['#1299ff', '#94cdff'],
					legend: {
						orient: 'horizontal',
						x: 'center',
						y: 'bottom',
						data: ['完成', '未完成'],
						itemGap: 10,
						textStyle: {
							color: "#000000", //legend文字颜色
							fontSize: 12, //legend文字大小
							align: "center"
						}
					},
					
					series: [{
						//name: '节点完成度',
						type: 'pie',
						radius: ['35%', '50%'],
						avoidLabelOverlap: true,
						clockWise: false,
						label: {							
							show: true,
	                        formatter: function () {	
                                var complete = option.series[0].data[0].value;
                                var nocomplete = option.series[0].data[1].value;
                                if((complete==0 && nocomplete==0) || (complete+nocomplete)==0){
	                                 return  "0%";
                                }else{                                	
	                                 var degree = complete/(eval(complete)+eval(nocomplete));
                                    
	                                 return degree.toFixed(2) * 100 + "%";
                                }
	                        },
	                        fontSize: 14,
	                        color: '#2563eb',
	                        position: 'center',
						},
						emphasis: {
							label: {
								show: true,
								fontSize: '12',
								fontWeight: 'bold',
							}
						},
						labelLine: {
							show: false
						},
						data: data
					}],
				};
	
	        // 使用刚指定的配置项和数据显示图表。
	        myChart.setOption(option);
	        window.addEventListener("resize", function () {
	            myChart.resize();
	        });	
        }
        $.getJSON('/kygl/CockpitFundsService?caozuo=initpurchaseplan', function (res) {
        	let newArr = [];
            let obj = {
            	name:'完成',
                value: res.achievcount,
            }
            newArr.push(obj);
            obj = {
            	name:'未完成',
                value: eval(res.counttotal)-eval(res.achievcount),
            }
            newArr.push(obj);
            setEchart(newArr);
        });
    }   
});

//显示项目详细信息
function showprojectinfo(pno){	
	initprojectinfo(pno)
	$('#dlgprojectinfo').dialog('open').dialog('center').dialog('setTitle','项目详细信息');
	//打开对话框，默认选中第一个
	$('#cockpittabs').tabs('select', 0);
	$("#fundsinfo").datagrid("resize");
}

function initprojectinfo(projectno){
	//项目信息
	$.post("/kygl/YearProjectFundsAssign?caozuo=getinfo&projectcode="+projectno,
	function (data) {
          var value=eval("("+data+")");
          if (value!=null) {
        	 $("#dprojectcode").val(value.projectno);
			 $("#dprojectname").val(value.projectname);
             $("#dbegindate").val(value.begindate);
             $("#denddate").val(value.enddate);
             $("#dperiod").val(value.period);
          }
	});
	//项目经费执行情况信息
	$("#fundsinfo").datagrid({
        url: "/kygl/YearProjectFundsTotalService?caozuo=initinfo&con="+"projectno='"+projectno+"'"
   });
    //节点执行情况信息
	$("#nodeinfo").datagrid({
        url: "/kygl/ImplementStaticsService?caozuo=initbyprojectno&con="+"projectno='"+projectno+"'"
   });
}