<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Random" %>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>The Grid</title>
<style>
body {
	background-attachment: "fixed";
}

/*
*/


#greet div {
	position: relative;
	width: 100%;
}

#greet p {
	float: right;
}

#product div {
	float: right;
}
.sizeList {
	width: 150px;
}
.quant {
	width: 50px;
}
#prodPic img {
	height: 70%;
	width: 35%;
}

td {
	border-radius: 5px;
}

body {
	background-image:
		url("http://cdn4.coresites.mpora.com/whitelines_new/wp-content/uploads/2010/10/Gigi-Ruf-Snowboard-Wallpaper-1900x1200.jpg");
	background-attachment: fixed;
}
</style>
</head>
<script>
	function breakout_of_frame() {
		if (top.location != location) {
			top.location.href = document.location.href;
		}
	}
</script>
<body onLoad="breakout_of_frame()">

	<%! public class Items {
		private String name = "";
		private int quant = 0;
		private int size = 0;
		private int pid = 0;
		private double price = 0;
		private int stock = 0;
		private String ptype = "";
		private String pgender = "";
		private String pdescription = "";
		private int tid = 0;
		private double discount = 0;
		private double cost = 0; // this is quant * price - discount;

		public Items() {
		}

		public Items(int quantity, double discount, int size) {
			this.quant = quantity;
			this.discount = discount;
			this.size = size;
		}

		public Items(String pname, Integer pid, double price, int stock,
				String ptype, String pgender, String pdescription, int size,
				int thumbId, double discount) {
			setPname(pname);
			setPid(pid);
			setPrice(price);
			setStock(stock);
			setPtype(ptype);
			setPgender(pgender);
			setPdescription(pdescription);
			setSize(size);
			setThumbId(thumbId);
			//!@# left out picID and photoID for now.

			//!@#do a check for pid=THE DEAL (currrently)
			//discount=0 for itemPage
		}

		public double getDiscount() {
			return discount;
		}

		public void setPname(String name) {
			this.name = name;
		}

		private void setCost() {
			cost = (price * quant) * (1 - discount);
		}

		public double getCost() {
			return cost;
		}

		public int getQuantity() {
			return quant;
		}

		public int getSize() {
			return size;
		}

		public void setThumbId(int id) {
			this.tid = id;
		}

		public int getThumbId() {
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
			setCost();
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

		public String getPdescription() {
			return pdescription;
		}

		public void setPdescription(String desc) {
			pdescription = desc;
		}

		public void setSize(int size) {
			this.size = size;
		}

		public void setDiscount(double discount) {
			this.discount = discount;
		}

		public void setQuantity(int q) {
			this.quant = q;
		}
	}%>

	<%@ include file="general_banner.html"%>
	<%@ include file="recommendations.jsp" %>

	<!-- Page Variables -->
	<%!private String fname = "";
	private String uname = "";
	private double tax = 0;
	private double totalCost = 0;
	private ArrayList<Items> itemMap = new ArrayList<Items>();

	//private Items item=new Items();%>

	<!-- Get Session and Item Information -->
	<%
		session = request.getSession();
		itemMap.clear();
		//Collect URL Product ID (pid) Parameter, and Set To Session - Save to a variable
		// Need to lookup latest deal and pull pid.
		int pid = 0;

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
			
			String sql = "SELECT * FROM Deals WHERE saleNum = (SELECT count(saleNum) FROM Deals)";
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rst = ps.executeQuery();
			rst.next();
			
			pid = rst.getInt(2);
			Date date = new Date();
			date = rst.getDate(3);
			Date currDate = new Date();
			double discount = rst.getDouble(4);
			int duration = rst.getInt(5);
			date.setTime(date.getTime() + duration*60*1000);	// Convert to millis
			// check sale still valid, if not get a new one, reload page
			//SQL Statement
			sql = "SELECT * FROM Products WHERE pid=?;";
			ps = con.prepareStatement(sql);
			ps.setInt(1, pid);
			rst = ps.executeQuery();
			//!@#More than 1 result can come back for different sizes
			while (rst.next()) {
				Items item = new Items(); // Without this you keep overwriting item and it looks like only 1 type returned... Would work in c++
				item.setPname(rst.getString("pname"));
				item.setPid(rst.getInt("pid"));
				item.setStock(rst.getInt("stock"));
				item.setPtype(rst.getString("ptype"));
				item.setPgender(rst.getString("pgender"));
				item.setPdescription(rst.getString("pdescription"));
				item.setSize(rst.getInt("size"));
				item.setThumbId(rst.getInt("thumbID"));
				item.setDiscount(discount);
				item.setPrice(rst.getDouble("price"));
				//New ArrayList entry
				itemMap.add(item);

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

		if (itemMap.size() > 0) {
			//There is at least one item size, so get the first item
			Items item = itemMap.get(0);

			//Item Picture
			//div
			out.println("<div id=\"product\"");
			out.print("<div id=\"itemPic\">");
			out.print("<table cellspacing=20>");
			out.print("<tr><th colspan='3'><font size=\"6\"color=\"black\">"
					+ item.getPname() + "</font></th></tr>");
			out.print("<tr><td rowspan='4'><img name=\"prodPic\" src=\"");
			//img src
			out.println(String.format(
					"thumbs/%02d.jpg\"  width=234 height=348>",
					item.getThumbId()));
			//img properties
			out.println("</td></tr>");
			//end div
			out.print("</div>");

			//Item Info Table
			//div
			out.print("<div id=\"itemInfo\" class='box'>");
			//name of item

			//price
			out.print("<tr><td colspan='3' bgcolor='grey'><font size=\"4\"color=\"white\"><b><table cellspacing=20>");
			out.print("<tr><td><b>&nbsp;Sex:</b></td><td>"
					+ item.getPgender() + "</td></tr>");
			out.print("<tr><td><b>&nbsp;Regularly Priced:</b></td><td>"
					+ money.format(item.getPrice()) + "</td></tr>");
			out.println("<tr><td><font size=\"4\"color=\"red\"><b>&nbsp;Get it for:</b></td><td>"
					+ "<font size=\"4\"color=\"red\">"
					+ money.format(item.getPrice()
							- (item.getPrice() * item.getDiscount()))
					+ "</font></td></tr>");
			//description
			out.print("<tr><td><b>&nbsp;Description:</b></td><td><p>"
					+ item.getPdescription() + "</p></td></tr>");

			out.print("</b></font><tr>");
			out.print("<div id=\"prodlist\" float=\"right\">");
			out.println("<form method=\"get\" name='addItem'>");
			out.println("<td colspan='2'><select name=\"sizeList\" class='sizeList'>");
			for (int i = 0; i < itemMap.size(); i++) {
				String size = "Medium"; // Sizes
				switch (itemMap.get(i).getSize()) {
				case (1):
					size = "Small";
					break;
				case (2):
					size = "Medium";
					break;
				case (3):
					size = "Large";
					break;
				case (4):
					size = "Extra-Large";
					break;
				}
				// Print dropdown menu
				out.print("<option value=\"" + itemMap.get(i).getSize()
						+ "\">" + size + " - Stock: "
						+ itemMap.get(i).getStock() + "</option>");
			}
			out.println("</select></td></tr>");
			out.println("<tr><td colspan='2'>Amount:<input type='text' class='quant' name='quant' required>");
			out.println("</td></tr>");
			out.println("<tr><td bgcolor='yellow' align='center'>");
			out.println("<input type=\"hidden\" name=\"pid\" value=\""
					+ item.getPid() + "\" >");
			out.println("<input type=\"submit\" name=\"addToCart\" class=\"addToCart\" value=\"Add to Cart\">");
			out.println("</td></tr></form>");

			// End nested table
			out.print("</table></td></tr>");

			//end table and div
			out.print("</table></div>");
			out.println("</div>");

			/*
			<div id="testTimer">
			<p>
			Start Date: <span id="testStart"></span>.
			</p>
			<p>
			End date: <span id="testEnd"></span>.
			</p>
			<p>
			Time Remaining: <span id="testRemaining"></span>.
			</p>
			</div>
			 */

			// EVENT LISTENER
			String addItem = request.getParameter("addToCart");
			if ("Add to Cart".equals(addItem)) {
				int size = Integer
						.valueOf(request.getParameter("sizeList"));
				Items toAdd = null;
				for (int i = 0; i < itemMap.size(); i++) {
					if (itemMap.get(i).getSize() == size) {
						toAdd = itemMap.get(i);
						break;
					}
				}
				toAdd.setQuantity(Integer.valueOf(request
						.getParameter("quant")));
				itemMap.clear();
				//session.setAttribute("item", toAdd);
				//session.setAttribute("",);
				session.setAttribute("pid", toAdd.getPid());
				session.setAttribute("size", toAdd.getSize());
				session.setAttribute("quant", item.getQuantity());
				session.setAttribute("type", item.getPtype());
				session.setAttribute("discount", item.getDiscount());
				response.sendRedirect("addToCart.jsp");
			}

		} else {
			out.print("Error, no items in itemMap");
		}
	%>






</body>
</html>
<!-- 
	Trying to get this to work...
	
			if (currDate.compareTo(date) > 0){
				sql = "SELECT DISTINCT pid FROM Products WHERE pid <> ?";
				ps = con.prepareStatement(sql);
				ps.setInt(1,pid);
				rst = ps.executeQuery();
				int ctr = 0;
				while(rst.next()){
					ctr++;
				}
				int nextDeal = new java.util.Random().nextInt(ctr) + 1;
				int search = 0;
				rst = ps.executeQuery();
				while (search != ctr){
					search++;
					rst.next();
				}
				sql = "INSERT INTO Deals(pid,discount,duration) VALUES(?,?,?)";
				ps = con.prepareStatement(sql);
				ps.setInt(1,rst.getInt(1));
				int newDuration = (new java.util.Random().nextInt(60) + 1);
				if(newDuration < 10){
					newDuration += 10;
				}
				double newDiscount = new java.util.Random().nextDouble() * 1.0;
				newDiscount = Math.round(newDiscount*100.0)/100.0;
				ps.setDouble(2,newDiscount);
				ps.setInt(3,newDuration);
				ps.executeUpdate();
				//response.sendRedirect("main_page.jsp");
			}
			


 -->