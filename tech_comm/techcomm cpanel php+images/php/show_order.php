<?php
error_reporting(0);
include_once("dbconnect.php");
$mercid = $_POST['mercid'];
$sql = "SELECT * FROM PAID WHERE MERCID = '$mercid'"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["order"] = array();
    while ($row = $result ->fetch_assoc()){
        $orderlist = array();
        $orderlist[orderemail] = $row["EMAIL"];
        $orderlist[orderproductid] = $row["PRODUCTID"];
        $orderlist[orderproductquantity] = $row["PRODUCTQTY"];
        $orderlist[orderremarks] = $row["REMARKS"];
        $orderlist[ordermercid] = $row["MERCID"];
        $orderlist[ordertime] = $row["ORDERTIME"];
        array_push($response["order"], $orderlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>