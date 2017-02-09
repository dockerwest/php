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
$ docker run blackikeeagle/php-debian
~~~

Will run the chosen version php-fpm

~~~ sh
$ docker run blackikeeagle/php-debian <some command>
~~~

Will run the command with the www-data user.

~~~ sh
$ docker run blackikeeagle/php-debian /bin/bash
~~~

Will give you a container where you are logged in as root

Environment variables
---------------------

We have the `C_UID` and `G_UID` environment variables if you want to change the
UID and/or GID of www-data.

And additionally there is the `DEVELOPMENT` environment variable wich will
enable xdebug, composer and tideways. If you want to run without profiling you
can pass along `DEVELOPMENT=noprofile`.

examples:

~~~ sh
$ docker run -e C_UID=1000 -e G_UID=1000 blackikeeagle/php-debian
~~~

To run php-fpm as user www-data with UID 1000 and GID 1000, can be usefull for
development on Linux machines.

~~~ sh
$ docker run -e DEVELOPMENT=1 blackikeeagle/php-debian
~~~

Enable all development features.

~~~ sh
$ docker run -e DEVELOPMENT=noprofile blackikeeagle/php-debian
~~~

Only enable composer and xdebug.

Versions
--------

The following versions are available:
- 5.6 : only security updates so you should use a higher version
- 7.0
- 7.1
