<?php
$host = 'db';
$user = 'appuser';
$pass = 'apppassword';
$dbname = 'appdb';

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}

$result = $conn->query('SELECT message FROM greetings LIMIT 1');
$row = $result->fetch_assoc();

echo '<h1>PHP + MySQL Docker Compose App</h1>';
echo '<p>' . $row['message'] . '</p>';
?>