<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['id'];
$image = $_POST['image'];
   unlink('../images/productimages/'.$image.'.jpg');
    $sqldelete = "DELETE FROM PRODUCT WHERE PRODUCTID = '$id'";
        
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>

