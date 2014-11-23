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
<title>Insert title here</title>
</head>
<body>

<!-- JSP Vars -->
<%
int pid1=0;
Date d1=new Date();
double discount=0.0;
int duration=0;
%>

	<!-- Get Session and DB Contact -->
	<%
		session = request.getSession();

		//Create Database Connection
		//Check for Driver
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (java.lang.ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: " + e);
		}
		//Establish Connection
		Connection con1 = null;
		try {
			//Credentials
			String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_mnowicki";
			String uid = "mnowicki";
			String pw = "92384072";
			//Connect	
			con1 = DriverManager.getConnection(url, uid, pw);
			
			//Collect most recent Deal from db.
			String sql = "SELECT * FROM Deals WHERE saleNum = (SELECT count(saleNum) FROM Deals)";
			PreparedStatement ps = con1.prepareStatement(sql);
			ResultSet rst = ps.executeQuery();
			rst.next();
			//most recent deal's properties:
			pid1 = rst.getInt(2);
			d1 = rst.getDate(3);
			discount = rst.getDouble(4);
			duration = rst.getInt(5);
			
	
			//!@#timer: For the old code below to be returned here.
			Date current=new Date();
			if(current.compareTo(d1)>0){
				//Need to update the deal
				out.println("<br><p>Time is invalid</p>");
			}
			

			//Close Connection
			con1.close();
		} catch (SQLException ex) {
			//Print Error
			System.err.println(ex);
			out.println("<br><h1>Error 3</h1><br>");
		}
	%>


<!-- Timer HTML -->
<%
out.println("<div id=\"testTimer\">");
out.println("<p>");
out.println("Start Date: <span id=\"testStart\"></span>.");
out.println("</p>");
out.println("<p>");
out.println("End date: <span id=\"testEnd\"></span>.");
out.println("</p>");
out.println("<p>");
out.println("Time Remaining: <span id=\"testRemaining\"></span>.");
	out.println("</p>");
out.println("</div>");
%>

<!-- DEBUGER HTML //!@#timer: Delete When Done -->
<%
out.println("<div id=\"debug\">");
out.println("<p>__________________________________________________________________</p>");
out.println("<p>Debug Console:</p><br>");
out.println("<p id=\"de1\"></p><br>");
out.println("<p id=\"de2\"></p><br>");
out.println("<p id=\"de3\"></p><br>");
out.println("<p id=\"de4\"></p><br>");
out.println("<p id=\"de5\"></p><br>");
out.println("<p id=\"de6\"></p><br>");
out.println("<p id=\"de7\"></p><br>");
out.println("<p id=\"de8\"></p><br>");
out.println("<p id=\"de9\"></p><br>");
out.println("<p id=\"de10\"></p><br>");
out.println("<p id=\"de11\"></p><br>");
out.println("<p id=\"de12\"></p><br>");
out.println("<p id=\"de13\"></p><br>");





out.println("</div>");
%>


<!-- Javascript Timer -->
<%
out.println("<script type=\"text/javascript\">");

//TEST: Date and Duration
//JS: Global Variables
out.println("var saleDuration ="+(int)(duration*60)+";"); //!@# note *60 for mins -> seconds
out.println("var saleHours, saleMinutes, saleSeconds;");
out.println("var dayMillis;");
out.println("var saleDate;");
//TEST: Global Vars. //later put back to non global
out.println("var totalMillis;");
out.println("var date;");

//Return the number of Millis in the d1 date given by the server	
		out.println("function dayMilliseconds(){");
		out.println("totalMillis = parseInt('"+d1.getTime()+"');");
		out.println("date = new Date("+d1.getYear()+", "+d1.getMonth()+", "+d1.getDay()+",0,0,0,0);");
		out.println("return (totalMillis-date)");
		out.println("}");
		out.println("dayMillis=dayMilliseconds();");
		
		//!@#TEST
		out.println("document.getElementById('de1').innerHTML ='Test Code:_____________'" + ";");
		out.println("document.getElementById('de2').innerHTML ='dayMillis ='+ dayMillis.toString()"+ ";");
		out.println("document.getElementById('de3').innerHTML ='totalMillis ='+ totalMillis.toString()"+ ";");
		out.println("document.getElementById('de4').innerHTML ='date (temp) =' + date.toLocaleDateString() + ' ' + date.toLocaleTimeString();");
		
		out.println("document.getElementById('de5').innerHTML ='d1.getYear ='"+ d1.toLocaleString()+";");
		out.println("document.getElementById('de6').innerHTML =" +"\"d1.getMonth =\""+d1.getMonth()+ ";");
		out.println("document.getElementById('de7').innerHTML =" +"\"d1.getDay =\""+d1.getDay()+ ";");
		//TEST

