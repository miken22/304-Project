<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Who you are</title>
<style>
body {
	background-image: url("http://cdn4.coresites.mpora.com/whitelines_new/wp-content/uploads/2010/10/Gigi-Ruf-Snowboard-Wallpaper-1900x1200.jpg");
	background-attachment: fixed;
}
input[type=button] {
	border: white;
	background: transparent;
	color: black;
	font-family: "serif";
	font-size: 15pt;
	padding: 5px 5px;
	z-index: -1;
	width: 100%;
}
</style>

</head>

<script>
function breakout_of_frame()
{
  if (top.location != location) {
    top.location.href = document.location.href ;
  }
}
</script>
<body onLoad="breakout_of_frame()">

<%@ include file="validation.jsp" %>
<%@ include file="general_banner.html" %>

<%
	session = request.getSession();
	String uname = "";
	try{
		uname = session.getAttribute("lgnuser").toString();
	} catch (NullPointerException e){
		e.printStackTrace();
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
		
		String sql = "SELECT * from Users WHERE uname=?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1,uname);
		ResultSet rs = ps.executeQuery();
		rs.next();
		// Get user info:
		String pass = rs.getString(2);
		String fname = rs.getString(3);
		String lname = rs.getString(4);
		String streetAdd = rs.getString(6);
		String city = rs.getString(7);
		String prov = rs.getString(8);
		String zip = rs.getString(9);
		
		out.println("<font size=\"5\" color=\"white\"><h1 align=\"center\">Account Details:</h1>");
		out.println("<form method=\"post\" action=\"changeSettings.jsp\">");
		out.println("<table align=\"center\" bgcolor=\"grey\" border=\"0\" cellspacing=20>");
		out.println("<tr><td>Username:</td><td><input type=\"text\" readonly=\"readonly\" value=\""+uname+"\"/></td></tr>");
		out.println("<tr><td>Password:</td><td><input type=\"password\" name=\"pass\" required value=\""+pass+"\"/></td></tr>");
		out.println("</table><br>");
		out.println("<font color=\"white\"><h1 align=\"center\">Personal Details:</h1></font>");
		out.println("<table align=\"center\" bgcolor=\"grey\" border=\"0\" cellspacing=20>");
		out.println("<tr><td>First Name:</td><td><input type=\"text\" name=\"fname\" required value=\""+fname+"\"></td></tr>");
		out.println("<tr><td>Last Name:</td><td><input type=\"text\" name=\"lname\" required value=\""+lname+"\"></td></tr>");
		out.println("<tr><td>Street Address:</td><td><input type=\"text\" name=\"address\" required value=\""+streetAdd+"\"></td></tr>");
		out.println("<tr><td>City:</td><td><input type=\"text\" name=\"city\" required value=\""+city+"\"></td></tr>");
		out.println("<tr><td>Province:</td><td><input type=\"text\" name=\"prov\" required value=\""+prov+"\"></td></tr>");
		out.println("<tr><td>Postal Code:</td><td><input type=\"text\" name=\"post\" required value=\""+zip+"\"></td></tr>");
		out.println("<tr><td colspan=\"2\"> </td></tr>");
		out.println("</font></b>");
		out.println("<tr><td bgcolor='yellow'><input type=\"submit\" value=\"Change Settings\"></td>");
		out.println("<td bgcolor='yellow'><input type=\"button\" value=\"Start Over\" onClick=\"window.location.reload()\"></td</tr>");
		out.println("</table></form>");
		con.close();
	} catch (Exception e){
		e.printStackTrace();
	}

%>

</body>
</html>