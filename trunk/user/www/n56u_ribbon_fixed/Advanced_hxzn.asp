<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - 宏兴智能组网</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();
<% vntcli_status(); %>
<% login_state_hook(); %>
$j(document).ready(function() {

	init_itoggle('vntcli_enable');
	init_itoggle('vntcli_log');
	init_itoggle('vntcli_proxy');
	init_itoggle('vntcli_wg');
	init_itoggle('vntcli_first');
	init_itoggle('vntcli_finger');
	init_itoggle('vntcli_serverw');
	$j("#tab_vntcli_cfg, #tab_vntcli_pri, #tab_vntcli_sta, #tab_vntcli_log, #tab_vntcli_help").click(
	function () {
		var newHash = $j(this).attr('href').toLowerCase();
		showTab(newHash);
		return false;
	});

});

</script>
<script>

var m_routelist = [<% get_nvram_list("VNTCLI", "VNTCLIroute"); %>];
var mroutelist_ifield = 4;
if(m_routelist.length > 0){
	var m_routelist_ifield = m_routelist[0].length;
	for (var i = 0; i < m_routelist.length; i++) {
		m_routelist[i][mroutelist_ifield] = i;
	}
}

var m_mapplist = [<% get_nvram_list("VNTCLI", "VNTCLImapp"); %>];
var mmapplist_ifield = 5;
if(m_mapplist.length > 0){
	var m_mapplist_ifield = m_mapplist[0].length;
	for (var i = 0; i < m_mapplist.length; i++) {
		m_mapplist[i][mmapplist_ifield] = i;
	}
}

var isMenuopen = 0;
function initial(){
	show_banner(2);
	show_menu(5, 27, 0);
	showROUTEList();
	showMAPPList();
	show_footer();
	fill_status(vntcli_status());
	change_vntcli_enable(1);
	change_vntcli_model(1);
	if (!login_safe())
        		textarea_scripts_enabled(0);

}

