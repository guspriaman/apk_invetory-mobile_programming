<?php

$token = getBearerToken();

verifyTokenExist($token);

$query = "update users set token = null where token = '$token'";

$execute = mysqli_query($connect, $query) or die(response(500, "Unable to logout from server", "fail", mysqli_error($connect)));

return response(200, "Logout berhasil", 'Ok');
