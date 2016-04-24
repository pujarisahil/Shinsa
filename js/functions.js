function getUsername(username) {
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function () {
		if (xhttp.readyState == 4 && xhttp.status == 200) {
			var username = JSON.parse(xhttp.responseText).username;
			var score = JSON.parse(xhttp.responseText).score;
		}
	};
	xhttp.open("POST", "/get_user_info", true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send("username=" + username);
}
