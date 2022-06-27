<?php

$token = getBearerToken();

verifyTokenExist($token);

$id   = $request->id ?? null;
$nama = $body->nama ?? null;
$jenis = $body->jenis ?? null;

if ($id == null || $id == '') {
  return response(422, 'Id barang dibutuhkan');
}

// validasi input
if ($nama == null || $nama == '') {
  return response(422, 'Nama barang dibutuhkan');
}

if ($jenis == null || $jenis == '') {
  return response(422, 'Jenis barang dibutuhkan');
}

if (!in_array($jenis, $jenisBarang)) {
  $jenisBarangString = implode(",", $jenisBarang);
  return response(422, 'Jenis barang yang diperbolehkan hanya ' . $jenisBarangString);
}

// cek id ke database ada atau tidak
$query = "select * from barang where id = $id";
$execute = mysqli_query($connect, $query) or die(response(500, "Unable to find barang", 'fail', mysqli_error($connect)));

if (mysqli_num_rows($execute) < 1) {
  return response(404, "Barang tidak ditemukan");
}

$query = "
  update barang set nama = '$nama', jenis =  '$jenis' where id = $id
";

$execute = mysqli_query($connect, $query) or die(response(500, 'Failed to update barang', 'fail', mysqli_error($connect)));

return response(200, "Barang berhasil diubah", "Ok");
