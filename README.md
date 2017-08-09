PHP baseimage based on debian
=============================

PHP baseimage based on debian because we can use the PHP packages built by
[Ondřej Surý](https://deb.sury.org/).

Info
----

The baseimage has sufficient packages installed to be able to use composer. And
it also has composer, xdebug and optionally tideways that can be enabled for
development.

Usage
-----

~~~ sh
$ docker run dockerwest/php
~~~

Will run the chosen version php-fpm

~~~ sh
$ docker run dockerwest/php <some command>
~~~

Will run the command with the www-data user.

~~~ sh
$ docker run dockerwest/php /bin/bash
~~~

Will give you a container where you are logged in as root

Healthcheck
-----------

When you run `php-fpm` in the containers the healthcheck will monitor php-fpm
and when there is an issue the state will change from healthy to unhealthy.
When you use the images to just run some other commands we will automatically
assume the health is ok so after the first interval of 10 seconds the container
will be marked healthy.

To check the health you can run the following command:

~~~ sh
$ docker inspect --format='{{json .State.Health}}' <containername>
~~~

If you only want to get the textual state you can go further and use

~~~ sh
$ docker inspect --format='{{lower .State.Health.Status}}' <containername>
~~~

Environment variables
---------------------

We have the `C_UID` and `G_UID` environment variables if you want to change the
UID and/or GID of www-data.

And additionally there is the `DEVELOPMENT` environment variable wich will
enable xdebug, composer and tideways. If you want to run without profiling you
can pass along `DEVELOPMENT=noprofile`.

examples:

~~~ sh
$ docker run -e C_UID=1000 -e G_UID=1000 dockerwest/php
~~~

To run php-fpm as user www-data with UID 1000 and GID 1000, can be usefull for
development on Linux machines.

~~~ sh
$ docker run -e DEVELOPMENT=1 dockerwest/php
~~~

Enable all development features.

~~~ sh
$ docker run -e DEVELOPMENT=noprofile dockerwest/php
~~~

Only enable composer and xdebug.

Mailcatcher
-----------

When you use this in development mode with mailcatcher or mailhog, you must
give it the hostname `mailcatcher` to have it all working fine.

Versions
--------

The following versions are available:
- 5.6 : supported until 31 Dec 2018
- 7.0 : supported until 31 Dec 2018
- 7.1 : supported until 1 Dec 2019
- 7.2 : alpha release

License
-------

MIT License (MIT). See [License File](LICENSE.md) for more information.
