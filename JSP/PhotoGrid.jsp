<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<script>
function breakout_of_frame()
{
  if (top.location != location) {
    top.location.href = document.location.href ;
  }
}
</script>
<style>
html, body {
	background-image:
		url("http://cdn4.coresites.mpora.com/whitelines_new/wp-content/uploads/2010/10/Gigi-Ruf-Snowboard-Wallpaper-1900x1200.jpg");
	background-attachment: fixed;
}

iframe {
	margin-left: 10%;
	width: 80%;
	height: 500px;
	border: none;
}

h1 {
	color: black;
}

#banner, image {
	width: 100%;
}

#banner {
	width: 100%;
}

#menus {
	background-color: gray;
	overflow: hidden;
	width: 100%;
	height: auto;
	z-index: -2;
}

input[type=submit] {
	border: white;
	background: transparent;
	color: black;
	font-family: "serif";
	font-size: 15pt;
	padding: 5px 5px;
	z-index: -1;
	width: 100%;
}

#menus div {
	float: right;
	display: inline-block;
	height: auto;
	text-align: center;
	border-right: thin solid white;
	width: 125px;
}
#PhotoGrid
{
margin-top: 5%;
margin-bottom: 10% 
padding: 5px;
border-color: black;
border-style: solid;
}
</style>

<body>
<%@ include file="general_banner.html"%>
<body onLoad="breakout_of_frame()">
	<div id="PhotoGrid">
		<iframe src="Grid.jsp" align="center"
			onclick="javascript:resizeIframe(this);"> </iframe>
	</div>
	
</body>
</html>