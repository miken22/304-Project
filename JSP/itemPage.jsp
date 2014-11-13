<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.cosc304.*"%>
<%@ page import="java.text.DecimalFormat" %>

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
	private ArrayList<Items> itemMap=new ArrayList<Items>();
	private Items item=new Items();
	%>

	<!-- Get Session and Item Information -->
	<%
		session = request.getSession();

		//Collect URL Product ID (pid) Parameter, and Set To Session - Save to a variable
		session.setAttribute("pid",request.getParameter("pid"));
		int pid = Integer.valueOf(request.getParameter("pid"));
		
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
			ps.setInt(1, pid);
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
			
				//New ArrayList entry
				itemMap.add(index, item);
				index++;
			}
			
			//Close Connection
			con.close();
		} catch (SQLException ex) {
			//Print Error
			System.err.println(ex);
			out.println("<br><h1>Error 3</h1><br>");
		}
	%>

<!-- Display Item Info and Picture -->
<%
//Currency Decimal Format
DecimalFormat money = new DecimalFormat("'$'0.00");
//selected first item in itemMap
//!@# later, we hook the list to populate the screen with the desired item

if(itemMap.size()>0){
//There is at least one item size, so get the first item
	item=itemMap.get(0);

//check for sessionary size info
if(session.getAttribute("size")!=null){
	out.println("previously listed size");
}else{
	out.println("NO previously listed size");
	session.setAttribute("size", item.getSize());
}

//Item Picture
//div
 out.print("<div id=\"itemPic\">");
out.print("<tr><td><img src=\"");
//img src
out.println(String.format("thumbs/%02d.jpg\" >", item.getThumbId()));
//img properties
out.println("</td><td  width=\"100%\" align=\"center\">");
//end div
out.print("</div>");


//Item Info Table
	//div
	out.print("<div id=\"itemInfo\" class='box'>");
	//name of item
	out.print("<table><tr><th colspan='2'><h3>"+item.getPname()+"</h3></th></tr>");
	//price
	out.print("<tr><td><b>&nbsp;Price:</b></td><td>"+ money.format(item.getPrice())+"</td></tr>");
	//description
	out.print("<tr><td><b>&nbsp;Description:</b></td><td><p>"+ item.getPdescription()+"</p></td></tr>");
	//sizes
	out.print("<tr><td><b>&nbsp;Size:</b></td><td>"+ item.getSize()+"</td></tr>");
	//stock or Quantity
	out.print("<tr><td><b>&nbsp;Stock/Quantity:</b></td><td>"+ item.getQuantity()+"</td></tr>");
	//PID
	out.print("<tr><td><b>&nbsp;Product ID:</b></td><td>"+ item.getPid().toString()+"</td></tr>");
	//
	//end table and div
	out.print("</table></div>");
	

//Available size list (Radio Buttons)
out.print("<div id=\"list\">");
out.print("<form action=\"response.sendRedirect(\"itemPage.jsp\")\"");
for(int i=0; i<itemMap.size();i++){
out.print("<input type=\"radio\" name=\"sizeButton\" value=\""+itemMap.get(i).getSize()+"\">"+"Size "+itemMap.get(i).getSize()+"<br>");
}

}else{
	out.print("Error, no items in itemMap");
}



%>

</body>
</html>