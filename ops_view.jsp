<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Archive &amp; Purge</title>

<link href="css/htmlcomponents.css" media="screen" type="text/css" rel="stylesheet">
<link href="css/pacomponents.css" media="screen" type="text/css" rel="stylesheet">
<link href="css/app.css" media="screen" type="text/css" rel="stylesheet">
<link href="css/global.css" media="screen" type="text/css" rel="stylesheet">

<link href="css/tradestone.css" media="screen" type="text/css" rel="stylesheet">
<link href="kendo/css/kendo.common-material.css" rel="stylesheet">
<link href="kendo/css/kendo.material.tradestone.css" rel="stylesheet">
	
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="js/comfunc.js" type="text/javascript"></script>

<!-- We need to define userDocIDs here because it uses JSTL and mainPageContext because they cannot be loaded in the external JS file -->
<script type="text/javascript">
	//Doc IDs listed in configuration file
	var userDocIDs = [];
	<c:forEach var="tDoc" items="${docInfo}">
		<c:if test="${tDoc.userChecked == true}">
	  		userDocIDs.push("${tDoc.docID}");
		</c:if>
	</c:forEach>
	
	var mainPageContext = "${pageContext.request.contextPath}";
</script>

<script src="js/mainOps.js" type="text/javascript"></script>	
<script src="js/statusUIUpdates.js" type="text/javascript"></script>

