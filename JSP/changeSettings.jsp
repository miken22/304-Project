<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Working..</title>
</head>
<body>
<%@ include file="validation.jsp" %>
<%
	session = request.getSession();

	String uname = "";
	String password = "";
	String fname = "";
	String lname = "";
	String street = "";
	String city = "";
	String prov = "";
	String zip = "";
	
	try{
		uname = session.getAttribute("lgnuser").toString();
	} catch (NullPointerException e){
		e.printStackTrace();
	}
	
	password = request.getParameter("pass");
	fname = request.getParameter("fname");
	lname = request.getParameter("lname");
	street = request.getParameter("address");
	city = request.getParameter("city");
	prov = request.getParameter("prov").toUpperCase();
	zip = request.getParameter("post").toUpperCase();
	
	if(prov.length() != 2){
		response.sendRedirect("user_account.jsp");
	}
	if(zip.length() != 6){
		response.sendRedirect("user_account.jsp");
	}
	if (password.length() < 5){
		String message = "Password must be at least 5 characters long.";
		session.setAttribute("msg",message);
		response.sendRedirect("create_user.jsp");
		return;
	}
	
	
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
		
		String sql = "UPDATE Users SET pword=?, fname=?, lname=?, street=?, city=?, prov=?, postalcode=? WHERE uname=?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1,password);
		ps.setString(2,fname);
		ps.setString(3,lname);
		ps.setString(4,street);
		ps.setString(5,city);
		ps.setString(6,prov);
		ps.setString(7,zip);
		ps.setString(8,uname);		
		ps.executeUpdate();
		con.close();
		response.sendRedirect("user_account.jsp");
	} catch (Exception e){
		e.printStackTrace();
	}

%>

</body>
</html>