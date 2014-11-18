<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>We suggest</title>
</head>
<body>

	<%
	
	
	session = request.getSession();
	String uname = "";
	try{
		uname = session.getAttribute("lgnuser").toString();
	} catch (NullPointerException e){
		out.println("");
		return;
	}

	try {
		Class.forName("com.mysql.jdbc.Driver");
	} catch (java.lang.ClassNotFoundException e) {
		System.err.println("ClassNotFoundException: " + e);
	}
	Connection rec_con = null;
	try {
		String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
		String uid = "mnowicki";
		String pw = "92384072";
		rec_con = DriverManager.getConnection(url, uid, pw);
		
		String sql = "SELECT ptype from UserInterest WHERE uname=?";
		PreparedStatement ps = rec_con.prepareStatement(sql);
		ps.setString(1, uname);
		ResultSet rs = ps.executeQuery();
		int displayed = 0;	// Track number of items in banner
		out.println("<table>");
		while(rs.next() && displayed < 3){
			displayed++;
			sql = "SELECT DISTINCT pid FROM Products WHERE ptype=?";
			ps = rec_con.prepareStatement(sql);
			ps.setString(1,rs.getString(1));
		}
		out.println("</table>");
		rec_con.close();
	} catch (Exception e){
		e.printStackTrace();
	}

	%>

</body>
</html>