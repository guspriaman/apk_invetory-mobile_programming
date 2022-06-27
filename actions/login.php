<?php

$username = $body->username ?? null;
$password = $body->password ?? null;

// validasi input
if ($username == null || $username == '') {
  return response(422, 'Username dibutuhkan');
}

if ($password == null || $password == '') {
  return response(422, 'Password dibutuhkan');
}

$query = "select * from users where username ='$body->username'";
$execute = mysqli_query($connect, $query);

$user = mysqli_fetch_object($execute);

if (mysqli_num_rows($execute) < 1 || !password_verify($body->password, $user->password,)) {
  return response(422, 'Akun anda tidak ditemukan di database kami!');
}

return response(200, 'Login berhasil', 'Ok', [], [
  'username' => $user->username,
  'nama' => $user->name,
  'token' => generateToken($user)
]);
