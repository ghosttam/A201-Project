<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$productid = $_POST['productid'];
$productqty = $_POST['productqty'];
$remarks = $_POST['remarks'];
$mercid = $_POST['mercid'];


$sqlmercidcheck ="SELECT * FROM PRODUCTORDER WHERE EMAIL = '$email'";
$resultidcheck = $conn->query($sqlmercidcheck);
if ($resultidcheck->num_rows > 0) {
     while ($row = $resultidcheck ->fetch_assoc()){
         if ($row["MERCID"] != $mercid ){
             $mid = $row["MERCID"];
             $sqldelete = "DELETE FROM PRODUCTORDER WHERE EMAIL = '$email' AND MERCID= '$mid'";
            $conn->query($sqldelete);
         }
    }
}

$sqlcheck = "SELECT * FROM PRODUCTORDER WHERE PRODUCTID = '$productid' AND EMAIL = '$email'";
$result = $conn->query($sqlcheck);
if ($result->num_rows > 0) {
   $sqlupdate = "UPDATE PRODUCTORDER SET PRODUCTQTY = '$productqty' , REMARKS = '$remarks' WHERE PRODUCTID = '$productid' AND EMAIL = '$email'";
  if ($conn->query($sqlupdate) === TRUE){
      echo "success";
   }  
}
else{
  $sqlinsert = "INSERT INTO PRODUCTORDER(EMAIL,PRODUCTID,PRODUCTQTY,REMARKS,MERCID) VALUES ('$email','$productid','$productqty','$remarks','$mercid')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    }    
}

?>