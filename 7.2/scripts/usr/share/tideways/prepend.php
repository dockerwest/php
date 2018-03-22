<?php

if (extension_loaded('tideways')
    && '/usr/local/bin/php-health.phar' !== $_SERVER['SCRIPT_NAME']
) {
    include ini_get('extension_dir') . '/Tideways.php';

    if (class_exists('Tideways/Profiler')) {
        \Tideways\Profiler::start();
    }
}

