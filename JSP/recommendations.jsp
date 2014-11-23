<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>We suggest</title>
</head>
<style>
#recs div{
	width:100%;
	align:center;
}


</style>
<body>
	<div id="recs">
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
		
		if (!"".equals(uname)){
			String sql = "SELECT ptype from UserInterest WHERE uname=?";
			PreparedStatement ps = rec_con.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
			ps.setString(1, uname);
			ResultSet rs = ps.executeQuery();
			int displayed = 0;	// Track number of items in banner
			out.println("<table align=\"center\" border=\"2\" style=\"width:100% height:100%\"><tr align=\"center\">");
			while(rs.next() && displayed < 3){
				displayed++;
				// Find out how many products of that type are in the DB
				sql = "SELECT count(DISTINCT pid) FROM Products WHERE ptype=?";
				ps = rec_con.prepareStatement(sql);
				ps.setString(1,rs.getString(1));
				ResultSet next_rs = ps.executeQuery();
				next_rs.next();
				int num_of_results = next_rs.getInt(1);
				// Get the product list
				sql = "SELECT DISTINCT pid FROM Products WHERE ptype=?";
				ps = rec_con.prepareStatement(sql);
				ps.setString(1,rs.getString(1));
				next_rs = ps.executeQuery();
				// Randomly pick one to display
				int to_display = new java.util.Random().nextInt(num_of_results) + 1;
				int pos = 0;
				// Cycle to position in results
				while (pos < to_display){
					next_rs.next();
					++pos;
				}
				// Get product thumbnail to display as link in recommendations
				int pid_to_display = next_rs.getInt(1);
				
				sql = "SELECT thumbID FROM Products WHERE pid=?";
				ps = rec_con.prepareStatement(sql);
				ps.setInt(1,pid_to_display);
				next_rs = ps.executeQuery();
				next_rs.next();
				int thumb_id = next_rs.getInt(1); 
				out.println("<tr><td><form method=\"get\" action=\"altItemPage.jsp\"><input type=\"hidden\" name=\"pid\" value=\"" +pid_to_display+ "\">");
				out.println("<input type=\"image\" name=\"recPic\" src=\"");
				//img src
				out.println(String.format(
						"thumbs/%02d.jpg\"  width=150 height=150></form>",
						thumb_id));
				//img properties
				out.println("</td></tr>");
			}
			out.println("</table>");
		} else {
			// Put 3 random items in the banner
		}
		rec_con.close();
	} catch (Exception e){
		e.printStackTrace();
	}

	%>
	</div>
</body>
</html>