//Calculate the global saleHours, saleMinutes, saleSeconds, (from the dayMillis) 
		out.println("function setSaleTimes(Milliseconds){");
		out.println("var seconds = Milliseconds / 1000;");
		out.println("saleHours = Math.floor(seconds / 3600);");
		out.println("saleMinutes = Math.floor(seconds / 60) % 60;");
		out.println("saleSeconds = Math.floor(seconds % 60);");
		out.println("}");
		out.println("setSaleTimes(dayMillis)");
		
		//!@#TEST
		out.println("document.getElementById('de6').innerHTML =" +"\"saleSeconds =\"+saleSeconds.toString()"+ ";");
		out.println("document.getElementById('de7').innerHTML =" +"\"saleMinutes =\"+saleMinutes.toString()"+ ";");
		out.println("document.getElementById('de8').innerHTML =" +"\"saleHours =\"+saleHours.toString()"+ ";");
		
		//TEST

//Set THE saleDate
		out.println("saleDate = new Date("+d1.getYear()+", "+d1.getMonth()+", "+d1.getDay()+", saleHours, saleMinutes, saleSeconds, 0);");
		
		//!@#TEST
		out.println("document.getElementById('de9').innerHTML =" +"\"saleDate =\"+saleDate.toLocaleDateString() + \" \" + saleDate.toLocaleTimeString()"+ ";");
		//TEST
		
//Returns a time String based on input Milliseconds
			out.println("var stringTime = function(Milliseconds) {");
			out.println("var seconds = Milliseconds / 1000;");
			out.println("var hours = Math.floor(seconds / 3600);");
			out.println("var minutes = Math.floor(seconds / 60) % 60;");
			out.println("var second = Math.floor(seconds % 60);");
				out.println("if (minutes < 10) {");
				out.println("minutes = \"0\" + minutes;");
				out.println("}if (hours < 10) {");
				out.println("hours = \"0\" + hours;");
				out.println("}if (second < 10) {");
				out.println("second = \"0\" + second;}");
				out.println("return hours + \":\" + minutes + \":\" + second;}");
		
		
		
		//Date/Time Timer Method
		out.println("var dateTimer = function(startDate, durationSeconds) {");
			//now time
			out.println("var now = new Date();");
			//set the endDate object
			out.println("var endDate = startDate.getTime() + (durationSeconds * 1000);");
			out.println("endDate = new Date(endDate);");
			//TEST: console.log("The End Date is :"+endDate.toLocaleDateString()+" "+endDate.toLocaleTimeString());
			//calculate remaining
			out.println("var remaining = endDate.getTime() - now.getTime();");
			//TEST: console.log("remaining = "+endDate.getTime()+" - "+now.getTime()+" = "+remaining);

			//set HTML elements
			out.println("document.getElementById('testStart').innerHTML = startDate.toLocaleDateString() + \" \" + startDate.toLocaleTimeString();");
			out.println("document.getElementById('testEnd').innerHTML = endDate.toLocaleDateString() + \" \" + endDate.toLocaleTimeString();");
			out.println("document.getElementById('testRemaining').innerHTML = remaining + \" which is \" + stringTime(remaining);");
			
			//evaluate for remaining <=0
			out.println("if(remaining<=0){");
			out.println("console.log(\"Date/Timer has Expired.\");");
			out.println("clearInterval(dateTimerInterval);");
				//change timer field
				out.println("document.getElementById('testRemaining').innerHTML = \"Remaining Time is UP!\";");
				//!@#timer Attempting to reload testTimer.jsp
					out.println("console.log(\"Attempting to refresh the location from the javascript. location.reload(true)\")");
					out.println("location.reload(true);");
				out.println("}");
			out.println("}");
		
		//dateTimer() on an interval 
		out.println("var dateTimerInterval = setInterval('dateTimer(saleDate, saleDuration)', 1000);"); //!@#timer d1 is "saleDate".
		
		out.println("</script>");



%>


</body>
</html>

<!-- 


//SQL Statement To get the product on deal from the db
			sql = "SELECT * FROM Products WHERE pid=?;";
			ps = con.prepareStatement(sql);
			ps.setInt(1, pid);
			rst = ps.executeQuery();
			
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


 -->
 
 <!-- //out.println("var testStartDate = new Date(2014, 10, 22, 11, 0, 0, 0);"); -->