<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>The Grid</title>
<style>
body {
	background-image:
		url("http://d1hw6n3yxknhky.cloudfront.net/002674271_prevstill.jpeg");
	background-attachment: "fixed";
}
</style>
</head>
<body>
	<%@ include file="general_banner.html"%>


	<div id="header1">
		<h2>The DEAL:</h2>

		<%--Contact the database to acquire the product on sale --%>
		<%@ page import="java.sql.*"%>
		<%
			//Check for Driver
			try {
				Class.forName("com.mysql.jdbc.Driver");
			} catch (java.lang.ClassNotFoundException e) {
				System.err.println("ClassNotFoundException: " +e);
			}
				//Establish Connection
			Connection con = null;
			try {
			//Credentials
				String url= "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
				String uid= "mnowicki";
				String pw = "92384072";
			//Connect	
				con = DriverManager.getConnection(url, uid, pw);
			//SQL Statement
				Statement stmt= con.createStatement();
				String sql= "SELECT * FROM Deals ";
				ResultSet rst= stmt.executeQuery(sql);
			//TEST: Print result
				out.print("<table width=50% border=1>"+"<tr><th>Results from Deals</th></tr>");
				while (rst.next()){
					out.println("<tr><td>" + rst.getString(0) + "</td></tr>");
				}
				out.println("</table>");
			//Close Connection
				con.close();
			} catch (SQLException ex){
				//Print Error
				System.err.println(ex);
				out.println("<br><h1>Error 1</h1><br>");
			} finally {
				if (con != null)
				try {con.close();}
				catch (SQLException ex) {
					System.err.println(ex); 
				}
			}
		%>
	</div>


	<%@ include file="timer.html"%>

	<%--
	<%@ include file="itemHead.html" %>
	<%@ include file="itemInfo.html" %>	
	--%>

</body>
</html>