<style type = "text/css">

   button.rounded {
   	   background-color: #ab3fb1;
       border-color: #ab3fb1;
       color: #fff;
       background-position: 50% 50%;
   }
   .btn-wrap button {
       font-size: 12px;
       margin: 0 20px 0 0;
       min-width: 100px;
   }
   	.global-header-new::after {
	    background: rgba(0, 0, 0, 0) linear-gradient(to right, white 1%, #872c8c 37%, #b9245e 67%, #e31d3c 100%) repeat scroll 0 0;
	    content: "";
	    display: block;
	    height: 8px;
	    position: relative;
    }
    input[type=radio], input[type=checkbox] {
    	border: 0;
    }

</style>
<script type="text/javascript">	
	
	$.ajaxSetup({ 
		cache: false 
	});

	$(document).ready(function () {
		clearText();
		setDBType();
		numberInputMask("#txtPortNumber");
	});
	
	function setDBType() {
		if (document.getElementById("rdoOracle") == null)
			return;
		
		var tType = null;
		
		<c:if test="${not empty dstDBType}">
			tType = "${dstDBType}";
		</c:if>
				
		if (tType != null) {
			if (tType === "oracle")
				document.getElementById("rdoOracle").checked = true;
			else if (tType === "db2")
				document.getElementById("rdoDB2").checked = true;
			else if (tType === "sqlServer")
				document.getElementById("rdoSQLServer").checked = true;
			else
				document.getElementById("rdoOracle").checked = true;
			
		} else {
			document.getElementById("rdoOracle").checked = true;
		}	
	}

</script>

</head>
<body>

<table id="tssHeader" style="width: 100%; margin-bottom: 5px; margin-top: 5px;">
	<tbody>
		<tr class="ts-inline-list">
			<td align="left" ><img src="images/dashtopnew.bmp"></td> 
			<td align="right" id="logout" style="cursor: pointer; padding-right: 30px; font-size:17px;" onclick="btnLogout();">Logout</td>
			</tr>
	</tbody>
</table>

<table style="clear: both; border-collapse: collapse; margin-top: 3px; width:100%">
	<tbody>
		<tr valign="middle" align="left" class="tableContentViewerMain">
			<td>
				<div id="Tabs">
					<table style="clear: both; border-collapse: collapse;">
						<tbody>
							<tr id="Tabsrow" valign="middle" align="left">
								<td class="clsTabCell" align="center"></td>
								<td class="clsTabSpacer"></td>
								<td id="tab_configured" class="clsCenterTabOnfocus" valign="middle" nowrap="nowrap" align="left" onclick="showArchivePurge('tab_configured')">
									<label class="clsTextLabelNormalVTop" style="cursor:pointer;"> Configured </label>
								</td>
								<td class="clsTabSpacer"></td>
								<td id="tab_all" class="clsCenterTabOfffocus" valign="middle" nowrap="nowrap" align="left" onclick="showArchivePurge('tab_all')">
									<label class="clsTextLabelNormalVTop" style="cursor:pointer; padding-left:5px; padding-right:5px">  All  </label>
								</td>
								<td class="clsTabSpacer"></td>
								<td id="tab_status" class="clsCenterTabOfffocus" valign="middle" nowrap="nowrap" align="left" onclick="showStatus()">
									<label class="clsTextLabelNormalVTop" style="cursor:pointer;"> Status </label>
								</td>
								<td class="clsTabSpacer"></td>
							</tr>
						</tbody>
						
					</table>
				
				</div>
			</td>
		</tr>
	</tbody>
</table>
<div class="global-header-new"></div>

<div id="LOCK" style="background-color: rgb(255, 255, 255); overflow: auto; margin-top: 100px; margin-left: 150px; position: absolute; top:0; bottom:0; left:0; right:0;">
	
	<div id="content_status" class="unorderedBody" style="display: none">
		<div id="preprint" class="preload" style="padding-left:400px; position: absolute;">
			<div class="bubblingG" style="position: relative; visibility: visible;">
 				<span id="bubblingG_1"></span>
 				<span id="bubblingG_2"></span>
 				<span id="bubblingG_3"></span>
 			</div>
		</div>
		<table class="progress-container" style="margin: 0px auto;">
			<tr>
				<td align="center">
					<div id="currentProcess"></div>
				</td>
			</tr>
			<tr>
				<td align="center">
			 		<!-- <div class="progress-bar" id="progress-bar">
			 			<span class="progress-inner"></span> 
			 			<div id="loading-bar" style="position:absolute;">
				 			<div class="bubblingG" style="position: relative; visibility: visible; top: -50px; left:75%;">
				 				<span id="bubblingG_1"></span>
				 				<span id="bubblingG_2"></span>
				 				<span id="bubblingG_3"></span>
				 			</div>
			 			</div>
					</div> -->
				</td>
			</tr>
			<tr>
				<td align="center"><div id="progress"></div></td>
			</tr>
		</table>
	
		<div id="operationList" class="progress-operationList" style="width:875px;"></div>
		
	</div>
	
	<div id="content_archivePurge" style="display: inline-block;">
		<table style="text-align:left;">
			<tr>
				<td>
					<table style="text-align:left;" class="mainTable">
						<tbody>
							<tr>
							  <td valign="top">
				
								<div class="dashMultiOuter" style="width:740px">
				                  <div id="dashTitleRight" style="height:35px">
					                  <img id="configChange" src="images/settings_icon.png" alt="Select custom configuration file" style="width:27px; height:27px; cursor:pointer;">				                  	
				                  </div>
				                  <div id="dashTitleLeft" style="height:35px;">Documents</div>
												  
						  	        <div class="dashInnerRight" style="width:360px; height:435px; overflow:hidden;">
					
						  	         <form id="frmQuery">
							  	        <table style="text-align:center;">
										  
						  	          	  <tr>
						  	        		<td style="text-align:left;">Search from all checked tables where</td>  	
						  	          	  </tr>
						  	          	  <tr>
						  	          	    <td>
						  	          	      <textarea class="roundedBox" id="txtWhereClause" name="txtWhereClause" style="resize: none; width:335px; height:150px;"
						  	          	      onchange="whereClauseChange()" onfocus="whereClauseFocus()" onblur="whereClauseLostFocus()">Enter where clause here...</textarea>
						  	            	</td>
						  	              </tr> 
						  	              <tr>
						  	          		<td>
						  	          		<br>

						  	         		<div class="dashOuter" style="width:360px; margin: 0 auto;">
						  	         			<div id="dashTitle">Destination</div>
						  	         			<div class="dashInner" style="width:auto; height:auto; overflow-y: hidden">
						  	         			
						  	         			<table style="text-align:center;">
												    <tr>
												      <td style="text-align:left;">
												      	<label><input type="radio" name="rdoArchiveFormat" id="rdoJson" value="JSON" checked="checked">JSON</label>
												        <br>
												        <label><input type="radio" name="rdoArchiveFormat" id="rdoXml" value="XML">XML</label>
												      </td>
												      <td>
												    	<pre>    </pre>
												      </td>
												      <td>

												        <table>
												          <tr>
												            <td style="text-align:left;">User ID: </td>
												            <td style="text-align:right;"><input type="text" name="userID" id="txtUserID" value="${dstUserID}"></td>
												  		  </tr>
												  		  <tr>
												  		    <td style="text-align:left;">Password: </td>
												  		    <td style="text-align:right;"><input type="password" name="password" id="txtPassword" value="${dstPassword}"></td>
												  		  </tr>
												  		  <tr>
												  		    <td style="text-align:left;">DB Server Name: </td>
												  		    <td style="text-align:right;"><input type="text" name="serverName" id="txtServerName" value="${dstServerName}"></td>
												  		  </tr>
												  		  <tr>
												  		    <td style="text-align:left;">Port Number: </td>
												  		    <td style="text-align:right;"><input type="text" name="portNumber" id="txtPortNumber" onblur="verifyPortValid(this.id)" value="${dstPortNumber}"></td>
												  		  </tr>
												  		  <tr>
												  		    <td style="text-align:left;">Database Name: </td>
												  		    <td style="text-align:right;"><input type="text" name="databaseName" id="txtDatabaseName" value="${dstDatabaseName}"></td>
												  		  </tr>
												  		  <tr>
												  		    <td colspan="2">
												  		      <table>
												  		        <tr>
												  				  <td>
												  				  	<label>
												  				  		<input type="radio" name="rdoDBType" id="rdoOracle" value="oracle">
												  				  		Oracle
												  				  	</label>
												  				  </td>
												  				  <td>
												  				  	<label>
												  				  		<input type="radio" name="rdoDBType" id="rdoSQLServer" value="sql server">
												  				  		SQL Server
												  				  	</label>
												  				  </td>
																  <td>
																  	<label>
																  		<input type="radio" name="rdoDBType" id="rdoDB2" value="db2">
																  		DB2
																  	</label>
																  </td>
																  <!-- <td><input type="radio" name="rdoDBType" id="rdoMySQL" value="mysql">My SQL</td>-->
												  				 </tr>
												  		      </table>
															</td>
												          </tr>
												        </table>
	
												  		<input type="checkbox" name="persistToDB" id="chkPersistToDB" checked="checked"
												  			style="position:absolute; left:-9999px; width:1px; height:1px;" tabindex="-1">
												      </td>
												    </tr>
												  </table> 
	
						  	         			</div>
						  	         		
						  	         		</div>
			  
							 				  </td>
							 				</tr>

							  	          </table>	        
						
									    </form>
								    
						  	        </div>
					  	        
					  	        	<div id="checkTableButtons" class="dashInnerLeft" style="width: 330px;">
					  	        		<table>
					  	        			<tbody>
					  	        				<tr>
					  	        					<td>Select </td>
									  	        	<td><pre><label style="cursor:pointer;" onclick="setTableChecks(true)"><font color="blue"> ALL </font></label></pre></td>
								  	        		<td><pre><label style="cursor:pointer;" onclick="setTableChecks(false)"><font color="blue"> NONE </font></label></pre></td>
								  	        	</tr>
					  	        			</tbody>
					  	        		</table>
					  	        		
							  	        <div id="allTableContent" style="height: 395px; overflow-y: scroll">
							  	    	  <table>
							  	      	  	<tr>
							  	        	  <td>
						  	      	  			  <ul style="padding-left:1.2em;">
													  <c:forEach var="tDoc" items="${docInfo}">													      
														  <li id="lstDocID${tDoc.docID}" style="display:list-item;">
														  	<c:choose>
														  		<c:when test="${tDoc.archiveWaiting == true}">
														  			<label id="lblDocID${tDoc.docID}" class="waitingArchive">
														  				<input class="waitingArchive" id="chkDocID${tDoc.docID}" type="checkbox" style="margin-right:5px;" value="${tDoc.docID}">	${tDoc.description}
														  			</label>
														  		</c:when>
														  		<c:otherwise>
														  				<label id="lblDocID${tDoc.docID}">
														  					<input id="chkDocID${tDoc.docID}" type="checkbox" style="margin-right:5px;" value="${tDoc.docID}"> ${tDoc.description}
														  				</label>												  			
														  		</c:otherwise>
														  	</c:choose>
												          </li>
						
											 	  	  </c:forEach>
											 	  </ul>
							  	      		  </td>
							  	      		</tr>
							  	      	  </table>
							  	      	</div>
									</div>
								</div>
							  
							  </td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>

			<tr valign="middle" align="left" style="margin-top: 10px">
				<td align="center">
					<table>
						<tbody>
							<tr>
								<td><br></td>
							</tr>
							<tr valign="middle" align="left">
								<td> </td>
								<td> </td>
								<td class="btn-wrap" valign="top" align="center">
									<button type="button" class="k-button k-primary rounded" id="_archiveBtnbtnCtr" value="Archive" 
									onclick="btnArchiveClick();" style="height:25px; padding-top:5px;">Archive</button>
								</td>
								<td class="clsToolBarButtonRightPadding"></td>
								<td>   </td>
								<td> </td>
								<td class="btn-wrap" valign="top" align="center">
									<button type="button" class="k-button k-primary rounded" id="_purgeBtnbtnCtr" value="Purge" 
									onclick="btnPurgeClick();" style="height:25px; padding-top:5px;">Purge</button>
								</td>
								<td class="clsToolBarButtonRightPadding"></td>
								<td>   </td>
								<td> </td>
								<td class="btn-wrap" valign="top" align="center">
									<button type="button" class="k-button k-primary rounded" id="_archivePurgeBtnbtnCtr" value="ArchivePurge" 
									onclick="btnArchivePurgeClick();" style="height:25px; padding-top:5px;">Archive &amp; Purge</button>
								</td>
							</tr>
							<tr>
								<td colspan="11"><br></td>
							</tr>
							<tr id="finishArchiveBlock" valign="middle" align="left" style="display:none;">
								<td colspan="11" align="center">
									<br>
									<table>
										<tr valign="middle" align="left">
											<td class="btn-wrap" valign="top" align="center">
												<button type="button" class="k-button k-primary rounded" id="_finishArchiveBtnbtnCtr" value="FinishArchive"
												onclick="btnFinishArchiveClick();" style="height:25px; padding-top:5px;">Complete Unfinished Archives</button>
											</td>
										</tr>									
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>

		</table>
	
	</div>
	
</div>
		
</body>
</html>