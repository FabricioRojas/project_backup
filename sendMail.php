require_once "Mail.php";

$from = '<'.$argv[2].'>';
$to = '<'.$argv[1].'>';
$subject = 'Project backup';

if (isset($_SERVER['HTTP_CLIENT_IP'])) $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
else if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
else if (isset($_SERVER['HTTP_X_FORWARDED'])) $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
else if (isset($_SERVER['HTTP_FORWARDED_FOR'])) $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
else if (isset($_SERVER['HTTP_FORWARDED'])) $ipaddress = $_SERVER['HTTP_FORWARDED'];
else if (isset($_SERVER['REMOTE_ADDR'])) $ipaddress = $_SERVER['REMOTE_ADDR'];
else $ipaddress = 'UNKNOWN';

$headers = array(
    'From' => $from,
    'To' => $to,
    'Subject' => $subject
);

$smtp = Mail::factory('smtp', array(
    'host' => 'ssl://smtp.sendgrid.net',
    'port' => '465',
    'auth' => true,
    'username' => "$argv[2]",
    'password' => "$argv[3]"
));
var_dump($argv);
var_dump(array(
    'host' => 'ssl://smtp.sendgrid.net',
    'port' => '465',
    'auth' => true,
    'username' => "$argv[2]",
    'password' => "$argv[3]"
));

$argv = array_splice($argv, 4);
$body = "There was an error during the backup from '$argv[0]' with IP $ipaddress\nError log:\n" . implode(" ", $argv);

$mail = $smtp->send($to, $headers, $body);

if (PEAR::isError($mail)) {
    echo $mail->getMessage();
} else {
    echo "Message sent: ".$body;
}