function fill_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("vntcli_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}

var arrHashes = ["cfg","pri","sta","log","help"];
function showTab(curHash) {
	var obj = $('tab_vntcli_' + curHash.slice(1));
	if (obj == null || obj.style.display == 'none')
	curHash = '#cfg';
	for (var i = 0; i < arrHashes.length; i++) {
		if (curHash == ('#' + arrHashes[i])) {
			$j('#tab_vntcli_' + arrHashes[i]).parents('li').addClass('active');
			$j('#wnd_vntcli_' + arrHashes[i]).show();
		} else {
			$j('#wnd_vntcli_' + arrHashes[i]).hide();
			$j('#tab_vntcli_' + arrHashes[i]).parents('li').removeClass('active');
			}
		}
	window.location.hash = curHash;
}

function applyRule(){
	showLoading();
	
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "/Advanced_hxzn.asp";
	document.form.next_page.value = "";
	
	document.form.submit();
}

function done_validating(action){
	refreshpage();
}

function textarea_scripts_enabled(v){
    	inputCtrl(document.form['scripts.vnt.conf'], v);
}


function change_vntcli_model(mflag){
	var m = document.form.vntcli_model.value;
	var Showmodel = (m >= 1 && m <= 7);


	showhide_div("vntcli_key_tr", Showmodel);
	showhide_div("vntcli_key_td", Showmodel);
}

function change_vntcli_enable(mflag){
	var m = document.form.vntcli_enable.value;
	var is_vntcli_enable = (m == "1" || m == "2") ? "重启" : "更新";
	document.form.restartvntcli.value = is_vntcli_enable;

	var is_vntcli_file = (m == "2") ? 1 : 0;
	showhide_div("vntcli_file_tr", is_vntcli_file);
	
	var is_vntcli_log = (m == "1" || m == "2") ? 1 : 0;
	showhide_div("vntcli_log_tr", is_vntcli_log);
	showhide_div("vntcli_log_td", is_vntcli_log);

	var is_vntcli_cmd = (m == "1") ? 1 : 0;
	showhide_div("vntcli_token_tr", is_vntcli_cmd);
	showhide_div("vntcli_token_td", is_vntcli_cmd);
	showhide_div("vntcli_ip_tr", is_vntcli_cmd);
	showhide_div("vntcli_ip_td", is_vntcli_cmd);
	showhide_div("vntcli_localadd_tr", is_vntcli_cmd);
	showhide_div("vntcli_localadd_td", is_vntcli_cmd);
	showhide_div("vntcli_serip_tr", is_vntcli_cmd);
	showhide_div("vntcli_serip_td", is_vntcli_cmd);
	showhide_div("vntcli_model_tr", is_vntcli_cmd);
	showhide_div("vntcli_model_td", is_vntcli_cmd);
	showhide_div("vntcli_subnet_table", is_vntcli_cmd);
	showhide_div("vntcli_pri_table", is_vntcli_cmd);
	showhide_div("vntcli_mapping_table", is_vntcli_cmd);

	var is_vntcli_mtu = (m == "1") ? 1 : 0;
	if(is_vntcli_mtu){
		o_mtu = document.form.vntcli_mtu;
		if (o_mtu && parseInt(o_mtu.value) == 0)
			o_mtu.value = "";
		if (o_mtu && parseInt(o_mtu.value) > 1500)
			o_mru.value = "1500";
	}
}

function button_restartvntcli() {
    var m = document.form.vntcli_enable.value;

    var actionMode = (m == "1" || m == "2") ? ' Restartvntcli ' : ' Updatevntcli ';

    change_vntcli_enable(m); 

    var $j = jQuery.noConflict(); 
    $j.post('/apply.cgi', {
        'action_mode': actionMode 
    });
}

function markrouteRULES(o, c, b) {
	document.form.group_id.value = "VNTCLIroute";
	if(b == " Add "){
		if (document.form.vntcli_routenum_x_0.value >= c){
			alert("<#JS_itemlimit1#> " + c + " <#JS_itemlimit2#>");
			return false;
		}else if (document.form.vntcli_route_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.vntcli_route_x_0.focus();
			document.form.vntcli_route_x_0.select();
			return false;
		}else if(document.form.vntcli_ip_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.vntcli_ip_x_0.focus();
			document.form.vntcli_ip_x_0.select();
			return false;
		}else{
			for(i=0; i<m_routelist.length; i++){
				if(document.form.vntcli_route_x_0.value==m_routelist[i][1]) {
				if(document.form.vntcli_ip_x_0.value==m_routelist[i][2]) {
					alert('<#JS_duplicate#>' + ' (' + m_routelist[i][1] + ')' );
					document.form.vntcli_route_x_0.focus();
					document.form.vntcli_ip_x_0.select();
					return false;
					}
				}
			}
		}
	}
	pageChanged = 0;
	document.form.action_mode.value = b;
	return true;
}

function markmappRULES(o, c, b) {
	document.form.group_id.value = "VNTCLImapp";
	if(b == " Add "){
		if (document.form.vntcli_mappnum_x_0.value >= c){
			alert("<#JS_itemlimit1#> " + c + " <#JS_itemlimit2#>");
			return false;
		}else if (document.form.vntcli_mappport_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.vntcli_mappport_x_0.focus();
			document.form.vntcli_mappport_x_0.select();
			return false;
		}else if(document.form.vntcli_mappip_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.vntcli_mappip_x_0.focus();
			document.form.vntcli_mappip_x_0.select();
			return false;
		}else if(document.form.vntcli_mapeerport_x_0.value==""){
			alert("<#JS_fieldblank#>");
			document.form.vntcli_mapeerport_x_0.focus();
			document.form.vntcli_mapeerport_x_0.select();
			return false;
		}else{
			for(i=0; i<m_mapplist.length; i++){
				if(document.form.vntcli_mappnet_x_0.value==m_mapplist[i][0]) {
					if(document.form.vntcli_mappport_x_0.value==m_mapplist[i][1]) {
						if(document.form.vntcli_mappip_x_0.value==m_mapplist[i][2]) {
							if(document.form.vntcli_mapeerport_x_0.value==m_mapplist[i][3]) {
								alert('<#JS_duplicate#>' + ' (' + m_mapplist[i][1] + ')' );
								document.form.vntcli_mapeerport_x_0.focus();
								document.form.vntcli_mapeerport_x_0.select();
								return false;
							}
						}
					}
				}
			}
		}
	}
	pageChanged = 0;
	document.form.action_mode.value = b;
	return true;
}

function showROUTEList(){
	var code = '<table width="100%" cellspacing="0" cellpadding="4" class="table table-list">';
	if(m_routelist.length == 0)
		code +='<tr><td colspan="5" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
	else{
	    for(var i = 0; i < m_routelist.length; i++){
		code +='<tr id="rowrl' + i + '">';
		code +='<td width="28%">&nbsp;' + m_routelist[i][0] + '</td>';
		code +='<td width="38%">&nbsp;' + m_routelist[i][1] + '</td>';
		code +='<td colspan="2" width="40%">' + m_routelist[i][2] + '</td>';
		code +='<td width="50%"></td>';
		code +='<center><td width="20%" style="text-align: center;"><input type="checkbox" name="VNTCLIroute_s" value="' + m_routelist[i][mroutelist_ifield] + '" onClick="changeBgColorrl(this,' + i + ');" id="check' + m_routelist[i][mroutelist_ifield] + '"></td></center>';
		
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td colspan="5">&nbsp;</td>'
		code += '<td><button class="btn btn-danger" type="submit" onclick="markrouteRULES(this, 64, \' Del \');" name="VNTCLIroute"><i class="icon icon-minus icon-white"></i></button></td>';
		code += '</tr>'
	}
	code +='</table>';
	$("MrouteRULESList_Block").innerHTML = code;
}

function showMAPPList(){
	var code = '<table width="100%" cellspacing="0" cellpadding="4" class="table table-list">';
	if(m_mapplist.length == 0)
		code +='<tr><td colspan="5" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
	else{
	    for(var i = 0; i < m_mapplist.length; i++){
		if(m_mapplist[i][0] == 0)
		vntcli_mappnet="TCP";
		else{
		vntcli_mappnet="UDP";
		}
		code +='<tr id="rowrl' + i + '">';
		code +='<td width="15%">&nbsp;' + vntcli_mappnet + '</td>';
		code +='<td width="25%">&nbsp;' + m_mapplist[i][1] + '</td>';
		code +='<td width="30%">' + m_mapplist[i][2] + '</td>';
		code +='<td width="20%">&nbsp;' + m_mapplist[i][3] + '</td>';
		code +='<td width="50%"></td>';
		code +='<center><td width="20%" style="text-align: center;"><input type="checkbox" name="VNTCLImapp_s" value="' + m_mapplist[i][mmapplist_ifield] + '" onClick="changeBgColorrl(this,' + i + ');" id="check' + m_mapplist[i][mmapplist_ifield] + '"></td></center>';
		
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td colspan="5">&nbsp;</td>'
		code += '<td><button class="btn btn-danger" type="submit" onclick="markmappRULES(this, 64, \' Del \');" name="VNTCLImapp"><i class="icon icon-minus icon-white"></i></button></td>';
		code += '</tr>'
	}
	code +='</table>';
	$("MmappRULESList_Block").innerHTML = code;
}

function clearLog(){
	var $j = jQuery.noConflict();
	$j.post('/apply.cgi', {
		'action_mode': ' ClearvntcliLog ',
		'next_host': 'Advanced_hxzn.asp#log'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_vntcli_info(){
	var $j = jQuery.noConflict();
	$j('#btn_info').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvntinfo ',
		'next_host': 'Advanced_hxzn.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_vntcli_all(){
	var $j = jQuery.noConflict();
	$j('#btn_all').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvntall ',
		'next_host': 'Advanced_hxzn.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_vntcli_list(){
	var $j = jQuery.noConflict();
	$j('#btn_list').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvntlist ',
		'next_host': 'Advanced_hxzn.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

function button_vntcli_route(){
	var $j = jQuery.noConflict();
	$j('#btn_route').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvntroute ',
		'next_host': 'Advanced_hxzn.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}


function button_vntcli_status() {
	var $j = jQuery.noConflict();
	$j('#btn_status').attr('disabled', 'disabled');
	$j.post('/apply.cgi', {
		'action_mode': ' CMDvntstatus ',
		'next_host': 'Advanced_hxzn.asp#sta'
	}).always(function() {
		setTimeout(function() {
			location.reload(); 
		}, 3000);
	});
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
	<div class="container-fluid" style="padding-right: 0px">
	<div class="row-fluid">
	<div class="span3"><center><div id="logo"></div></center></div>
	<div class="span9" >
	<div id="TopBanner"></div>
	</div>
	</div>
	</div>

	<div id="Loading" class="popup_bg"></div>

	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

	<input type="hidden" name="current_page" value="Advanced_hxzn.asp">
	<input type="hidden" name="next_page" value="">
	<input type="hidden" name="next_host" value="">
	<input type="hidden" name="sid_list" value="VNTCLI;LANHostConfig;General;">
	<input type="hidden" name="group_id" value="VNTCLIroute;VNTCLImapp">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="vntcli_routenum_x_0" value="<% nvram_get_x("VNTCLIroute", "vntcli_routenum_x"); %>" readonly="1" />
	<input type="hidden" name="vntcli_mappnum_x_0" value="<% nvram_get_x("VNTCLImapp", "vntcli_mappnum_x"); %>" readonly="1" />

	<div class="container-fluid">
	<div class="row-fluid">
	<div class="span3">
	<!--Sidebar content-->
	<!--=====Beginning of Main Menu=====-->
	<div class="well sidebar-nav side_nav" style="padding: 0px;">
	<ul id="mainMenu" class="clearfix"></ul>
	<ul class="clearfix">
	<li>
	<div id="subMenu" class="accordion"></div>
	</li>
	</ul>
	</div>
	</div>
	<div class="span9">
	<!--Body content-->
	<div class="row-fluid">
	<div class="span12">
	<div class="box well grad_colour_dark_blue">
	<h2 class="box_head round_top">宏兴智能组网</h2>
	<div class="round_bottom">
	<div>
	<ul class="nav nav-tabs" style="margin-bottom: 10px;">
	<li class="active"><a id="tab_vntcli_cfg" href="#cfg">基本设置</a></li>
	<li><a id="tab_vntcli_sta" href="#sta">运行状态</a></li>
	<li><a id="tab_vntcli_log" href="#log">运行日志</a></li>

	</ul>
	</div>
	<div class="row-fluid">
									<div id="tabMenu" class="submenuBlock"></div>
									<div class="alert alert-info" style="margin: 10px;">
									<p>宏兴智能组网是一个易于配置异地组网 直连技术VPN<br>
									</p>
									</div>



									<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">


										<tr>
										<th width="30%" style="border-top: 0 none;">启用组网客户端</th>
											<td style="border-top: 0 none;">
													<div class="main_itoggle">
													<div id="vntcli_enable_on_of">
														<input type="checkbox" id="vntcli_enable_fake" <% nvram_match_x("", "vntcli_enable", "1", "value=1 checked"); %><% nvram_match_x("", "vntcli_enable", "0", "value=0"); %>  />
													</div>
												</div>
												<div style="position: absolute; margin-left: -10000px;">
													<input type="radio" value="1" name="vntcli_enable" id="vntcli_enable_1" class="input" value="1" <% nvram_match_x("", "vntcli_enable", "1", "checked"); %> /><#checkbox_Yes#>
													<input type="radio" value="0" name="vntcli_enable" id="vntcli_enable_0" class="input" value="0" <% nvram_match_x("", "vntcli_enable", "0", "checked"); %> /><#checkbox_No#>
												</div>
											</td>

										</tr>

										<tr>
										<th>本机识别码(不要改动) </th>
				<td>
					<input type="text" class="input" name="vntcli_token" id="vntcli_token" style="width: 200px" value="<% nvram_get_x("","vntcli_token"); %>" />
				</td>

										</tr>

										<tr>
										<th>设备名（格式 20）</th>
				<td>
					<input type="text" class="input" name="vntcli_desname" id="vntcli_desname" style="width: 60px" value="<% nvram_get_x("","vntcli_desname"); %>" />
				</td>

										</tr>
									
										<tr>
										<th>对端的IP（格式 192.168.x.0/24，10.26.0.x） </th>
				<td>
					<input type="text" class="input" name="vntcli_localadd" id="vntcli_localadd" style="width: 400px" value="<% nvram_get_x("","vntcli_localadd"); %>" />
				</td>

										</tr>
										<tr>
										<th>本机虚拟ip（格式 10.26.0.x)</th>
				<td>
					<input type="text" class="input" name="vntcli_ip" id="vntcli_ip" style="width: 200px" value="<% nvram_get_x("","vntcli_ip"); %>" />
				</td>

										</tr>
										<tr>
										<th>服务器地址（默认不用填)</th>
				<td>
					<input type="text" class="input" name="vntcli_serip" id="vntcli_serip" style="width: 200px" value="<% nvram_get_x("","vntcli_serip"); %>" />
				</td>

										</tr>
										<tr>
									
										<td colspan="4" style="border-top: 0 none;">
												<br />
												<center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
											</td>
										</tr>														
	</table>
	</div>
	</div>
	</div>
	</div>
	<!-- 状态 -->
	<div id="wnd_vntcli_sta" style="display:none">
	<table width="100%" cellpadding="4" cellspacing="0" class="table">
	<tr>
		<td colspan="3" style="border-top: 0 none; padding-bottom: 0px;">
			<textarea rows="21" class="span12" style="height:377px; font-family:'Courier New', Courier, mono; font-size:13px;" readonly="readonly" wrap="off" id="textarea"><% nvram_dump("vnt-cli_cmd.log",""); %></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-top: 0 none; text-align: center;">
			<!-- 按钮并排显示 -->
			<input class="btn btn-success" id="btn_info" style="width:100px; margin-right: 10px;" type="button" name="vntcli_info" value="本机设备信息" onclick="button_vntcli_info()" />
			<input class="btn btn-success" id="btn_all" style="width:100px; margin-right: 10px;" type="button" name="vntcli_all" value="所有设备信息" onclick="button_vntcli_all()" />
			<input class="btn btn-success" id="btn_list" style="width:100px; margin-right: 10px;" type="button" name="vntcli_list" value="所有设备列表" onclick="button_vntcli_list()" />
			<input class="btn btn-success" id="btn_route" style="width:100px; margin-right: 10px;" type="button" name="vntcli_route" value="路由转发信息" onclick="button_vntcli_route()" />
			<input class="btn btn-success" id="btn_status" style="width:100px; margin-right: 10px;" type="button" name="vntcli_status" value="运行状态信息" onclick="button_vntcli_status()" />
		</td>
	</tr>
	<tr>
		<td colspan="5" style="border-top: 0 none; text-align: center; padding-top: 5px;">
			<span style="color:#888;">🔄 点击上方按钮刷新查看</span>
		</td>
	</tr>
	</table>
	</div>

	<!-- 日志 -->
	<div id="wnd_vntcli_log" style="display:none">
	<table width="100%" cellpadding="4" cellspacing="0" class="table">
	<tr>
	<td colspan="3" style="border-top: 0 none; padding-bottom: 0px;">
	<textarea rows="21" class="span12" style="height:377px; font-family:'Courier New', Courier, mono; font-size:13px;" readonly="readonly" wrap="off" id="textarea"><% nvram_dump("vnt-cli.log",""); %></textarea>
	</td>
	</tr>
	<tr>
	<td width="15%" style="text-align: left; padding-bottom: 0px;">
	<input type="button" onClick="location.reload()" value="刷新日志" class="btn btn-primary" style="width: 200px">
	</td>
	<td width="15%" style="text-align: left; padding-bottom: 0px;">
	<input type="button" onClick="location.href='vnt-cli.log'" value="<#CTL_onlysave#>" class="btn btn-success" style="width: 200px">
	</td>
	<td width="75%" style="text-align: right; padding-bottom: 0px;">
	<input type="button" onClick="clearLog();" value="清除日志" class="btn btn-info" style="width: 200px">
	</td>
	</tr>
	<br><td colspan="5" style="border-top: 0 none; text-align: center; padding-top: 4px;">
	<span style="color:#888;">🚫注意：日志包含 token 和 密码 等隐私信息，切勿随意分享！</span>
	</td>
	</table>
	</div>
	</div>
</body>

</html>
