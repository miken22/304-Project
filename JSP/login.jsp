<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>

<link href="bootstrap/css/bootstrap.min.css" rel="stytlesheet" media="screen">
<link href="bootstrap/js/bootstrap.min.js" rel="stytlesheet" media="screen">

<style>
	body {
		background-image: url("http://cdn4.coresites.mpora.com/whitelines_new/wp-content/uploads/2010/10/Gigi-Ruf-Snowboard-Wallpaper-1900x1200.jpg");
		background-attachment: fixed;
	}
	h1 {
		font-family: "serif";
	}	
	p {
		color: blue;
		font-family: "serif";
		font-size: 10pt;
	}
	input[type=submit] {
		border: black;
		background: transparent;
		color: black;
		font-family: "serif";
		font-size: 15pt;
		padding: 5px 5px;
		z-index: -1;
		width: 100%;
		border: thin solid white;
	}
	form{
		position: relative;
		margin-left: 5%;
		margin-right: 5%;
	}
	#lgn table{
		border-color: white;
	}
	.center
	{
	margin-left:120%;
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
<body bgcolor="#EEEEE" onLoad="breakout_of_frame()">

	<h1 align="center">Welcome to <b><i>The Grid</i></b></h1>
	<%
		session = request.getSession();
		String src = request.getHeader("Referer");
		Boolean valid = (Boolean)session.getAttribute("valid");
		session.setAttribute("src", src);
		session.setAttribute("valid", valid);
		if (valid != null){
			if(!valid){
				out.println("<p align=\"center\">" + session.getAttribute("msg").toString() + "</p>");
			}
		}
	%>

	<form name="login" method="post" action="authenticate.jsp">
		<table id="lgn" BORDERCOLOR=WHITE align="center">
			<tr><td><b>Username</b>:</td><td><input type="text" class="span2" placeholder="Username" name="lgnuser" style="width:100%"></td></tr>
			<tr><td><b>Password</b>:</td><td><input type="password" placeholder="Password" name="lgnpswrd" style="width:100%"></td></tr>
			<tr><td><div class="center"><button class="btn btn-success pull-right" type="submit" value="Login"><b>Login</b></button></div></td></tr>	
		</table>
	</form>
	<form action="create_user.jsp">
		<table BORDERCOLOR=WHITE align="center">
			<tr><td colspan="70" width="100%"><button class="btn btn-primary" style="button-color:blue" type="submit" value="Create Account"><b>Create Account</b></button></td></tr>
		</table>
	</form>  
</body>
</html>