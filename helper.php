<?php

$jenisBarang = ['sparepart', 'peripheral', 'atk'];

if (!function_exists('response')) {
  function response($code = 200, $message = '', $status = 'Ok', $errors = null, $data = null)
  {
    if ($code == 422 && $status = 'Ok') {
      $status = 'validation failed';
    }
    $responseMap = [
      'code' => $code,
      'message' => $message,
      'status' => $status,
    ];

    if ($errors !== null) {
      $responseMap['errors'] = $errors;
    }

    if ($data !== null) {
      $responseMap['data'] = $data;
    }

    http_response_code($code);
    echo json_encode($responseMap);
    exit(0);
  }
}

if (!function_exists('setupHeader')) {
  function setupHeader()
  {
    header('Origin: *');
    header('Accept: application/json');
    header('Content-Type: application/json');
  }
}

if (!function_exists('generateToken')) {
  function generateToken($user)
  {
    global $connect;

    $token = password_hash($user->id, PASSWORD_DEFAULT);

    $query = "update users set token = '$token' where id = $user->id";
    mysqli_query($connect, $query) or die(response(500, "Failed to update token to user table", 'fail', mysqli_error($connect)));

    return $token;
  }
}

if (!function_exists('getAuthorizationHeader')) {
  function getAuthorizationHeader()
  {
    $headers = null;
    if (isset($_SERVER['Authorization'])) {
      $headers = trim($_SERVER["Authorization"]);
    } else if (isset($_SERVER['HTTP_AUTHORIZATION'])) { //Nginx or fast CGI
      $headers = trim($_SERVER["HTTP_AUTHORIZATION"]);
    } elseif (function_exists('apache_request_headers')) {
      $requestHeaders = apache_request_headers();
      // Server-side fix for bug in old Android versions (a nice side-effect of this fix means we don't care about capitalization for Authorization)
      $requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
      //print_r($requestHeaders);
      if (isset($requestHeaders['Authorization'])) {
        $headers = trim($requestHeaders['Authorization']);
      }
    }
    return $headers;
  }
}

if (!function_exists('getBearerToken')) {
  function getBearerToken()
  {
    $headers = getAuthorizationHeader();
    // HEADER: Get the access token from the header
    if (!empty($headers)) {
      if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
        return $matches[1];
      }
    }
    return null;
  }
}

if (!function_exists('verifyTokenExist')) {
  function verifyTokenExist($token)
  {
    global $connect;
    $query  = "select * from users where token = '$token'";
    $execute = mysqli_query($connect, $query) or die(response(500, "Unable to search token", "fail", mysqli_error($connect)));

    if (mysqli_num_rows($execute) < 1) {
      return response(401, 'Token tidak ditemukan', 'Unauthorized');
    }
  }
}
