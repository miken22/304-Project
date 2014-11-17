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
		
		String sql = "UPDATE Users SET fname=?, lname=?, street=?, city=?, prov=?, postalcode=? WHERE uname=?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1,fname);
		ps.setString(2,lname);
		ps.setString(3,street);
		ps.setString(4,city);
		ps.setString(5,prov);
		ps.setString(6,zip);
		ps.setString(7,uname);		
		ps.executeUpdate();
		con.close();
		response.sendRedirect("user_account.jsp");
	} catch (Exception e){
		e.printStackTrace();
	}

%>

</body>
</html>