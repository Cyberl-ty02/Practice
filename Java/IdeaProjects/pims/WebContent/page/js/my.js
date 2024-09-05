
var projectno;  
$(function () {
		
    inittop();//顶部数据 
    myChart_table_1();
    myChart_left_1();
    myChart_left_2();
    myChart_right_1();
    myChart_right_2();
    /*
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
		
		$.getJSON('/pims/CockpitService?caozuo=inittopinfo', function (res) {
		    document.getElementById("myChart_top_1").innerHTML=res[0].contractcount;
		    document.getElementById("myChart_top_2").innerHTML=res[0].totalfunds;
		    document.getElementById("myChart_top_3").innerHTML=res[0].departcount;
		    document.getElementById("myChart_top_4").innerHTML=res[0].lcbnodecount;		    
		});
		
    }
    //初始化项目信息
    function myChart_table_1(){
    	var pcontainer=document.getElementById("table_1");
    	var v1="";
    	$.getJSON('/pims/CockpitService?caozuo=initprojectinfo', function (data) {
    		var obj=data;
    		var features = "height=500, width=800, top=100, left=100, toolbar=no, menubar=no,scrollbars=no,resizable=no, location=no, status=no";
    		for(let i=0;i<obj.length;i++){
				v1=v1+'<div class="d-flex justify-between font-14 text-black font-14" style="margin: 0 10px;padding: 10px 5px;background-color: #FFFFFF; border-bottom: 1px solid #eeeeee;border-left: 1px solid #eeeeee;border-right: 1px solid #eeeeee;">';
				v1=v1+'<div style="width: 50px; text-align: center;">'+(i+1)+'</div>';
				v1=v1+'<div style="width: 200px; text-align: left; margin-left: 10px;">'+obj[i].projectname+'</div>';
				v1=v1+'<div style="width: 80px; text-align: center;">'+obj[i].total+'</div>';
				v1=v1+'<div style="width: 160px; text-align: center;">'+obj[i].projectunit+'</div>';
				v1=v1+'<div style="width: 160px; text-align: center;">'+obj[i].period+'</div>';
				//v1=v1+'<div style="width: 100px; text-align: center;">';				
				//v1=v1+'<a href="javascript:void(0);" onClick="showprojectinfo(\''+obj[i].projectno+'\')">项目详细信息</a>';
				
				//v1=v1+'</div>';
				v1=v1+'</div>';			
			}
			pcontainer.innerHTML=pcontainer.innerHTML+v1;
        });
    } 
    //
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
        $.getJSON('/pims/CockpitService?caozuo=inityanshou', function (res) {
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
    //拨付情况
    function myChart_right_2() {
        var myChart = echarts.init(document.getElementById('myChart_right_2'));

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

        $.getJSON('/pims/CockpitService?caozuo=initbofu', function (res) {
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
    
    function myChart_right_1() {
        var myChart = echarts.init(document.getElementById('myChart_right_1'));

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
							data: ['集团内', '集团外'],
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

        $.getJSON('/pims/CockpitService?caozuo=initdepart', function (res) {
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

        $.getJSON('/pims/CockpitService?caozuo=initprojectwcl', function (res) {
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
});
    
    