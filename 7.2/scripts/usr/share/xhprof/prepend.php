<?php

if (extension_loaded('tideways')
    && '/usr/local/bin/php-health.phar' !== $_SERVER['SCRIPT_NAME']
) {
    tideways_enable(
        TIDEWAYS_FLAGS_CPU
        | TIDEWAYS_FLAGS_MEMORY
        | TIDEWAYS_FLAGS_NO_SPANS
    );

    register_shutdown_function(
        function() {
            ignore_user_abort(true);
            flush();

            $data['profile'] = tideways_disable();

            $uri = array_key_exists('REQUEST_URI', $_SERVER)
                ? $_SERVER['REQUEST_URI']
                : null;
            if (empty($uri) && isset($_SERVER['argv'])) {
                $cmd = basename($_SERVER['argv'][0]);
                $uri = $cmd . ' '
                    .implode(' ', array_slice($_SERVER['argv'], 1));
            }

            $time = array_key_exists('REQUEST_TIME', $_SERVER)
                ? $_SERVER['REQUEST_TIME']
                : time();
            $requestTimeFloat = explode('.', $_SERVER['REQUEST_TIME_FLOAT']);
            if (!isset($requestTimeFloat[1])) {
                $requestTimeFloat[1] = 0;
            }

            $requestTs = [
                'sec' => $time,
                'usec' => 0
            ];
            $requestTsMicro = [
                'sec' => $requestTimeFloat[0],
                'usec' => $requestTimeFloat[1]
            ];

            $data['meta'] = [
                'url' => $uri,
                'SERVER' => $_SERVER,
                'get' => $_GET,
                'env' => $_ENV,
                'simple_url' => preg_replace('/\=\d+/', '', $uri),
                'request_ts' => $requestTs,
                'request_ts_micro' => $requestTsMicro,
                'request_date' => date('Y-m-d', $time),
            ];

            file_put_contents(
                "/xhprof/"
                    . number_format(microtime(true), 4, '', '.')
                    . ".xhprof",
                json_encode($data)
            );
        }
    );
}

