<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>addint to cart</title>
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
	<%
		String uname = "";
		session = request.getSession();
		try{
			uname = session.getAttribute("lgnuser").toString();
			out.println(uname);
		} catch (NullPointerException e){
			session.setAttribute("msg", "You must be logged in to do this.");
			//response.sendRedirect("login.jsp");
		}
		Items item = new Items();//(Items)session.getAttribute("item");
		item.setPid((Integer)session.getAttribute("pid"));
		item.setSize((Integer)session.getAttribute("size"));
		item.setQuantity((Integer)session.getAttribute("quant"));
		item.setPtype((String)session.getAttribute("type"));
		item.setDiscount((Double)session.getAttribute("discount"));
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
			
			sql = "SELECT * FROM Basket WHERE uname=? AND pid=? AND size=? AND shipped=0";
			ps = con.prepareStatement(sql);
			ps.setString(1,uname);
			ps.setInt(2,item.getPid());
			ps.setInt(3,item.getSize());
			rs = ps.executeQuery();
			// Case where user has item in basket already:
			if (rs.next()){
				sql = "UPDATE Basket SET quantity=? WHERE uname=? AND pid=? AND size=?";
				ps = con.prepareStatement(sql);
				ps.setInt(1,rs.getInt(3) + item.getQuantity());
				ps.setString(2,uname);
				ps.setInt(3,item.getPid());
				ps.setInt(4,item.getSize());
				ps.executeUpdate();
			} else {
				sql = "INSERT INTO Basket VALUES(?,?,?,?,0,0,?,?)";
				ps = con.prepareStatement(sql);
				ps.setString(1,uname);
				ps.setInt(2,item.getPid());
				ps.setInt(3,item.getQuantity());
				ps.setString(4,item.getPtype());
				ps.setDouble(5,item.getDiscount());
				ps.setInt(6,item.getSize());
				ps.executeUpdate();				
			}
			ps.close();
			con.close();
			
			response.sendRedirect("shopping_cart.jsp");
		
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	%>
	
</body>
</html>