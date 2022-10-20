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
		
		$idBuyer = $_GET['idBuyer'];
		$nameBuyer = $_GET['nameBuyer'];
		$phoneBuyer = $_GET['phoneBuyer'];
		$dateOrder = $_GET['dateOrder'];
		$idOwner = $_GET['idOwner'];
		$nameOwner = $_GET['nameOwner'];
		$phoneOwner = $_GET['phoneOwner'];
		$idProduct = $_GET['idProduct'];
		$nameProduct = $_GET['nameProduct'];
		$priceProduct = $_GET['priceProduct'];
		$status = $_GET['status'];
		
							
		$sql = "INSERT INTO `reservetable`(`idOrder`, `idBuyer`, `nameBuyer`, `phoneBuyer`, `dateOrder`, `idOwner`, `nameOwner`, `phoneOwner`, `idProduct`, `nameProduct`, `priceProduct`, `status`) VALUES (Null,'$idBuyer','$nameBuyer','$phoneBuyer','$dateOrder','$idOwner','$nameOwner','$phoneOwner','$idProduct','$nameProduct','$priceProduct','$status')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "bsruhorpak";
   
}
	mysqli_close($link);
?>