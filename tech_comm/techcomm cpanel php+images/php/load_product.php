<?php
error_reporting(0);
include_once("dbconnect.php");
$mercid = $_POST['mercid'];
$sql = "SELECT * FROM PRODUCT WHERE MERCID = '$mercid'"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["product"] = array();
    while ($row = $result ->fetch_assoc()){
        $productlist = array();
        $productlist[productid] = $row["PRODUCTID"];
        $productlist[productname] = $row["PRODUCTNAME"];
        $productlist[productprice] = $row["PRODUCTPRICE"];
        $productlist[productqty] = $row["QUANTITY"];
        $productlist[productimg] = $row["IMAGENAME"];
        array_push($response["product"], $productlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>