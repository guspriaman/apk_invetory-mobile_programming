<?php

$user = 'root';
$host = 'localhost';
$pass = '';
$dbName = 'flutter-api';


$connect = mysqli_connect($host, $user, $pass, $dbName) or die(response(500, "can't connect to database!", 'fail', mysqli_connect_error()));