<?php

$token = getBearerToken();

verifyTokenExist($token);

$id = $request->id ?? null;

if ($id == null || $id == '') {
  return response(422, 'Id barang dibutuhkan');
}

$query = "select * from barang where id = $id";
$execute = mysqli_query($connect, $query) or die(response(500, "Unable to find barang", 'fail', mysqli_error($connect)));

if (mysqli_num_rows($execute) < 1) {
  return response(404, "Barang tidak ditemukan");
}

return response(200, "Barang ditemukan", "ok", [], mysqli_fetch_object($execute));
