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
				
		$idOwner = $_GET['idOwner'];
		$nameOwner = $_GET['nameOwner'];
		$name = $_GET['name'];
		$price = $_GET['price'];
		$detail = $_GET['detail'];
		$address = $_GET['address'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		$images = $_GET['images'];
		
		
		
							
		$sql = "INSERT INTO `product`(`id`, `idOwner`, `nameOwner`, `name`, `price`, `detail`, `address`, `lat`, `lng`, `images`) VALUES (Null,'$idOwner','$nameOwner','$name','$price','$detail','$address','$lat','$lng','$images')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>