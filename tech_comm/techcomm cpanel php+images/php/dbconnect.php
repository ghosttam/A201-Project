<?php
$servername = "localhost";
$username   = "steadybo_techcommadmin";
$password   = "S9sx18ZJnGKu";
$dbname     = "steadybo_techcomm";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
   die("Connection failed: " . $conn->connect_error);
}
?>