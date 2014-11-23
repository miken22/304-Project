<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Layout</title>

<style>
	table{
			height: 100%;
			width: 100%;
		}
		
		table td{
			max-width: 100%;
			max-height: 25%;
		}
		table tr{
		}
		table img{
			width:80px;
			height:348px;
			display: block; /*nothing sits beside it*/
			vertical-align: top;
			margin: 0px 10px 5px 10px; /*note: no commas*/
		}
		
		.productInfo{
			//background-color: black;
			vertical-align: bottom;
			margin: auto;
		}
		input[type=image] {
			width:120px;
			height:190px;
			margin-top: 15px;
			border: 1px solid #000000;
		}
		
</style>
</head>


<body>

	<%
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
		
		// Get PID of deal item to not display in grid.
		String sql = "SELECT pid,discount FROM Deals WHERE saleNum = (SELECT count(saleNum) FROM Deals)";
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		rs.next();
		int dealPid = rs.getInt(1);
		
		sql = "SELECT DISTINCT pid, imgSrc FROM Products WHERE pid<>"+dealPid;
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		
		out.println("<table>");
		while(rs.next()){
			out.println("<tr align=\"center\">");
			for (int i = 0; i < 4; i++){
				out.println("<td> <div class=\"productInfo\"><form method=\"get\" action=\"itemPage.jsp\">" +
								"<input type=\"hidden\" name=\"pid\" value=\""+rs.getInt(1) + "\">");
				out.println("<input	type=\"image\" src=\"" + rs.getString(2) + "\">");
				out.println("</form></div></td>");
				if (!rs.next()){
					break;
				}
			}
			out.println("</tr>");
		}	
		
		con.close();
		
	} catch (Exception e){
		con.close();
	}

	
	
	%>


</body>
</html>