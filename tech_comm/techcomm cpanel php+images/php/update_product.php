<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];
$qty = $_POST['qty'];
$sqlupdate = "UPDATE PRODUCT SET PRODUCTNAME = '$name', PRODUCTPRICE = '$price', QUANTITY = '$qty' WHERE PRODUCTID = '$id'";
  if ($conn->query($sqlupdate) === TRUE){
      echo 'success';
  }else{
      echo 'failed';
  } 
?>