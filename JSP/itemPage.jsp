<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.cosc304.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<!-- Page Variables -->
	<%!private String fname = "";
	private String uname = "";
	private double tax = 0;
	private double totalCost = 0;
	private ArrayList<Items> itemMap=new ArrayList<>();
	private Items item;
	%>

	<!-- Get Session and Item Information -->
	<%
		session = request.getSession();

		//Collect Username ('uname') from session
		try {
			fname = session.getAttribute("fname").toString();
			uname = session.getAttribute("lgnuser").toString();
			session.setAttribute("lgnuser", uname);
		} catch (Exception e) {
			out.println(e.toString());
		}

		//Collect URL Product ID (pid) Parameter, and Set To Session
		session.setAttribute("pid",request.getParameter("pid"));

		//NOTE!@# Refer to shopping cart "?" for prepared statements

		//Create Database Connection
		//Check for Driver
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " + e);
		}
		//Establish Connection
		Connection con = null;
		try {
			//Credentials
			String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
			String uid = "mnowicki";
			String pw = "92384072";
			//Connect	
			con = DriverManager.getConnection(url, uid, pw);
			//SQL Statement
			String sql = "SELECT * FROM Products WHERE pid=?;";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, Integer.parseInt(session.getAttribute("pid").toString()));
			ResultSet rst = ps.executeQuery();
			//!@#More than 1 result can come back for different sizes
			int index=0;
			while (rst.next()) {
				item.setPname(rst.getString("pname"));
				item.setPid(rst.getInt("pid"));
				item.setPrice(rst.getDouble("price"));
				item.setStock(rst.getInt("stock"));
				item.setPtype(rst.getString("ptype"));
				item.setPgender(rst.getString("pgender"));
				item.setPdescription(rst.getString("pdescription"));
				item.setSize(rst.getInt("size"));
				item.setThumbId(rst.getInt("thumbID"));
				
				//!@#contunue from here
			
				//New ArrayList entry
				itemMap.add(index, item);
				index++;
			}
			out.println("</table>");

			//Close Connection
			con.close();
		} catch (SQLException ex) {
			//Print Error
			System.err.println(ex);
			out.println("<br><h1>Error 1</h1><br>");
		}
	%>

</body>
</html>