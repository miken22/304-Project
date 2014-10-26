<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Adding user...</title>
</head>
<body bgcolor="#EEEEEE">

	<%
	// Fifteen minute interval.
	
	String userName = request.getParameter("userName");
	String password = request.getParameter("password");
	String fname = request.getParameter("fName");
	String lname = request.getParameter("lName");
	String age = request.getParameter("age");
	String street = request.getParameter("street");
	String city = request.getParameter("city");
	String prov = request.getParameter("prov");
	String zip = request.getParameter("zip");
	String gender = request.getParameter("gender");
	
	session.setAttribute("uname", userName);
	session.setAttribute("pass", password);
	session.setAttribute("fname", fname);
	session.setAttribute("lname", lname);
	session.setAttribute("age", age);
	session.setAttribute("gender", gender);
	session.setAttribute("strt", street);
	session.setAttribute("prov", prov);
	session.setAttribute("zip", zip);
	Boolean allowable;
	
	if(zip.length() != 6){
		String message = "Postal code must be 6 characters long (including spaces).";
		session.setAttribute("msg",message);
		response.sendRedirect("create_user.jsp");
		return;
	} else if (prov.length() != 2){
		String message = "Province code can only be 2 characters";
		session.setAttribute("msg",message);
		response.sendRedirect("create_user.jsp");
		return;
	} else if (password.length() < 5){
		String message = "Password must be at least 5 characters long.";
		session.setAttribute("msg",message);
		response.sendRedirect("create_user.jsp");
		return;
	}
	
	session.removeAttribute("msg");
		
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
		String checkUserNames = "SELECT uname FROM Users WHERE uname='" + userName + "'";
		ResultSet uNames = stmt.executeQuery(checkUserNames);
		if(uNames.next()){
			String message = "Username is already taken.";
			session.setAttribute("msg", message);
			session.removeAttribute("newuser");
			response.sendRedirect("create_user.jsp");
		} else {
			session.setAttribute("newuser", userName);
			try{
				String command = "INSERT INTO Users VALUES('"+userName+"','"+ password+"','"+ fname+"','"+ lname+"','"+ age+"','"+ street+"','"+ city+"','"+ prov+"','"+ zip+"','"+ gender+"')";
				int ok = stmt.executeUpdate(command);
				
				if(ok == 0){
					allowable = false;
				} else {
					allowable = true;
				}
				session.setAttribute("allowed", Boolean.valueOf(allowable));
				con.close();
				response.sendRedirect("logon.jsp");
				
			} catch (SQLException e){
				con.close();
			}
		}
	} catch (Exception e) {
		con.close();
		out.println("Error");
	}
	
	%>

</body>
</html>