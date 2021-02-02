<?php
include_once("dbconnect.php");
$name = $_POST['name'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$mercid = $_POST['mercid'];
$image = $_POST['image'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/productimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);





if ($is_written > 0) {
    $sqlregister = "INSERT INTO PRODUCT(PRODUCTNAME,PRODUCTPRICE,QUANTITY,IMAGENAME,MERCID) VALUES('$name','$price','$quantity','$image','$mercid')";
    if ($conn->query($sqlregister) === TRUE){

        echo "success";
    }else{
        echo "failed";
    }
}else{
    echo "failed";
}


?>