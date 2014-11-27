<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
#recommendation{
float: left;
height: 800px;
overflow: scroll;
width: 100%;
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

<%@ include file="validation.jsp"%>

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
	<div id="recommendation">
	<h2><strong>Recommendation for Today</strong></h2>
	<br>
	<%@ include file= "recommendations.jsp"%>
	</div>
</body>
</html>