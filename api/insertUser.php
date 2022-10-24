<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$user = $_GET['user'];
		$password = $_GET['password'];
		$name = $_GET['name'];
		$address = $_GET['address'];
		$phone = $_GET['phone'];
		$type = $_GET['type'];
		$avatar = $_GET['avatar'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		$token = $_GET['token'];
		
							
		$sql = "INSERT INTO `user`(`id`, `user`, `password`, `name`, `address`, `phone`, `type`, `avatar`, `lat`, `lng`, `token`) VALUES (Null,'$user','$password','$name','$address','$phone','$type','$avatar','$lat','$lng','$token')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome bsruhorpak";
   
}
	mysqli_close($link);
?>