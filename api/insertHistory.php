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
				
		$id = $_GET['id'];
        $idBuyer = $_GET['idBuyer'];
        $nameBuyer = $_GET['nameBuyer'];
        $phoneBuyer = $_GET['phoneBuyer'];
        $nameProduct = $_GET['nameProduct'];
		
		
							
		$sql = "INSERT INTO `history`(`id`, `idBuyer`, `nameBuyer`, `phoneBuyer`, `nameProduct`) VALUES (Null,'$idBuyer','$nameBuyer','$phoneBuyer','$nameProduct')";

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