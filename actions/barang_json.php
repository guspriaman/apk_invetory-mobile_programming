<?php

$token = getBearerToken();

verifyTokenExist($token);

$query = "select * from barang";
$execute = mysqli_query($connect, $query) or die(response(500, "Unable to find barang", 'fail', mysqli_error($connect)));

$result = [];

while($row = mysqli_fetch_object($execute)) {
  $result[] = $row;
}

if (mysqli_num_rows($execute) < 1) {
  return response(404, "Barang tidak ditemukan");
} else {
  return response(200, "Barang ditemukan", "ok", [], $result);
}
