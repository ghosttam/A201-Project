<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];

if ($paidstatus=="true"){
  $receiptid = $_GET['billplz']['id'];
  $signing = '';
    foreach ($data as $key => $value) {
        $signing.= 'billplz'.$key . $value;
        if ($key === 'paid') {
            break;
        } else {
            $signing .= '|';
        }
    }
    
    $signed= hash_hmac('sha256', $signing, 'S-5p8o0H6EhrFV1hJumpnJ8w');
    if ($signed === $data['x_signature']) {
        
        $sqlproductorder ="SELECT * FROM PRODUCTORDER WHERE EMAIL = '$userid'";
        $productorderresult = $conn->query($sqlproductorder);
        if ($productorderresult->num_rows > 0)
        {
        while ($row = $productorderresult->fetch_assoc())
        {
            $productid = $row["PRODUCTID"];
            $productqty = $row["PRODUCTQTY"]; //cart qty
            $productrem = $row["REMARKS"];
            $mercid = $row["MERCID"];
            $sqlinsertintopaid = "INSERT INTO PAID(EMAIL,PRODUCTID,PRODUCTQTY,REMARKS,MERCID) VALUES ('$userid','$productid','$productqty','$productrem','$mercid')";
            $conn->query($sqlinsertintopaid);
            
        }
        }
        
        
        $sqldeleteproductorder = "DELETE FROM PRODUCTORDER WHERE EMAIL = '$userid'";
        $conn->query($sqldeleteproductorder);
    }
     echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border=1 width=80% align=center>
     <tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press exit button on top right corner to return to TechComm</center></p></div></body>';
}
else{
     echo '<br><br><body><div><h2><br><br><center>Payment Failed!</center> 
      </h1>
     <table border=1 width=80% align=center>
     </tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press exit button on top right corner to return to TechComm</center></p></div></body>';
}
?>