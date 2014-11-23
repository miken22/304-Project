<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
		background-attachment: "fixed";
	}
</style>
</head>
<body>

	<%@ include file="validation.jsp" %>
	<%   String fname = "";
 		 String uname = ""; 
		session = request.getSession();
		try{
			fname = session.getAttribute("fname").toString();
			uname = session.getAttribute("lgnuser").toString();
			session.setAttribute("lgnuser", uname);
		} catch (Exception e){
			out.println(e);
		}
	%>
	<div>
		<div id="greet">
			<p>Welcome <%out.println(fname);%><p>
		</div>
	</div>
	
	<%@ include file="general_banner.html"%>

</body>
</html>