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
$password = sha1($_POST['password']);
$otp = rand(1000,9999);

    //Server settings
    $mail->SMTPDebug = 2;                      
    $mail->isMail();                                           
    $mail->Host       = 'mail.steadybongbibi.com';                    
    $mail->SMTPAuth   = true;                                   
    $mail->Username   = 'techcomm@steadybongbibi.com';                     
    $mail->Password   = 'techcomm123';                              
    $mail->SMTPSecure = 'SSL';  //tls       
    $mail->Port       = 465;    //587                               

$sqlregister = "INSERT INTO USER(NAME,EMAIL,PHONE,PASSWORD,OTP) VALUES('$name','$email','$phone','$password','$otp')";

if ($conn->query($sqlregister) === TRUE){
    echo "success";
    $mail->setFrom('techcomm@steadybongbibi.com', 'Techcomm');
    $mail->addAddress($email, 'Receiver'); 
    $mail->isHTML(true);                                
    $mail->Subject = 'From Techcomm. Verify your account';
    $mail->Body    = 'Hello '.$name.',<br/><br/>Thank you for register with us,'.' Please use the following link to verify your account : <br/><br/>http://steadybongbibi.com/techcomm/php/verify_account.php?email='.$email.'&key='.$otp;
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
    $mail->send();
}else{
    echo "failed";
}

