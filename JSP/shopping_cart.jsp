<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Your stuff</title>
<style>
	#greet div {
		display: inline-block;
		float: right;
	}
	#greet p{
		float: right;
		z-index: 0;
	}
	table td{
		margin: 5px 7px 5px 7px;
	}
	table img{
		max-height:100px;
		max-width: 100px;
		display: block; /*nothing sits beside it*/
		vertical-align: top;
		margin: 0px 10px 5px 10px; /*note: no commas*/
	}
	input[type=button] {
		border: black;
		background: transparent;
		color: black;
		font-family: "serif";
		font-size: 14pt;
		padding: 5px 5px;
		z-index: -1;
		width: 30x;
	}
	
</style>
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
<%!
	public class Items {
		private String name = "";
		private int quant = 0;
		private int size = 0;
		private int pid = 0;
		private double price = 0;
		private int stock = 0;
		private String ptype="";
		private String pgender="";
		private String pdescription="";
		private int tid = 0;
		private double discount = 0;
		private double itemPrice = 0;
		private double cost = 0; // this is quant * price - discount;
		
		public Items(){}
		
		public Items(int quantity, double discount, int size){
			this.quant = quantity;
			this.discount = discount;
			this.size = size;
		}
		
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
		public double getDiscount(){
			return discount;
		}
		
		public void setPname(String name){
			this.name = name;
		}
		public void setItemPrice(double price){
			this.itemPrice = price;
			setCost();
		}
		private void setCost(){
			cost = (itemPrice * quant) * (1 - discount);
		}
		public double getCost(){
			return cost;
		}	
		public int getQuantity(){
			return quant;
		}
		public int getSize(){
			return size;
		}
		public void setThumbId(int id){
			this.tid = id;
		}
		public int getThumbId(){
			return tid;
		}
		public String getPname() {
			return name;
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
		public void setSize(int size) {
			this.size = size;
		}
		public void setDiscount(double discount){
			this.discount = discount;
		}
		public void setQuantity(int q){
			this.quant = q;
		}
	}
	%>

	<%@ include file="validation.jsp" %>
	<!-- Variables to use on page -->
	<%! private String fname = "";
		private String uname = "";
		private double tax = 0;
		private double totalCost = 0;
		private HashMap<Integer, Items> itemMap= new HashMap<Integer, Items>();	
	%>
	
	<%
		session = request.getSession();
	
		try{
			fname = session.getAttribute("fname").toString();
			uname = session.getAttribute("lgnuser").toString();
			session.setAttribute("lgnuser", uname);
		} catch (Exception e) {
			out.println(e.toString());
		}
	%>
	<div>
		<div id="greet">
			<div>
				<p>Welcome <%out.println(fname);%></p>
			</div>
		</div>
	</div>
	
	<%@ include file="general_banner.html" %>
	
	<br>
	<br>
	<br>
	<%
		// Find if user has any items in the basket already, looks for "shipped" boolean in returned query.
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
			
			// Query to check if user has any items in the basket that have not been shipped yet.
			String cartQuery = "SELECT pid, quantity, discount, size FROM Basket WHERE(uname='" + uname + "' AND shipped=0)";
			ResultSet rs = stmt.executeQuery(cartQuery);
			
			// This hashes all items and their prices for easier lookup. 
			
			
			while(rs.next()){ // Cycle through results creating an Item object for each
					// Create an item for each PID, storing the amount and discount, gets hashed to PID.
					Items item = new Items(rs.getInt(2),rs.getDouble(3),rs.getInt(4));
					itemMap.put(rs.getInt(1),item);		
			}
			
			out.println("<table border=\"0\" width = \"100%\" style=\"border-collapse: collapse;\">");
			out.println("<tr><th align=\"center\">" + " " + "</th><th align=\"center\">What You Want</th><th align=\"center\">Quantity</th><th align=\"right\">Price</th>");
			

			
			// For each item in the basket, get associated name and default price.
			for(Integer i : itemMap.keySet()){
				Items item = itemMap.get(i);
				String productQuery = "SELECT pname, price, thumbID FROM Products WHERE pid=?;";
				PreparedStatement ps = con.prepareStatement(productQuery);
				ps.setInt(1, i);
				ResultSet prodResults = ps.executeQuery();
				
				// Assignment
				if(prodResults.next()){
					item.setPname(prodResults.getString(1));
					item.setItemPrice(prodResults.getDouble(2));	// setting price invokes method to determine cost;
					item.setThumbId(prodResults.getInt(3));
					// Updates the DB to store to price the customer is paying for the product.
					String updateBasketPrice = "UPDATE Basket SET price = " + item.getCost() + " WHERE uname = '" + uname  + "' AND pid=?";
					PreparedStatement updatePS = con.prepareStatement(updateBasketPrice);
					updatePS.setInt(1,i);
					updatePS.executeUpdate();
					totalCost += item.getCost();
				}

				// Build table of items, first block is thumbnail, the rest is order info.
				out.println("<tr> <td> <img src=\"");
				out.println(String.format("thumbs/%02d.jpg\" >", item.getThumbId()));
				
				out.println("</td> <td  width=\"40%\" align=\"center\"align=\"center\">" + item.getPname() 
						+ "</td> <td width=\"20%\" align=\"center\">" + item.getQuantity() + "</td> <td width=\"20%\" align=\"right\"> $");
				out.println(String.format("%.2f", item.getCost()));
				out.println(" </td></tr>");
			}

			out.println("<tr style=\"border-top:2px solid black\" align=\"right\"><td colspan=\"4\"> Subtotal: $");
			out.println(String.format("%.2f", totalCost));
			out.println(" </td></tr>");
			double taxes = totalCost*0.12;
			out.println("<tr align=\"right\"><td colspan=\"4\"> Taxes: $");
			out.println(String.format("%.2f", taxes));
			out.println(" </td></tr>");
			out.println("<tr align=\"right\"><td colspan=\"4\">  Subtotal: $");
			out.println(String.format("%.2f", totalCost+taxes));
			out.println(" </td></tr>");
			totalCost = 0;
			con.close();
			
		} catch (Exception e){
			con.close();
		}

		out.println("</table><table>");

		out.println("<form method='post' >");
		out.println("<tr align=\"center\"><td bgcolor=\"yellow\"><input class=\"checkout\" type=\"submit\" name=\"checkout\" value=\"Checkout\"></td>");
		out.println("<td bgcolor=\"yellow\"><input class=\"clearAll\" type=\"submit\" name=\"clearAll\" value=\"Clear Cart\" onclick=\"shopping_cart.jsp;\"></td></tr>");
			
		out.println("</form><hr><br>");
		out.println("</table>");
	%>
		<!-- Handle checkout features -->
	<%
		String checkOut = request.getParameter("checkout");
		String clearAll = request.getParameter("clearAll");
		// Listens for click in checkout form.
		if("Checkout".equals(checkOut)){
			// Form button clicked
			if(itemMap.size() == 0){
				out.println("Nothing in your cart!");
				return;
			} else {
				// Reconnect to DB
				try {
					Class.forName("com.mysql.jdbc.Driver");
				} catch (java.lang.ClassNotFoundException e) {
					System.err.println("ClassNotFoundException: " + e);
				}
				con = null;
				try {
					String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
					String uid = "mnowicki";
					String pw = "92384072";
					con = DriverManager.getConnection(url, uid, pw);
					
					// Cycle through cart
					for (Integer i : itemMap.keySet()){
						Items item = itemMap.get(i);
						// Mark order as shipped, part of assumption that payment by 3rd party and what now..
						String updateBasket = "UPDATE Basket SET shipped=TRUE WHERE(uname=? AND pid=?)";
						PreparedStatement ps = con.prepareStatement(updateBasket);
						ps.setString(1,uname);
						ps.setInt(2,i);
						ps.executeUpdate();
						
						// Now inventory
						int quantity = item.getQuantity();
						int size = item.getSize();
						String updateProducts = "UPDATE Products SET stock = stock - ? WHERE pid=? and size=?";
						ps = con.prepareStatement(updateProducts);
						ps.setInt(1, quantity);
						ps.setInt(2, i);
						ps.setInt(3, size);
						ps.executeUpdate();
						
						// User History
						String updateHistory = "INSERT INTO UserHistory VALUES(uname = ?, pid = ?)";
						ps = con.prepareStatement(updateHistory);
						ps.setString(1,uname);
						ps.setInt(2,i);
						ps.executeUpdate();
					}
					totalCost = 0;
					con.close();
					session.invalidate();
					response.sendRedirect("authorize.html");
				} catch (Exception e){
					e.printStackTrace();
				}
			}
		} else if("Clear Cart".equals(clearAll)) {
			if(itemMap.size() == 0){
				out.println("Nothing in your cart!");
				return;
			} else {
				// Reconnect to DB
				try {
					Class.forName("com.mysql.jdbc.Driver");
				} catch (java.lang.ClassNotFoundException e) {
					System.err.println("ClassNotFoundException: " + e);
				}
				try {
					String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
					String uid = "mnowicki";
					String pw = "92384072";
					Connection con1 = DriverManager.getConnection(url, uid, pw);
					
					String updateBasket = "DELETE FROM Basket WHERE uname=? AND shipped=FALSE";
					PreparedStatement ps = con1.prepareStatement(updateBasket);
					ps.setString(1,uname);
					ps.executeUpdate();
					itemMap.clear();
					response.sendRedirect("shopping_cart.jsp");
					con1.close();
				} catch (Exception e){
					e.printStackTrace();
				}
			}
		}
		
	%>
</body>
</html>