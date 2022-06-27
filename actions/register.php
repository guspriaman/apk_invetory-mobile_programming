<?php
$name     = $body->nama ?? null;
$username = $body->username ?? null;
$password = $body->password ?? null;

if ($name == null || $name == '') {
  return response(422, 'Nama dibutuhkan');
}

if ($username == null || $username == '') {
  return response(422, 'Username dibutuhkan');
}

if ($password == null || $password == '') {
  return response(422, 'Password dibutuhkan');
}


// cek username unique
$query = "select username from users where username = '$username'";
$execute = mysqli_query($connect, $query);

if (mysqli_num_rows($execute) > 0) {
  return response(422, 'Username sudah terdaftar');
}

$passwordHashed = password_hash($password, PASSWORD_DEFAULT);

$query = "insert into users(name, username, password) 
            values(
              '$body->nama', 
              '$body->username', 
              '$passwordHashed'
            )";

$execute = mysqli_query($connect, $query) or die(response(500, 'Failed to register user', 'fail', mysqli_error($connect)));

$query = "select *, name as nama from users where username = '$body->username'";

$execute = mysqli_query($connect, $query) or die(response(500, 'Failed to select user', 'fail', mysqli_error($connect)));

$user = mysqli_fetch_object($execute);


return response(200, 'Registrasi berhasil', 'Ok', [], [
  'username' => $username,
  'nama' => $name,
  'token' => generateToken($user)
]);
