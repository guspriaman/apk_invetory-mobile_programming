<?php

$token = getBearerToken();

verifyTokenExist($token);

$nama = $body->nama ?? null;
$jenis = $body->jenis ?? null;

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

$query = "
  insert into barang(nama, jenis) values ('$nama', '$jenis')
";

$execute = mysqli_query($connect, $query) or die(response(500, 'Failed to create barang', 'fail', mysqli_error($connect)));

return response(200, "Barang berhasil ditambahkan", "Ok");
