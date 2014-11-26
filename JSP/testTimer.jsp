<%@page import="java.util.Date"%>

<%@page import="org.apache.catalina.filters.ExpiresFilter.XPrintWriter"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Random" %>
<%@ page import="java.text.DecimalFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
	.timeBox{
	background-color: #FF0000;
	border: 2px solid #000000;
	}
</style>
</head>
<body>

<!-- JSP Vars -->
<%
int pid1=0;
Date d1=new Date();
double discount=0.0;
int duration=0;
int d1year=0;
int d1month=0;
int d1day=0; 
int d1hour=0;
int d1min=0;
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
			//Connection	
			con1 = DriverManager.getConnection(url, uid, pw);
			
			//STEP 1: Decide which Deal from the Deals Table is valid.
				//Create a 'now' date.
				Date now=new Date();
				//Acquire all Deals from table
				String sql = "SELECT * FROM Deals;"; //Extra: WHERE saleNum = (SELECT count(saleNum) FROM Deals)
				PreparedStatement ps = con1.prepareStatement(sql);
				ResultSet rst = ps.executeQuery();
				
				//For each Deal, while there is a next deal, the now time must be in between the deal start and end time in order to break the loop
				int saleNum=0;
				found:
				while(rst.next()){
					//keep track of the deal's saleNum
					saleNum=rst.getInt("saleNum");
					//construct a date object that represents that deal
					Date dateStart=new Date(rst.getInt("sYear")-1900, rst.getInt("sMonth")-1, rst.getInt("sDay"), rst.getInt("hours"), rst.getInt("minutes"),0); //fix year
					//,accounting for the duration of that deal
					Date dateEnd=new Date(dateStart.getTime()+(rst.getInt("duration")*60*1000)); //from db, duration mins->millis
					//!@#TEST Display Deal Info
					System.out.println("___________________SaleNum: "+rst.getInt("saleNum")+
							".\nSaleDateStart="+dateStart.toLocaleString()+ ".\t\t Value="+dateStart.getTime()+
							".\nNow="+now.toLocaleString()+ ".\t\t\t Value="+now.getTime()+
							".\nSaleEndDate="+dateEnd.toLocaleString()+ ".\t\t Value="+dateEnd.getTime()+
							".\n[Now>=Start?]="+(now.getTime()>=dateStart.getTime())+
							".\n[Now<End?]="+(now.getTime()<dateEnd.getTime())+
							".\n");
					//check if valid: between start and end time
						if((now.getTime()>=dateStart.getTime())&&(now.getTime()<dateEnd.getTime())){
							break found;
						}
					
					//if the last deal isn't valid, no valid deals in table. Need to create a new one. (NOTE: rst.last()=true when no more rows)
						if(rst.isLast()){
							System.out.println("----------\nThere are no more vaid deals in the database.\nCreating a new one...");
							
							
							//STEP 1.1: Get All Products List
							sql = "SELECT DISTINCT pid FROM Products";
							ps = con1.prepareStatement(sql);
							rst = ps.executeQuery();
							//Count Number of Products
							int ctr = 0;
							while(rst.next()){
								ctr++;
							}
							System.out.println("Products in Database (ctr): "+ctr);
							
							
						
							//STEP 1.2: Create Random New Deal Variables
							int newPid=ctr;
							int newDeal=0; 
							int newSaleNum=0;
							Date newStartDate=new Date();
							double newDiscount=0.0;
							int newDuration=0;
							int newHours=0;
							int newMinutes=0;
							int newSMonth=0;
							int newSDay=0;
							int newSYear=0;
							
							System.out.println("\tNew Deal Properties:");
							
							
							newDiscount = (new java.util.Random().nextInt(99)+1.0)/100.0;
							System.out.println("newDiscount="+newDiscount);
							
														
							newDeal = new java.util.Random().nextInt(ctr); //!@# +1? I dont think so.
							System.out.println("Product DB Choice (newDeal): "+newDeal);
							
							//Get Product Info from selected product
							rst.first();
							rst.relative(newDeal);
							newPid=rst.getInt("pid");
							System.out.println("newPid: "+newPid);
							
							
							
							
							//STEP 1.3: Get LAST Deal in order to set new time variables
							sql = "SELECT * FROM Deals WHERE saleNum = (SELECT count(saleNum) FROM Deals)";
							ps = con1.prepareStatement(sql);
							ResultSet rst1 = ps.executeQuery();
							rst1.next();
							
							newSaleNum=rst1.getInt("saleNum")+1;
							System.out.println("newSaleNum="+newSaleNum);
							
							newDuration=60;//new Random().nextInt(2820)+60; //!@#Replace//60 mins to 2880 mins OR 1 hour to 2 days //Changed to random 1-60). Then if time<30{add 30;}
							System.out.println("newDuration="+newDuration);
							
							//Extract startdate of last deal
							Date pullDate=new Date(rst1.getInt("sYear")-1900, rst1.getInt("sMonth")-1, rst1.getInt("sDay"),rst1.getInt("hours"), rst1.getInt("minutes"),0);
							newStartDate=new Date(pullDate.getTime()+(rst1.getInt("duration")*60*1000));
							System.out.println("Pulled Date from Last Deal: \t\t"+pullDate.toLocaleString());
							System.out.println("Constructed newStartDate for New Deal: \t"+newStartDate.toLocaleString());
							
							//Evaluate a now date
							now=new Date();
							System.out.println("Now: "+now.toLocaleString());
											
							//set the new Deal Variables, based on calculated newStartDate
							System.out.println("\t***Calculating each new date parameter***");
							newSYear=newStartDate.getYear()+1900;
							newSMonth=newStartDate.getMonth()+1;
							newHours=newStartDate.getHours();
							newMinutes=newStartDate.getMinutes();
							newSDay=(int)(newStartDate.getTime()-(new Date(newSYear, newSMonth,1,newHours,newMinutes,0).getTime()))/86400000;
							System.out.println("newSYear="+newSYear+"\nnewSMonth="+newSMonth+"\nnewSDay="+newSDay+"\nnewHours="+newHours+"\nnewMinutes="+newMinutes+"\n******");
							//create the newStartDate date
							String finalDate="'"+newSYear+"-"+newSMonth+"-"+newSDay+" "+newHours+":"+newMinutes+":0'"; //!@#pickup
							
	
							//STEP 1.4: WRITE new deal to db deals
							sql="INSERT INTO Deals VALUES ("+newSaleNum+","+newPid+","+finalDate+","+newDiscount+","+newDuration+","+newHours+","+newMinutes+","+newSMonth+","+newSDay+","+newSYear+");";
							System.out.println("sql="+"INSERT INTO Deals VALUES ("+newSaleNum+","+newPid+","+finalDate+","+newDiscount+","+newDuration+","+newHours+","+newMinutes+","+newSMonth+","+newSDay+","+newSYear+");");
							ps = con1.prepareStatement(sql);
							ps.execute();
							System.out.println("STOP----------------------------------------Redirecting");
							//Redirect to main page
							response.sendRedirect("main_page.jsp");
							
						}//deal creation
					
					
				}//while
							
			//Display salenum to console for checking
			System.out.println("The first valid sale is: 'saleNum'="+saleNum+".");
		
			
			//STEP 2: Acquire Correct Deal, given saleNum, from the db
			try{
				sql = "SELECT * FROM Deals WHERE saleNum='"+saleNum+"';"; 
				ps = con1.prepareStatement(sql);
				rst = ps.executeQuery();
				rst.next();
			
			//STEP 3: With the correct Deal identified, set the Timer with it's properties.
			pid1 = rst.getInt(2);
			d1 = rst.getDate(3);
			discount = rst.getDouble(4);
			duration = rst.getInt(5);
			d1hour=rst.getInt(6);
			d1min=rst.getInt(7);
			d1month=rst.getInt(8);
			d1day=rst.getInt(9);
			d1year=rst.getInt(10);
			}catch(Exception x){
				System.out.println("Something has gone wrong. LOL?");
				x.printStackTrace();
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
//Styling elements for the timer span are located in the css inside of this (testTimer.jsp) file at the top of the page
out.println("<div id=\"testTimer\">");
out.println("<h1>");
out.println("<span id='testDiscount'></span>% off for <span id=\"testRemaining\" class='timeBox'></span>");
out.println("</h1>");
out.println("<p>");
out.println("Sale Ends on <span id=\"testEnd\"></span>.");
out.println("</p>");
out.println("</div>");
%>


<!-- DEBUGER HTML -->
<%
out.println("<div id=\"debug\">");
out.println("<p>__________________________________________________________________</p>");
out.println("<p>Debug Console:</p><br>");
out.println("<p id='de1'></p><br>");
out.println("<p id='de2'></p><br>");
out.println("<p id='de3'></p><br>");
out.println("<p id='de4'></p><br>");
out.println("<p id='de5'></p><br>");
out.println("<p id='de6'></p><br>");
out.println("</div>");
%>


<!-- JavaScript Timer //!@#ACCEPTED-->
<%
out.println("<script type=\"text/javascript\">");

//VARIABLES:
//Parse Out Correctly Formated Values from (depricated) Date Methods
	//duration (NOTE: need *60 for mins -> seconds)
		duration=duration*60;
		out.println("var saleDuration = "+duration+";");
		System.out.println("duration="+duration+".");	
	//d1year
		System.out.println("d1year="+d1year+".");
	//d1month (NOTE: month-1 needed for javascript date creation [months: 0-11])
		d1month=d1month-1;
		System.out.println("d1month-1="+(d1month)+" (NOTE: months 0-11).");
	//d1day //!@# .getDay() DOES NOT WORK
		System.out.println("d1day="+d1day+".");
	//d1hour
		System.out.println("d1hour="+d1hour+".");
	//d1min
		System.out.println("d1min="+d1min+".");
	//discount
		discount=discount*100;
		System.out.println("discount="+discount+".");

	
//Calculate saleStartDate
	out.println("var saleStartDate = new Date("+d1year+","+d1month+","+d1day+","+d1hour+","+d1min+",0,0"+");");
	//out.println("var saleStartDate = new Date(2014,10,23,2,30,0,0);");
	System.out.println("The saleStartDate is ="+d1year+","+d1month+","+d1day+","+d1hour+","+d1min+",0,0.");

//Calculate saleEndDate
	out.println("var saleEndDate = new Date(saleStartDate.getTime()+(saleDuration*1000));");

//Print Dates to Javascript Debug Div
	//out.println("document.getElementById('de1').innerHTML = 'saleDuration ='+saleDuration;");
	//out.println("document.getElementById('de2').innerHTML ='saleStartDate =' + saleStartDate.toLocaleDateString() + ' , ' + saleStartDate.toLocaleTimeString();");
	//out.println("document.getElementById('de3').innerHTML ='saleEndDate =' + saleEndDate.toLocaleDateString() + ' , ' + saleEndDate.toLocaleTimeString();");
		
		
//TIMER
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
			//out.println("document.getElementById('testStart').innerHTML = startDate.toLocaleDateString() + \" \" + startDate.toLocaleTimeString();");
			out.println("document.getElementById('testEnd').innerHTML = endDate.toLocaleDateString() + \" @ \" + endDate.toLocaleTimeString();");
			out.println("document.getElementById('testRemaining').innerHTML = stringTime(remaining);");
			out.println("document.getElementById('testDiscount').innerHTML = "+discount+";"); //new
			
			
			//evaluate for remaining <=0
			out.println("if(remaining<=0){");
			out.println("console.log(\"Date/Timer has Expired.\");");
			out.println("clearInterval(dateTimerInterval);");
				//change timer field
				out.println("document.getElementById('testRemaining').innerHTML = \"This Deal is Done!\";");
				//!@#timer Attempting to reload testTimer.jsp
				out.println("console.log(\"Attempting to refresh the location from the javascript. location.reload(true)\")");
				out.println("location.reload(true);");
				out.println("}");
			out.println("}");
		
//dateTimer() ON AN INTERVAL 
		out.println("var dateTimerInterval = setInterval('dateTimer(saleStartDate, saleDuration)', 1000);"); //NOTE: d1(in the JSP) is "saleStartDate"(int the JavaScript).

//close Javascript		
	out.println("</script>");
%>



</body>
</html>
<!-- Original Timer HTML

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
 -->


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
 
<!-- Original Connection Code (non timer) 
<!-- Get Session and DB Contact -->
	<%--
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
			d1hour=rst.getInt(6);
			d1min=rst.getInt(7);
			d1month=rst.getInt(8);
			d1day=rst.getInt(9);
			d1year=rst.getInt(10);
			
	
			//!@#timer: This condition isnt valid
			Date current=new Date();
			if(current.compareTo(d1)>0){
				//Need to update the deal
				//out.println("<br><p>Time is invalid</p>");
			}
			

			//Close Connection
			con1.close();
		} catch (SQLException ex) {
			//Print Error
			System.err.println(ex);
			out.println("<br><h1>Error 3</h1><br>");
		}
	--%>
