<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.*"%>
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

	<!-- Nested class to hold items (code from Shopping Cart)  -->
	<%!private class Items {
		private String pname;
		private Integer pid;
		private double price;
		private int stock;
		private String ptype="";
		private String pgender="";
		private String pdescription="";
		private int size;
		private int thumbId;
		private double discount;
		
		private double cost; // this is quant * price - discount;

		//Constructor
		public Items(String pname, Integer pid, double price, int stock, String ptype, String pgender, String pdescription, int size, int thumbId, double discount) {
			setPname(pname);
			setPid(pid);
			setPrice(price);
			setStock(stock);
			setPtype(ptype);
			setPgender(pgender);
			setPdescription(pdescription);
			setSize(size);
			setThumbId(thumbId);
			setDiscount(0);
			//!@# left out picID and photoID for now.
			
			
			//!@#do a check for pid=THE DEAL (currrently)
			//discount=0 for itemPage
		}

		
		//GETTERS SETTERS
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public String getPtype() {
		return ptype;
	}
	public void setPtype(String ptype) {
		this.ptype = ptype;
	}
	public String getPgender() {
		return pgender;
	}
	public void setPgender(String pgender) {
		this.pgender = pgender;
	}
	public String getPdescription(){
		return pdescription;
	}
	public void setPdescription(String desc){
		pdescription=desc;
	}
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public int getThumbId() {
		return thumbId;
	}
	public void setThumbId(int thumbId) {
		this.thumbId = thumbId;
	}
	public double getDiscount() {
		return discount;
	}
	public void setDiscount(double discount) {
		this.discount = discount;
	}
		
		}//Items
		
		// Will need another field/getter/setter for product image id.
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