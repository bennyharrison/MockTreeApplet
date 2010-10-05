<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// MockTreeApplet
//
//
// TODO
//		Everything
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<ics:setssvar name="locale" value="en_US" />
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardVariables"/>
<html>
<head>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardHeader"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet" />
	
	<style type="text/css">
	HTML, BODY {padding:0px; margin:0px;}
	IMG {float:left; margin-bottom:-1px; padding-right:5px;}
	UL.children {float:left; width:500px; list-style:none; padding:0px; margin:0px;}
	UL.children LI { float:left; width:280px; list-style:none; padding:0px; margin:0px; font-size:10px;}
	UL.children UL LI {padding-left:15px; }
	SPAN.ExecuteURL {float:left; width:220px; color:#336699;}
	UL SPAN.selectable {float:left; padding:2px; cursor:pointer;}
	UL SPAN.selected {background-color:#336699; padding:1px; border:1px dashed #DDD; color:white;}
	A {color:#336699;}
	SPAN.icon {font-weight:bold; font-size:9px; float:left; width:22px;}
	SPAN.iconplus {display:inline;}
	SPAN.iconminus {display:none;}
	.expanded SPAN.iconplus {display:none;}
	.expanded SPAN.iconminus {display:inline;}
	.loading SPAN.iconplus {visibility:hidden;}
	.loading SPAN.iconminus {visibility:hidden;}
	UL#tabs {float:left; width:100%; list-style:none; padding:0px; margin:0px; background-color:#CCC;}
	UL#tabs LI {float:left; list-style:none; padding:3px; margin:0px; background-color:#EEE; color:black; border:1px solid #BBB; border-bottom:1px solid #000; border-top:1px solid #FFF; font-size:9px;}
	UL#tabs LI A {color:black; text-decoration:none;}
	UL#tabs LI.active {background-color:#FFF;}
	DIV#tree {float:left; width:100%; height:100%; overflow:scroll; margin:0px -10px 0px 0px; padding:5px; border-top:1px solid #AAA;}
	
	</style>
	
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.2.min.js"></script>
	
	<script type="text/javascript">
	/**
	 * Cookie plugin
	 *
	 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
	 * Dual licensed under the MIT and GPL licenses:
	 * http://www.opensource.org/licenses/mit-license.php
	 * http://www.gnu.org/licenses/gpl.html
	 *
	 */
	jQuery.cookie = function(name, value, options) {
	    if (typeof value != 'undefined') { // name and value given, set cookie
	        options = options || {};
	        if (value === null) {
	            value = '';
	            options.expires = -1;
	        }
	        var expires = '';
	        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
	            var date;
	            if (typeof options.expires == 'number') {
	                date = new Date();
	                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
	            } else {
	                date = options.expires;
	            }
	            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
	        }
	        // CAUTION: Needed to parenthesize options.path and options.domain
	        // in the following expressions, otherwise they evaluate to undefined
	        // in the packed version for some reason...
	        var path = options.path ? '; path=' + (options.path) : '';
	        var domain = options.domain ? '; domain=' + (options.domain) : '';
	        var secure = options.secure ? '; secure' : '';
	        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
	    } else { // only name given, get cookie
	        var cookieValue = null;
	        if (document.cookie && document.cookie != '') {
	            var cookies = document.cookie.split(';');
	            for (var i = 0; i < cookies.length; i++) {
	                var cookie = jQuery.trim(cookies[i]);
	                // Does this cookie string begin with the name we want?
	                if (cookie.substring(0, name.length + 1) == (name + '=')) {
	                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
	                    break;
	                }
	            }
	        }
	        return cookieValue;
	    }
	};
	
	
	</script>
<script type="text/javascript">

(function($){

	$(function(){
	
		if(document.location.href.indexOf("tabid=history") >= 0) {
			$("#tree").append(TreeApplet.getLineItems(TreeApplet.jsonGetHistory()));
		}
		
		//Check the CTRL key is pressed
		$(window).keydown(function(event){
			if(event.keyCode == 17 || event.keyCode == 16) {
				TreeActions.ctrl = true;
			}
		}).keyup(function(event){
			if(event.keyCode == 17 || event.keyCode == 16) {
				TreeActions.ctrl = false;
			}
		})
		
		//Init
		$("#buildtree").each(function(){
			$("#tree").append(TreeApplet.getLineItems(TreeApplet.jsonLoadURL($(this).val())));
		})
		
		$("#tabs a").bind("click", function(e) { 
			var $tab = $(this).closest('LI');
			e.preventDefault();
			
			if(!$tab.hasClass('active')){
				$tab.addClass('active').siblings().removeClass('active');
			}
			
			if($(this).hasClass('history')){
				$("#tree").empty()
				//TODO
			} else {
				$.ajax({
				  cache:false,
				  url: '/cs/ContentServer?pagename=OpenMarket/Gator/UIFramework/LoadTab&tabid='+$(this).attr("rel"),
				  success: function(data) {
					$("#tree").empty().append(TreeApplet.getLineItems(TreeApplet.jsonLoadURL(data)));
				  }
				});	
			}
		})		
		
		
		$("#tree").bind("mousedown", function(e){e.preventDefault();}); 
		$("#tree").delegate(".selectable", "click", function(e) {
			var list = $("#tree");
			var listItems = $(".selectable", list);
			
			if(e.altKey){
				if($(this.parentNode).hasClass("ExecuteURL")) {
					parent.tab.new(this.innerHTML, $(this.parentNode).attr("dblclick"));
				}
			}
			
			if(!e.ctrlKey){
				listItems.removeClass("selected");
			}
			
			if(e.shiftKey) {
				var lastSelected = $(".last-selected", list);
				var between = [
					listItems.index(this),
					listItems.index(lastSelected)
				].sort();
				if(between[0] == -1) {
					between[0] = 0;
				}

				listItems.slice(between[0], between[1]+1)
					.toggleClass("selected", !lastSelected.hasClass("selected"));
			} else {
				$(this).toggleClass("selected");
			}
			
			listItems.removeClass("last-selected");
			$(this).addClass("last-selected");
			
			return false;
		});

	});

	var frames = { "XcelTree":{ "document":document} };

	//Expand or Close a Tree Node
	var TreeActions = {
		ctrl:false,
		loadURL:function(){
			var self = $(this);
			$parent = self.closest("LI.treenode");
			var nodeData = TreeApplet.getData(self);
			$.ajax({url:nodeData["LoadURL"],
				beforeSend:function(){
					if(!self.hasClass("loading")) {
						self.addClass("loading");
					}
				},
				success:function(data){
					var lineItems = TreeApplet.getLineItems(TreeApplet.jsonLoadURL(data))
					if(self.hasClass("expanded")) {
						$("UL.children", $parent).remove();
						self.removeClass("expanded");
						//$parent.append(lineItems);				
					} else {
						$parent.append(lineItems)
						self.addClass("expanded");
					}
					self.removeClass("loading");
				}
			})			
			return false;			
		},	
		selectable:function(){
			self = $(this);
			if(!TreeActions.ctrl) {
				$("SPAN.selectable").removeClass("selected");
			}			
			self.addClass("selected")			
		},
		executeURL:function(){
			self = $(this);
			TreeApplet.executeURL(self.attr("dblclick"))		
		}
	};
	
	var TreeApplet = window.TreeApplet = document.TreeApplet = {
		COOKIE_NAME:"TreeAppletHistory",
		createHistoryNode:function(nodeData, tab, makeTabActive) {
			var historyCookie = $.cookie(this.COOKIE_NAME) || "";
			var historyArr = historyCookie.split(":");
			
			//Remove current
			historyArr = $.map(historyArr, function(n, i){
				if(n != nodeData) {
					return n;
				}
			});
			
			historyArr.unshift(nodeData);
			$.cookie("TreeAppletHistory", historyArr.join(":"), { path: '/', expires: 10 }) + ":";
			
			//createHistoryNode('4c6162656c3a31363a46534949486f6d6550616765546578743a4465736372697074696f6e3a303a3a49443a33363a69643d313132353237343434373537352c6173736574747970653d436f6e74656e745f433a4578656375746555524c3a3135333a2f63732f436f6e74656e745365727665723f6e305f3d696425334431313235323734343437353735253243617373657474797065253344436f6e74656e745f43266f703d646973706c61794e6f6465264173736574547970653d436f6e74656e745f4326706167656e616d653d4f70656e4d61726b65742532464761746f7225324655494672616d65776f726b253246547265654f7055524c3a4f7055524c3a39313a2f63732f436f6e74656e745365727665723f4173736574547970653d436f6e74656e745f4326706167656e616d653d4f70656e4d61726b65742532464761746f7225324655494672616d65776f726b253246547265654f7055524c3a496d6167653a35363a2f63732f5863656c65726174652f4f4d547265652f54726565496d616765732f417373657454797065732f436f6e74656e745f432e6769663a4f4b416374696f6e3a373a496e73706563743a4f4b416374696f6e3a343a456469743a4f4b416374696f6e3a363a44656c6574653a4f4b416374696f6e3a363a5374617475733a526566726573684b65793a31333a313132353237343434373537353a454e443a333a454e443a','History',100);
			//if(parent.frames["XcelTree"].document.TreeApplet.createHistoryNode(nodeData, tab, makeTabActive)==0)
			return true;
		},
		jsonGetHistory:function(){
			var historyCookie = $.cookie(this.COOKIE_NAME) || "";
			var historyArr = historyCookie.split(":");

			historyArr = [];
			for(item in historyArr) {
				historyArr.push(DecodeUTF8(historyArr[item]));
			}
			
			//TODO
			console.log(historyArr);
			return TreeApplet.jsonLoadURL(historyArr.join("END:3:END"))
		},
		createSearchNode:function(path, nodeData, tab, makeTabActive) {
			//for (i=0;i<nodeData.length;i++)
	        //parent.frames["XcelTree"].document.TreeApplet.createSearchNode(path, nodeData[i], tab, makeTabActive);
			return true;
		},
		clearHistory:function(tab) {
			$.cookie(this.COOKIE_NAME, null, { path: '/', expires: 10 });

			//arent.frames["XcelTree"].document.TreeApplet.clearHistory(tab);
			return true;
		},
		gotoSelectionNeighbor:function(tab, action) {
			//alert(parent.frames["XcelTree"].document.TreeApplet.gotoSelectionNeighbor(tab, action));
			return true;
		},
		selectNode:function(tab, path) {
			//parent.frames["XcelTree"].document.TreeApplet.selectNode(tab, path);
			return true;
		},
		exportSelections:function() {
		    //Fix decode method in XcelAction frame
			if(parent.frames["XcelAction"]) {
				window.fatwireDecodeUTF8 = parent.frames["XcelAction"].DecodeUTF8;
				parent.frames["XcelAction"].DecodeUTF8 = UTF8.decode; 
			}		

		    /* This
		     * id%3D1114083739549%2Cassettype%3DProduct_C,0:id%3D1114083739596%2Cassettype%3DProduct_C,1;
		     * From Applet		    
		     * id%3d1125274447603%2cassettype%3dAdvCols,465349494c61746573744e657773:id%3d1124978777055%2cassettype%3dAdvCols,46534949486f744974656d73:id%3d1125274447575%2cassettype%3dContent_C,46534949486f6d655061676554657874:
			 */
			
			var self = this;
		    var selectedNodes = []
		    $("LI.treenode SPAN.selected").each(function(i,e){
		    	selectedNodes.push(self.getData(e));
		    });
		    
		    return $.map(selectedNodes, function(node,i){
		    	return escape(node["ID"]) + "," + UTF8.encode(node["Label"]);
		    }).join(":") + ":";
		    
		},
		updateTrees:function(keys) {
			//eg 'Self:1235540326996;Parent:1235540327017'
			keys = eval('{"' +  keys.replace(":", '":"').replace(";", '","') + '"}');
		},
		getData:function(element) {
			return (
					$(element).is("LI.treenode") 
					? $(element) 
					: $(element).closest("LI.treenode")
				).data("TreeNode");
		},
		setData:function(element, data) {
			return $(element).data("TreeNode", data);
		},
		executeURL:function(url){
			parent.frames["XcelAction"].location.href = url;
		},
		jsonLoadURL:function(data){
			
			//Status:4:fail:  FailURL:85:/cs/ContentServer?pagename=OpenMarket%2FXcelerate%2FActions%2FSecurity%2FTimeoutError: END:3:END: 
			//Label:5:Sites: Description:12:Manage Sites: ID:11:adhoc=Sites: LoadURL:106:/cs/ContentServer?op=load&NodeType=Sites&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: ExecuteURL:81:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FSiteFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:44:/cs/Xcelerate/OMTree/TreeImages/siteplan.gif: RefreshKey:5:Sites: END:3:END:  Label:10:AssetMaker: Description:10:AssetMaker: ID:16:adhoc=AssetMaker: LoadURL:103:/cs/ContentServer?op=load&NodeType=AssetMaker&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree: ExecuteURL:87:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FAssetMakerFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:40:/cs/Xcelerate/OMTree/TreeImages/Memo.gif: RefreshKey:10:AssetMaker: END:3:END:  Label:17:Flex Family Maker: Description:17:Flex Family Maker: ID:21:adhoc=FlexFamilyMaker: LoadURL:116:/cs/ContentServer?op=load&NodeType=FlexFamilyMaker&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: ExecuteURL:91:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FFlexAssetMakerFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:40:/cs/Xcelerate/OMTree/TreeImages/Memo.gif: RefreshKey:11:FamilyMaker: END:3:END:  Label:11:Asset Types: Description:46:Categories, Associations and Revision Tracking: ID:16:adhoc=AssetTypes: LoadURL:111:/cs/ContentServer?op=load&NodeType=AssetTypes&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: ExecuteURL:86:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FAssetTypeFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:40:/cs/Xcelerate/OMTree/TreeImages/Memo.gif: RefreshKey:10:AssetTypes: END:3:END:  Label:10:Publishing: Description:10:Publishing: ID:13:adhoc=Publish: LoadURL:111:/cs/ContentServer?op=load&NodeType=Publishing&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:44:/cs/Xcelerate/OMTree/TreeImages/Delivery.gif: END:3:END:  Label:6:Search: Description:6:Search: ID:12:adhoc=Search: LoadURL:99:/cs/ContentServer?op=load&NodeType=Search&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree: OKAction:7:refresh: Image:42:/cs/Xcelerate/OMTree/TreeImages/search.gif: RefreshKey:6:Search: END:3:END:  Label:7:Sources: Description:7:Sources: ID:13:adhoc=Sources: LoadURL:100:/cs/ContentServer?op=load&NodeType=Sources&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree: ExecuteURL:83:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FSourceFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:42:/cs/Xcelerate/OMTree/TreeImages/Source.gif: RefreshKey:7:Sources: END:3:END:  Label:13:User Profiles: Description:13:User Profiles: ID:19:adhoc=User Profiles: ExecuteURL:102:/cs/ContentServer?_profilemgmt_=users&action=ask&pagename=OpenMarket%2FXcelerate%2FAdmin%2FUser%2FList: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:44:/cs/Xcelerate/OMTree/TreeImages/Personal.gif: END:3:END:  Label:5:Roles: Description:5:Roles: ID:11:adhoc=Roles: LoadURL:104:/cs/ContentServer?op=load&NodeType=Acl&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: ExecuteURL:87:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FRolesAdminFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:41:/cs/Xcelerate/OMTree/TreeImages/Roles.gif: RefreshKey:5:Roles: END:3:END:  Label:16:Workflow Actions: Description:16:Workflow Actions: ID:13:adhoc=Actions: LoadURL:122:/cs/ContentServer?op=load&Node=Actions&NodeType=Workflow&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=2: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:44:/cs/Xcelerate/OMTree/TreeImages/wfaction.gif: END:3:END:  Label:18:Timed Action Event: Description:18:Timed Action Event: ID:22:adhoc=TimedActionEvent: ExecuteURL:101:/cs/ContentServer?action=view&pagename=OpenMarket%2FXcelerate%2FAdmin%2FWorkflowTimedActionEventFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:43:/cs/Xcelerate/OMTree/TreeImages/wftimed.gif: END:3:END:  Label:5:Email: Description:5:Email: ID:11:adhoc=Email: LoadURL:120:/cs/ContentServer?op=load&Node=Email&NodeType=Workflow&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=2: ExecuteURL:92:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FWorkflowSubjectFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:43:/cs/Xcelerate/OMTree/TreeImages/wfemail.gif: RefreshKey:14:Workflow_Email: END:3:END:  Label:9:Functions: Description:9:Functions: ID:15:adhoc=Functions: LoadURL:124:/cs/ContentServer?op=load&Node=Functions&NodeType=Workflow&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=2: ExecuteURL:93:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FWorkflowFunctionFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:46:/cs/Xcelerate/OMTree/TreeImages/wffunction.gif: END:3:END:  Label:10:Start Menu: Description:10:Start Menu: ID:15:adhoc=StartMenu: LoadURL:110:/cs/ContentServer?op=load&NodeType=StartMenu&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: ExecuteURL:82:/cs/ContentServer?op=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FStartMenuFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:45:/cs/Xcelerate/OMTree/TreeImages/startmenu.gif: END:3:END:  Label:4:Tree: Description:11:Manage Tree: ID:14:adhoc=TreeTabs: ExecuteURL:86:/cs/ContentServer?action=list&pagename=OpenMarket%2FXcelerate%2FAdmin%2FTreeTabManager: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:44:/cs/Xcelerate/OMTree/TreeImages/TreeTabs.gif: END:3:END:  Label:17:Clear Assignments: Description:17:Clear Assignments: ID:22:adhoc=ClearAssignments: ExecuteURL:120:/cs/ContentServer?pagename=OpenMarket%2FXcelerate%2FAdmin%2FMonitor%2FShowAdminWorkListFront&ClearTarget=ShowAssignments: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:41:/cs/Xcelerate/OMTree/TreeImages/clear.gif: END:3:END:  Label:15:Clear Checkouts: Description:15:Clear Checkouts: ID:20:adhoc=ClearCheckOuts: ExecuteURL:118:/cs/ContentServer?pagename=OpenMarket%2FXcelerate%2FAdmin%2FMonitor%2FShowAdminWorkListFront&ClearTarget=ShowCheckouts: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:41:/cs/Xcelerate/OMTree/TreeImages/clear.gif: END:3:END:  Label:31:Content Server Management Tools: Description:31:Content Server Management Tools: ID:13:adhoc=CSAdmin: LoadURL:108:/cs/ContentServer?op=load&NodeType=CSAdmin&pagename=OpenMarket%2FGator%2FUIFramework%2FLoadAdminTree&Depth=1: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:41:/cs/Xcelerate/OMTree/TreeImages/tools.gif: END:3:END:  Label:6:Locale: Description:6:Locale: ID:13:adhoc=CSAdmin: ExecuteURL:86:/cs/ContentServer?action=details&pagename=OpenMarket%2FXcelerate%2FAdmin%2FLocaleFront: OpURL:101:/cs/ContentServer?AssetType=Variables.AssetType&pagename=OpenMarket%2FGator%2FUIFramework%2FTreeOpURL: OKAction:7:refresh: Image:41:/cs/Xcelerate/OMTree/TreeImages/tools.gif: END:3:END: 
			
			data = data.replace(/(\n)|(\s\s)/g, "");
			var nodeStringArray = data.split("END:3:END");
			
			var json = [];
			var node;
			
			var reAll = /([A-Za-z]+):[0-9]+:([^:]+)?:/g
			var re = /([A-Za-z]+):[0-9]+:([^:]+)?:/
			
			for(item in nodeStringArray){
				var nodeString = nodeStringArray[item];
				
				var nodeArguments = nodeString.match(reAll);
				for(itemA in nodeArguments) {
					
					var arg = nodeArguments[itemA].match(re)
					if(arg) {
						if(!node) { node = {} }
						if(arg[1] == "Status" && arg[2] == "fail") { return [] }
						node[arg[1]] = arg[2];
					}
				}
				
				if(node) {
					json.push(node);
					node = undefined;
				}
			}
			
			return json;
		},
		num:123456,
		getLineItems:function(data){
			lineItems = "";
			
			$ul = $('<ul class="children"></ul>');
			
			for(item in data) {
				var node = data[item];
				
				var id = (node["RefreshKey"] && !document.getElementById(node["RefreshKey"]) 
					? node["RefreshKey"] 
					: node["ID"].replace(/=/g, "-"));
					
				$li = $('<li class="treenode"></li>');
				$li.attr("id", id);
				$li = this.setData($li, node);
				
				markup = "";
				if(node['LoadURL']) {
					markup += '<a class="LoadURL" rel="' + id + '" id="LoadURL_' + id + '" href="' + node['LoadURL'] + '" ><span class="icon iconplus">[+]</span><span class="icon iconminus">[--]</span></a> ';
				} else {
					markup += '<span class="icon">&nbsp;&nbsp;--</span>';
				}
				
				if(node['Image']) {
					markup += '<img src="' + node['Image'] + '" height="18" width="18" />';
				}
	
				if(node['ExecuteURL']) {
					markup += '<span class="ExecuteURL" rel="' + id + '" id="ExecuteURL_' + id + '" dblclick="' + node['ExecuteURL'] + '" ><span class="selectable">' + (node['Label'] ? node['Label'] : node['Description']) + '</span></span>';
				} else {
					markup += '<span class="selectable">' + (node['Label'] ? node['Label'] : node['Description']) + '</span>';
				}
				
				$li.append(markup)
				$ul.append($li);
			}
			
			$("A.LoadURL", $ul).click(TreeActions.loadURL);
			$("SPAN.selectable", $ul).click(TreeActions.selectable);
			$("SPAN.ExecuteURL", $ul).bind("dblclick", TreeActions.executeURL);
			
			return $ul;
			
		}
	}
	
})(jQuery);



/*
* From OpenMarket/Xcelerate/UIFramework/SetTreeVariablesOMTree
*/

function DecodeUTF8(encoded)
{
   var i=0;
   var currentUnicode=0;
   var UnicodeString = new Array();
   var UnicodeIndex = 0;
   
   var currentState = "Start";

   for (i = 0; i<encoded.length;i+=2) {
       var twochars = encoded.substr(i,2);
       var currentByte = parseInt(twochars,16);
       
       // utf-8 representation may have up to 4 bytes per character
       if (currentState=="Start") {
           if ((currentByte & 0x80) != 0) {
               // if 1st 3 bits are 110 then 2 bytes
               if ((currentByte>>5) == 0x06) {
                   // 2 bytes - want 3 bits after 0xC0 as low 3 bits in first unicode byte
                   currentUnicode = (currentByte & 0x1C)>>2;
                   
                   // 2 remaining bits of byte 1 become low bits of currentUnicode
                   currentUnicode = currentUnicode << 2;
                   currentUnicode = currentUnicode | (currentByte & 0x03);
                   currentState = "Done";
               }
               // if first 4 bits are 1110 then 3 bytes
               else if ((currentByte>>4) == 0x0E) {
                       currentUnicode = (currentByte & 0x0F);
                       currentState = "Middle1";
               }
               // if first 5 bits are 11110 then 4 bytes
               else if ((currentByte>>3) == 0x1E) {
                       currentUnicode = (currentByte & 0x07);
                       currentState = "Middle2";
               }
           }
           else
           {
               UnicodeString[UnicodeIndex] = currentByte;
               UnicodeIndex++;
           }
       }
       else if (currentState=="Done") {
           currentUnicode = currentUnicode << 6;
           currentUnicode = currentUnicode | (currentByte & 0x3F);
           UnicodeString[UnicodeIndex] = currentUnicode;
           UnicodeIndex++;
           currentState = "Start";
       }
       else if (currentState=="Middle1") {
           currentUnicode = currentUnicode << 6;
           currentUnicode = currentUnicode | (currentByte & 0x3F);
           currentState = "Done";
       }
       else if (currentState=="Middle2") {
           currentUnicode = currentUnicode << 6;
           currentUnicode = currentUnicode | (currentByte & 0x3F);
           UnicodeString[UnicodeIndex] = currentUnicode;
           UnicodeIndex++;
           currentState = "Middle1";
       }

   }
   var StringCode = "String.fromCharCode(";
   StringCode += UnicodeString[0];
   for (var y = 1; y < UnicodeIndex; y++) {
       StringCode+=","+UnicodeString[y];
   }
   StringCode += ");";
   
   return(eval(StringCode));
}

/**
*
*  UTF-8 data encode / decode
*  http://www.webtoolkit.info/
*
**/
 
var UTF8 = {
 
	// public method for url encoding
	encode : function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
 
		for (var n = 0; n < string.length; n++) {
 
			var c = string.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
	},
 
	// public method for url decoding
	decode : function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;
 
		while ( i < utftext.length ) {
 
			c = utftext.charCodeAt(i);
 
			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
 
		}
 
		return string;
	}
 
}


</script>
</head>
<body>

<%
IList sql;
if(Utilities.goodString(ics.GetSSVar("currentpubACLs"))) {

	String roles = Utilities.replaceAll(ics.GetSSVar("currentpubACLs"), ",", "' OR cs_rolename = '");
	%><ics:sql sql='<%="SELECT tt.id, tt.title FROM TreeTabs tt WHERE tt.id IN (SELECT ownerid FROM TreeTabs_Sites WHERE pubid = "+ics.GetSSVar("pubid")+" OR pubid = 0 OR pubid IS NULL) AND tt.id IN (SELECT cs_ownerid FROM TreeTabs_Roles WHERE cs_rolename IS NULL OR cs_rolename = '"+roles+"')"%>' listname="sql" table="TreeTabs" limit="5000" /><%
	
	sql = ics.GetList("sql", false);
	if(sql != null && sql.hasData())
	{
		out.print("<ul id=\"tabs\">");

		String className = "";

		for(int i = 0; sql!=null && i < sql.numRows(); i++)
		{
			sql.moveTo(i+1);

			if(!Utilities.goodString(ics.GetVar("tabid"))) {
				ics.SetVar("tabid", sql.getValue("id"));
			}

			className = "";
			if(sql.getValue("id").equals(ics.GetVar("tabid")))
				className = " class=\"active\"";
			out.print("<li"+className+"><a rel=\"" + sql.getValue("id") + "\" href=\"ContentServer?pagename=MockTreeApplet&amp;tabid=" + sql.getValue("id") + "\">" + sql.getValue("title") + "</a></li>");		

		}
		
		className = "";
		if("history".equals(ics.GetVar("tabid")))
			className = " class=\"active\"";
		out.print("<li"+className+"><a class='history' href=\"ContentServer?pagename=MockTreeApplet&amp;tabid=history\">History</a></li>");		
		
		out.print("</ul>");

	}
	
	if(Utilities.goodString(ics.GetVar("tabid")) && !"history".equals(ics.GetVar("tabid"))) {

		%><textarea id="buildtree" style="display:none;"><%
		
			%><ics:callelement element="OpenMarket/Gator/UIFramework/LoadTab" /><%				
		
		%></textarea><%

		%><div id="tree"></div><% 
	}

} else { 
	%><p>Not logged in</p><%
}
%><div id="mask" style="position:absolute; left:-9999px; top:0px;"></div>
</body>
</html>
</cs:ftcs>