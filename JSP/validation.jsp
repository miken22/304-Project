<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Validating user..</title>
</head>
<body>
	<%
		session = request.getSession();
		String src = request.getHeader("Referer");
		session.setAttribute("src", src);
		Boolean valid = (Boolean)session.getAttribute("valid");
		
		if(valid == null){
			response.sendRedirect("login.jsp");
		} else {
			if(!valid){
				String message = "You must be logged in to access this page";
				session.setAttribute("msg", message);
				response.sendRedirect("login.jsp");
			}
			String userName = session.getAttribute("lgnuser").toString();
			session.setAttribute("lgnuser",userName);
		}
	%>

</body>
</html>