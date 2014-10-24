<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
<style>
	h1 {
		font-family: "serif";
	}
	
	p {
		color: blue;
		font-family: "serif";
		font-size: 10pt;
	}
</style>
</head>
<body bgcolor="#EEEEE">

	<h1 align="center">Welcome to <b><i>The Grid</i></b></h1>

	<%
		session = request.getSession();
		Boolean valid = (Boolean)session.getAttribute("valid");
		session.setAttribute("valid", valid);
		
		if (valid != null){
			if(!valid){
				out.println("<p>" + session.getAttribute("msg").toString() + "</p>");
			}
		}
		
	%>

	<form name="newUser" method="post" action="authenticate.jsp">
		<table>
			<tr><td>Username:</td><td><input type="text" name="lgnuser" required></td></tr>
			<tr><td>Password:</td><td><input type="password" name="lgnpswrd" required></td></tr>
			<tr><td align="center" colspan="2"><input type="submit" value="Login"></td></tr>
		</table>
	</form>
</body>
</html>