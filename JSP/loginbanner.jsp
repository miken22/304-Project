<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<style>
h1 {
	color: red
}

#banner, image {
	width: 100%;
}

#menus {
	background-color: red;
	overflow: hidden;
	width: 100%;
	height: auto;
	z-index: -2;
}

input[type=submit] {
	border: red;
	background: transparent;
	color: #fff;
	font-family: "serif";
	font-size: 14pt;
	padding: 5px 5px;
	z-index: -1;
	width: 30x;
}

#menus div {
	float: right;
	display: inline-block;
	height: auto;
	text-align: center;
	border-right: thin solid white;
	width: 125px;
}
</style>

</head>
<body>

	<%
		String name = session.getAttribute("fname").toString();
		out.println(name);
		
	%>
	<div>
		<div>
			<div id="greet">
				<div id="userGreeting">
					<% out.println("Welcome" + name); %>
				</div>
			</div>
			<div id="menus">
				<div>
					<form action="logout.jsp">
						<input type="submit" value="Logout">
					</form>
				</div>
			</div>
			<div id="banner">
				<h1>The Grid</h1>
			</div>

		</div>
	</div>


</body>
</html>