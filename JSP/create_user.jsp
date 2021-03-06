<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create an Account</title>
<style>
	body {
		background-image: url("http://cdn4.coresites.mpora.com/whitelines_new/wp-content/uploads/2010/10/Gigi-Ruf-Snowboard-Wallpaper-1900x1200.jpg");
		background-attachment: fixed;
	}
	h1 {
		color: black;
		display-style: none;
	}
	input[type=submit] {
		border: white;
		background: transparent;
		color: black;
		font-family: "serif";
		font-size: 14pt;
		padding: 5px 5px;
		z-index: -1;
		width: 30x;
	}
	input[type=reset] {
		border: white;
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
  if (top.location != location) {
    top.location.href = document.location.href ;
  }
}
</script>
<body onLoad="breakout_of_frame()">
	
	<h1><strong><a href="login.jsp">Home</a></strong></h1>
	<%
		session = request.getSession();
		if(session.getAttribute("msg") != null){
			out.println("<font color=\"red\" <p align=\"center\">" + session.getAttribute("msg").toString() + "</p> </font>");
		}
	%>
	
	<h1 align="center">Welcome to <b><i>The Grid</i></b></h1>
	
	<form name="newUser" method="post" action="addUser.jsp">
		<table align="center" style="font-size:125%; background-color:#EEEEEE;width:300px">
		<tr><td>User name:</td> <td><input type="text" placeholder="Username" required name="userName"></td></tr>
		<tr><td>Password:</td><td> <input type="password" placeholder="Password" required name="password" ></td></tr>
		<tr><td>First Name:</td> <td><input type="text" placeholder="First Name" required name="fName"></td></tr>
		<tr><td>Last Name:</td><td><input type="text" placeholder="Last Name" required name="lName"></td></tr>
		<tr><td>Age:</td><td style="font-size:1.5x"><input type="number" required name="age"></td></tr>
		<tr><td>Sex:</td><td><input type="radio" value="M" name="gender">M <input type="radio" value="F" name="gender">F</td></tr>
		<tr><td align="center" colspan="2"> <b>Shipping Info:</b></td></tr>
		<tr><td>Street</td><td><input type="text" required name="street"></td></tr>
		<tr><td>City</td><td><input type="text" required name="city"></td></tr>
		<tr><td>Province</td><td><input type="text" required name="prov"></td></tr>
		<tr><td>Postal Code</td><td><input type="text" required name="zip"></td></tr>
		
		<tr><td>
		<h3>Select your preferences: </h3>
		</td></tr>
		<tr><td>Shirts</td><td><input type="checkbox" name="type" value="tshirt"></td><td>Shorts</td><td><input type="checkbox" name="type" value="shorts"></td></tr>
		<tr><td>Sweaters</td><td><input type="checkbox" name="type" value="sweaters"></td><td>Shoes</td><td><input type="checkbox" name="type" value="shoes"></td></tr>
		<tr><td>Snowboards</td><td><input type="checkbox" name="type" value="snowboard"></td><td>Jackets</td><td><input type="checkbox" name="type" value="jacket"></td></tr>
		<tr><td>Snowpants</td><td><input type="checkbox" name="type" value="snowpant"></td><td>Hats</td><td><input type="checkbox" name="type" value="hat"></td></tr>
		<tr><td>Belts</td><td><input type="checkbox" name="type" value="belt"></td><td>Pants</td><td><input type="checkbox" name="type" value="pant"></td></tr>
		<tr><td>Skateboards</td><td><input type="checkbox" name="type" value="skate"></td><td></td></tr>
		
		<tr align="center"><td><input type="submit" value="Register!"></td><td><input type="reset" value="Start Over"></td></tr>	
		</table>	
	</form>
</body>
</html>