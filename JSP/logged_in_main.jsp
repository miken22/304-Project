<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="validation.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>The Grid</title>
<style>
	#greet div {
		position:relative;
	}
	#greet p{
		float:right;
	}
	body{
		background-image: url("http://d1hw6n3yxknhky.cloudfront.net/002674271_prevstill.jpeg");
		background-attachment: "fixed";
	}
</style>
</head>
<body bgcolor="#EEEEE">
	<%
		String message = "Welcome to the Grid! Please login to continue.";
		session.setAttribute("valid", valid);
		session.setAttribute("msg", message);
	%>
	<div>
		<div id="greet">
			<p>Welcome <%=session.getAttribute("fname").toString()%>!<p>
		</div>
	</div>
	<%@ include file="login_banner.html" %>

</body>
</html>