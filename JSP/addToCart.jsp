<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.cosc304.Items" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<script>
function breakout_of_frame()
{
  // see http://www.thesitewizard.com/archive/framebreak.shtml
  // for an explanation of this script and how to use it on your
  // own website
  if (top.location != location) {
    top.location.href = document.location.href ;
  }
}
</script>


<body onLoad="breakout_of_frame()">
	<!-- Verify user has an account to add items to their cart -->
	
	<%@ include file="validation.jsp" %>
	
	<%
		String uname = "";
		session = request.getSession();
		try{
			uname = session.getAttribute("lgnuser").toString();
		} catch (NullPointerException e){
			session.setAttribute("msg", "You must be logged in to do this.");
			//response.sendRedirect("login.jsp");
		}
		Items item = (Items)session.getAttribute("item");
		
		String sql = "";
		
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
		
			sql = "SELECT stock FROM Products WHERE pid=? AND size=?";
			PreparedStatement ps= con.prepareStatement(sql);
			ps.setInt(1, item.getPid());
			ps.setInt(2, item.getSize());
			ResultSet rs = ps.executeQuery();
			rs.next();
			if(rs.getInt(1) < item.getQuantity()){
				out.println("<script>window.alert('There are not enough items left in inventory to satisfy your request.')</script>");
				response.sendRedirect(request.getHeader("referer"));
			}
		
			sql = "INSERT INTO Basket VALUES(?,?,?,?,0,0,?,?)";
			ps = con.prepareStatement(sql);
			ps.setString(1,uname);
			ps.setInt(2,item.getPid());
			ps.setInt(3,item.getQuantity());
			ps.setString(4,item.getPtype());
			ps.setDouble(5,item.getDiscount());
			ps.setInt(6,item.getSize());
			ps.executeUpdate();
			con.close();
			
			response.sendRedirect("shopping_cart.jsp");
		
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	%>
	
</body>
</html>