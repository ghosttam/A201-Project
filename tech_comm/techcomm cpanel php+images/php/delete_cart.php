<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$productid = $_POST['productid'];
    $sqldelete = "DELETE FROM PRODUCTORDER WHERE EMAIL = '$email' AND PRODUCTID='$productid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>