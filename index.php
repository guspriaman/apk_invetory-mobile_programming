<?php

require_once "connection.php";
require_once "helper.php";

$action = $_GET['action'] ?? '';

setupHeader();

if ($action == '' || $action == null) {
  echo 'Action required';
  exit(0);
}

$request = (object) $_REQUEST;
$body    = (object) json_decode(file_get_contents('php://input'), true);

if (file_exists('actions/' . $action . ".php")) {
  require_once "actions/" . $action . ".php";
} else {
  return response(404, 'Action not found', 'false');
}
