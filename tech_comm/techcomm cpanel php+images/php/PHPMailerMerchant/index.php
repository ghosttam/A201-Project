<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require 'src/Exception.php';
require 'src/PHPMailer.php';
require 'src/SMTP.php';

$mail = new PHPMailer(true);

include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$location = $_POST['location'];
$delivery = $_POST['delivery'];
$radius = $_POST['radius'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$password = sha1($_POST['password']);
$imagename = $_POST['imagename'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../../images/merchantimages/'.$imagename.'.jpg';
$is_written = file_put_contents($path, $decoded_string);
$otp = rand(1000,9999);
$rating = '0';

    //Server settings
    $mail->SMTPDebug = 2;                      
    $mail->isMail();                                           
    $mail->Host       = 'mail.steadybongbibi.com';                    
    $mail->SMTPAuth   = true;                                   
    $mail->Username   = 'techcommmerchant@steadybongbibi.com';                     
    $mail->Password   = 'techcomm123';                              
    $mail->SMTPSecure = 'SSL';  //tls       
    $mail->Port       = 465;    //587       
    
$sqlregister = "INSERT INTO MERCHANT(NAME,EMAIL,PHONE,PASSWORD,LOCATION,DELIVERY,RADIUS,LATITUDE,LONGITUDE,IMAGE,OTP,RATING) VALUES('$name','$email','$phone','$password','$location','$delivery','$radius','$latitude','$longitude','$imagename','$otp','$rating')";

if ($conn->query($sqlregister) === TRUE){
    echo "success";
    $mail->setFrom('techcommmerchant@steadybongbibi.com', 'Techcomm Merchant');
    $mail->addAddress($email, 'Receiver'); 
    $mail->isHTML(true);                                
    $mail->Subject = 'From Techcomm Merchant. Verify your merchant account';
    $mail->Body    = 'Hello '.$name.',<br/><br/>Thank you for register with us,'.' Please use the following link to verify your merchant account : <br/><br/>http://steadybongbibi.com/techcomm/php/verify_account_merc.php?email='.$email.'&key='.$otp;
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
    $mail->send();
}else{
    echo "failed";
}
