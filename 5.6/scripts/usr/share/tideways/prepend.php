<?php

if (extension_loaded('tideways')) {
    include ini_get('extension_dir') . '/Tideways.php';

    if (class_exists('Tideways/Profiler')) {
        \Tideways\Profiler::start();
    }
}

