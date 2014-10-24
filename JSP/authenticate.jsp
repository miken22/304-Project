<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Authenticating credentials...</title>
</head>
<body>
	<%
		session.setMaxInactiveInterval(900);
		String userName = request.getParameter("lgnuser");
		String password = request.getParameter("lgnpswrd");

		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " + e);
		}
		Connection con = null;
		try {
			String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
			String uid = "mnowicki";
			String pw = "92384072";
			con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();
			String userQuery = "SELECT * from Users WHERE uname='" + userName +"' AND pword='" + password + "'";
			ResultSet result = stmt.executeQuery(userQuery);
			if(result.next()){
				Boolean valid = false;
				valid = true;
				session.setAttribute("valid",valid);
				response.sendRedirect("logged_in_main.jsp");
			} else {
				session.removeAttribute("valid");
				String message = "Invalid user credentials.";
				session.setAttribute("msg", message);
				response.sendRedirect("login.jsp");
			}
		} catch (Exception e) {
			out.println(e + " error");
		}
	%>
</body>
</html>