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
		$dateReserve = $_GET['dateReserve'];
		$status = $_GET['status'];
		
		
		
							
		$sql = "INSERT INTO `reserve`(`id`, `idBuyer`, `dateReserve`, `status`) VALUES (Null,'$idBuyer','$dateReserve','$status')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "poom";
   
}
	mysqli_close($link);
?>