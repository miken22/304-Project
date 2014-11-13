<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>The Grid</title>
<style>
body {   
	background-attachment: "fixed";
}
#greet div {
	position:relative;
	width: 100%;
}
#greet p{
	float:right;
}
</style>
</head>
<body>
	<%! private String fname = ""; %>
	<%! private String uname = ""; %>
	
	<div>
		<div id="greet">
			<%	
				session = request.getSession();
				try{
					fname = session.getAttribute("fname").toString();
					uname = session.getAttribute("lgnuser").toString();
					session.setAttribute("lgnuser", uname);
					out.println("<p>Welcome " + fname + "</p>");
				} catch (Exception e){
					out.println("");
				}
			%>
		</div>
	</div>
	<%@ include file="general_banner.html"%>


	<div id="header1">
		<h2>The DEAL:</h2>

		<%--Contact the database to acquire the product on sale --%>
		<%@ page import="java.sql.*"%>
		<%
			//Check for Driver
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
				Statement stmt= con.createStatement();
				String sql= "SELECT * FROM Deals ";
				ResultSet rst= stmt.executeQuery(sql);
			//TEST: Print result
				out.print("<table width=50% border=1>"+"<tr><th>Results from Deals</th></tr>");
				while (rst.next()){
					out.println("<tr><td>" + rst.getString(1) + "</td></tr>");
				}
				out.println("</table>");
			//Close Connection
				con.close();
			} catch (SQLException ex){
				//Print Error
				System.err.println(ex);
				out.println("<br><h1>Error 1</h1><br>");
			} finally {
				if (con != null)
				try {con.close();}
				catch (SQLException ex) {
					System.err.println(ex); 
				}
			}
		%>
	</div>


	<%@ include file="timer.html"%>

	<%--
	<%@ include file="itemHead.html" %>
	<%@ include file="itemInfo.html" %>	
	--%>

</body>
</html>
<!-- 
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">

		<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
		Remove this if you use the .htaccess 
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

		<title>Title of Website</title>

		<!-- CSS Styling 
		<style>
			body {
				background-attachment: "fixed";
			}

			#theDeal {

			}

			#itemPicture {
				display: block; /*nothing sits beside it*/
				vertical-align: top;
				position: inherit;
			}

			div img {
				max-height: 85%;
				max-width: 85%;
				min-height: 50%;
				min-width: 50%;
			}

			.box {
				border: 2px solid black;
				background-color: #ccff99;
				margin: 20px 15% 20px 15%;
			}
			
			/*temp*/
			div table{
				border: 1px dashed #0000ff;
			}
			/*temp*/
			div table td{
				border: 1px solid #0000ff;
			}
		</style>
	</head>

	<body>

		<div id="theDeal">
			<h2><em>The DEAL:</em></h2>
		</div>

		<div id="itemPicture" class='box'>
			<img src="http://skately.com/img/library/shoes/large/vans-shoes-chukka-low.jpg" />
		</div>

		<div id="itemInfo" class='box'>
			<table>
				<tr>
					<th colspan='2'>
						<h3>The name of the Product.</h3>
					</th>
				</tr>
			

			<tr>
				<td>
					<b>&nbsp;Price:</b>
				</td>
				<td>
					$19.06<!--!@#Price
				</td>
			</tr>
				
			<tr>
				<td>
					<b>&nbsp;Description:</b>
				</td>
				<td>
					<!--!@#Description
					<p>This product is especially good at being a product. I promise.</p>
				</td>
			</tr>

			<tr>
				<td>
					<b>&nbsp;Sizes:</b>
				</td>
				<td>
					<!--!@#Sizes. <Input>
						list sizes here
				</td>
			</tr>

			<tr>
				<td>
					<b>&nbsp;In Stock:</b>
				</td>
				<td>
					22 <!--!@#Stock
				</td>
			</tr>

			<tr>
				<td>
					<b>&nbsp;Product ID:</b>
				</td>
				<td>
					944<!--!@#pid
				</td>
			</tr>
			</table>
		</div>

	</body>
</html>
 -->