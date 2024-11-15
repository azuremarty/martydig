<?php
$output = [];
$return_var = 0;
exec('git pull 2>&1', $output, $return_var); // Capture both stdout and stderr

if ($return_var === 0) {
    echo "Git Pull Output:\n";
    echo implode("\n", $output);
} else {
    echo "Error executing git pull:\n";
    echo implode("\n", $output);
}
?>