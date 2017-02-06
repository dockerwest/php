<?php

if (extension_loaded('tideways')) {
    tideways_enable(
        TIDEWAYS_FLAGS_CPU
        | TIDEWAYS_FLAGS_MEMORY
        | TIDEWAYS_FLAGS_NO_SPANS
    );

    register_shutdown_function(
        function() {
            $data = tideways_disable();
            file_put_contents(
                "/var/www/xhprof/"
                    . number_format(microtime(true), 4)
                    . ".xhprof",
                json_encode($data)
            );
        }
    );
}

