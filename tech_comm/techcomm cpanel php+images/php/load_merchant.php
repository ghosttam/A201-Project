<?php
error_reporting(0);
include_once("dbconnect.php");
$location = $_POST['location'];
$rating = $_POST['rating'];

if (isset($_POST['productname'])){
$productname = $_POST['productname'];
 $sql ="SELECT DISTINCT MERCHANT.ID,MERCHANT.NAME,MERCHANT.PHONE,MERCHANT.LOCATION,MERCHANT.IMAGE,
    MERCHANT.RADIUS,MERCHANT.LATITUDE,MERCHANT.LONGITUDE,MERCHANT.DELIVERY,MERCHANT.RATING 
    FROM MERCHANT INNER JOIN PRODUCT ON MERCHANT.ID = PRODUCT.MERCID WHERE PRODUCT.PRODUCTNAME LIKE '%$productname%' 
    AND MERCHANT.LOCATION = '$location'";
    
}else{
if ($_POST['rating'] == "Highest"){
    $sql = "SELECT * FROM MERCHANT WHERE LOCATION = '$location' ORDER BY RATING DESC";
}else{
    $sql = "SELECT * FROM MERCHANT WHERE LOCATION = '$location' ORDER BY RATING ASC";
}    
}




$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["merc"] = array();
    $mercidarray = array();
    $i = 0;
    while ($row = $result ->fetch_assoc()){
        $merclist = array();
        $merclist[mercid] = $row["ID"];
        $merclist[mercname] = $row["NAME"];
        $merclist[mercphone] = $row["PHONE"];
        $merclist[merclocation] = $row["LOCATION"];
        $merclist[mercimage] = $row["IMAGE"];
        $merclist[mercradius] = $row["RADIUS"];
        $merclist[merclatitude] = $row["LATITUDE"];
        $merclist[merclongitude] = $row["LONGITUDE"];
        $merclist[mercdelivery] = $row["DELIVERY"];
        $merclist[mercrating] = $row["RATING"];
        $mercidarray[$i] = $row["ID"];
        $i++;
        array_push($response["merc"], $merclist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>