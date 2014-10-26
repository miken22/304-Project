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
	}
</style>
</head>
<body>

	<%@ include file="validation.jsp" %>
	<%! private String fname = ""; %>
	<%! private String uname = ""; %>
	
	<%
		session = request.getSession();
	
		try{
			fname = session.getAttribute("fname").toString();
			uname = session.getAttribute("lgnuser").toString();
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
	<%@ include file="login_banner.html" %>
	
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
			String cartQuery = "SELECT pid, quantity FROM Basket WHERE(uname='" + uname + "' AND shipped=0)";
			ResultSet rs = stmt.executeQuery(cartQuery);
			if(rs.next()){
				// Get size of results		
				int numOfItems = rs.getFetchSize();
				if (rs.last()) {
					  numOfItems = rs.getRow();
					  rs.beforeFirst();
				}
				rs.next();
				
				ArrayList<Integer> quantities = new ArrayList<Integer>(numOfItems);
				ArrayList<Integer> pids = new ArrayList<Integer>(numOfItems);
				for (int i = 0; i < numOfItems; i++){
					pids.add(rs.getInt(1));
					quantities.add(rs.getInt(2));
				}
				ArrayList<String> prodNames = new ArrayList<String>(numOfItems);
				ArrayList<Double> prices = new ArrayList<Double>(numOfItems);
				
				// Something falls apart here, will look at it tomorrow.
				for (int i = 0; i < numOfItems; i++){
					int pid = pids.get(i);
					int quantity = quantities.get(i);
					String priceQuery = "select pname, price FROM Products where pid = " + pid;
					PreparedStatement prepState = con.prepareStatement(priceQuery);
					prepState.setInt(1,rs.getInt(1));
					ResultSet prodRS = prepState.executeQuery();
					if(prodRS.next()){
						out.println(prodRS.getString(1));
					}
				}
				
				out.println(prodNames.size());
				
				for (int i = 0 ; i < prodNames.size(); i++){
					%>
						<table>
							<tr>
								<%
									out.println(prodNames.get(i));
								%>
							</tr>
						</table>
					<%
				}
				
			}
			
			
			
		} catch (Exception e){
			con.close();
		}
	%>
	
	
	
</body>
</html>