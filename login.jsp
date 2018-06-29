<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Database Login</title>

	<link href="css/app.css" media="screen" type="text/css" rel="stylesheet">
	<link href="css/global.css" media="screen" type="text/css" rel="stylesheet">
	<link href="kendo/css/kendo.common-material.css" rel="stylesheet">
	<link href="kendo/css/kendo.material.tradestone.css" rel="stylesheet">
	<link href="css/tradestone.css" media="screen" type="text/css" rel="stylesheet">
	
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="js/comfunc.js" type="text/javascript"></script>
	
	<style type="text/css">
	    @import url(https://fonts.googleapis.com/css?family=Lato:300,400,700,900);
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:600,400);
        h2 {
            display: block;
            font-size: 1.5em;
            -webkit-margin-before: 0.83em;
            -webkit-margin-after: 0.83em;
            -webkit-margin-start: 0px;
            -webkit-margin-end: 0px;
            font-weight: bold;
        }
        .login-wrap {
            margin: 100px auto 0;

        }

        .login-wrap .copy-wrap, .login-wrap .login-form {
            display: inline-block;
            position: relative;
            text-align: left;
        }

        form .container {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .k-textbox
        {
            width:214px;
        }

        .login-wrap .copy-wrap {
            top: -155px;
        }

        form .container li {
            margin-bottom: 20px;
        }


        .btn-wrap button {
            margin: 0 20px 0 0;
            min-width: 120px;
        }

	</style>

<script type="text/javascript">
var $j = jQuery;

$j(document).ready(function () {
	numberInputMask("#txtPortNumber");
	<c:if test="${empty connStat}">
		checkConfigLoaded();
	</c:if>
	
	<c:choose>
		<c:when test="${not empty dbType}">
			setDBType("${dbType}");
		</c:when>
		<c:otherwise>
			setDBType(null);		
		</c:otherwise>
	</c:choose>

});

$.ajaxSetup({ 
	cache: false 
});

function setDBType(tType) {
		
	if (tType) {
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

function resetForm() {
	document.getElementById("frmDBConnect").reset();
	document.getElementById("txtConnStat").value = "";
}

// Check if config.xml has user login loaded
function checkConfigLoaded() {
	var connection_data = {
			action : "configLogin"
	}
	
	$.ajax({
		url:"${pageContext.request.contextPath}/Connect",
		type: "POST",
		data: {postedData: connection_data},
		dataType: "json",
		success: function(data, textStatus, jqXHR) {
			if (data.success == true) {
				// Connection succeeded, load params to form and submit
				document.getElementById("userID").value = data.userID;
				document.getElementById("password").value = data.password;
				document.getElementById("serverName").value = data.serverName;
				document.getElementById("txtPortNumber").value = data.portNumber;
				document.getElementById("databaseName").value = data.databaseName;
				setDBType(data.dbType);
			}
		}
	});
}

function formSubmit() {
	
	// Verify data
	var valEmpty = false;
	var userId = $("input[name=userID]").val();		
	var password = $("input[name=password]").val();		
	var serverName = $("input[name=serverName]").val();		
	var portNumber = $("input[name=portNumber]").val();		
	var databaseName = $("input[name=databaseName]").val();
	var dbType =$("input[name=rdoDBType]:checked").val();

	if (!userId) {
		alert("User ID field is empty. Please enter a valid User ID to continue with archive.");
	    valEmpty = true;
	} else if (!password) {
		alert("Password field is empty. Please enter a valid password to continue with archive.");
		valEmpty = true;
	} else if (!serverName) {
		alert("Server name field is empty. Please enter a valid sesrver name to continue with archive.");
		valEmpty = true;
	} else if (!portNumber) {
		alert("Port number field is empty. Please enter a valid port number to continue with archive.");
		valEmpty = true;
	} else if (!databaseName) {
		alert("Database name field is empty. Please enter a valid database name to continue with archive.");
		valEmpty = true;
	} else if (!dbType) {
		alert("Database type (Oracle, DB2, or SQL Server) was not specified. Please choose one to continue with archive.");
		valEmpty = true;
	}
		
	if (!valEmpty) {
		document.getElementById("btnConnect").click();
	}
}
</script>
	
</head>
<body>
<div id="LOCK" style="overflow: auto; position: absolute; top:0; bottom:0; left:0; right:0;">

	<div class="login-wrap">
		<div class="copy-wrap">
			<h1 class="logo" style="top: -200px;">
				<img style="width: 600px;" border="0" align="middle" src="images/logo.svg">
			</h1>
			<h2 style="position: absolute; top: -75px; font-size:18px;">Archive &amp; Purge</h2>
			<br>
			<div style="position: absolute; top: -25px; width: 500px; color:#ED1C70">${connStat}</div>
		</div>

		<form id="frmDBConnect" class="login-form lbl-block" style="border-left-width: 3px;" action="${pageContext.request.contextPath}/Connect"  method="post">
			<input type="hidden" value="" name="method">
			<input type="hidden" value="" name="css">
			<h3 class="title">Log in</h3>
			<ul class="container">
				<li>
					<label for="userID">User ID</label>
					<input class="k-textbox" type="text" name="userID" id="userID" value="${userID}">
				</li>
				<li>
					<label for="password">Password</label>
					<input class="k-textbox" type="password" name="password" id="password">
				</li>
				<li>
					<label for="serverName">Database Server Name/IP</label>
					<input class="k-textbox" type="text" name="serverName" id="serverName" value="${serverName}">
				</li>
				<li>
					<label for="portNumber">Port Number</label>
		  			<input class="k-textbox" type="text" name="portNumber" id="txtPortNumber" value="${portNumber}" onblur="verifyPortValid(this.id)">
		  		</li>
		  		<li>
		  			<label for="databaseName">Database Name</label>
		  			<input class="k-textbox" type="text" name="databaseName" id="databaseName" value="${databaseName}">
		  		</li>
		  		<li>
			  	  <table>
					<tr>
					  <td><input type="radio" name="rdoDBType" id="rdoOracle" value="oracle">Oracle</td>
					  <td><input type="radio" name="rdoDBType" id="rdoSQLServer" value="sql server">SQL Server</td>
					  <td><input type="radio" name="rdoDBType" id="rdoDB2" value="db2">DB2</td>
					  <!-- <td><input type="radio" name="rdoDBType" id="rdoMySQL" value="mysql">My SQL</td> -->
					</tr>
				  </table>		  		
		  		<li>			  
				<li class="btn-wrap">
					<button type="submit" class="k-button k-primary rounded" name="btnAction" id="btnConnect" value="Connect" onclick="formSubmit()">Connect</button>
					<input type="submit" style="position: absolute; left: -9999px; width: 1px; height: 1px;" tabindex="-1" 
						   name="btnAction" id="btnConnect" value="Connect">
				</li>
			</ul>
		</form>
	</div>
</div>
</body>
</html>