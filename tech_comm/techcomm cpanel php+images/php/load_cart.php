<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM PRODUCTORDER WHERE EMAIL = '$email'";

$sql = "SELECT PRODUCTORDER.PRODUCTID, PRODUCTORDER.PRODUCTQTY, PRODUCTORDER.REMARKS, 
PRODUCTORDER.MERCID, PRODUCT.PRODUCTNAME, PRODUCT.IMAGENAME, PRODUCT.PRODUCTPRICE, PRODUCT.QUANTITY,
MERCHANT.NAME, MERCHANT.RADIUS,MERCHANT.LATITUDE, MERCHANT.LONGITUDE, MERCHANT.DELIVERY FROM PRODUCTORDER 
INNER JOIN PRODUCT ON PRODUCTORDER.PRODUCTID = PRODUCT.PRODUCTID 
INNER JOIN MERCHANT ON PRODUCTORDER.MERCID = MERCHANT.ID
WHERE PRODUCTORDER.EMAIL = '$email'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $cartlist = array();
        $cartlist[productid] = $row["PRODUCTID"];
        $cartlist[productqty] = $row["PRODUCTQTY"];
        $cartlist[remarks] = $row["REMARKS"];
        $cartlist[mercid] = $row["MERCID"];
        $cartlist[productname] = $row["PRODUCTNAME"];
        $cartlist[productprice] = $row["PRODUCTPRICE"];
        $cartlist[productimg] = $row["IMAGENAME"];
        $cartlist[mercname] = $row["NAME"];
        $cartlist[availqty] = $row["QUANTITY"];
        $cartlist[mercradius] = $row["RADIUS"];
        $cartlist[merclat] = $row["LATITUDE"];
        $cartlist[merclon] = $row["LONGITUDE"];
        $cartlist[mercdel] = $row["DELIVERY"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>