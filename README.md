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

You can simply run a php container based on dockerwest. Note that you will have
to set which specific base version you want to use. The dockerwest images do
not have a 'latest' tag. See Versions to find out what versions are supported.

~~~ sh
$ docker run dockerwest/php:<version>
~~~

Will run the chosen version php-fpm

~~~ sh
$ docker run dockerwest/php:<version> <some command>
~~~

Will run the command with the www-data user.

~~~ sh
$ docker run dockerwest/php:<version> /bin/bash
~~~

Will give you a container where you are logged in as root

Building with dockerwest as base
--------------------------------

When you use the dockerwest php images as base and you have to add additional
commands or checks before a command can be executed you can add an additional
shell script named `/prepare-command.sh`. The commands you put in that script
will be run after our normal prepare but before the command you pass along so
by default before `php-fpm`.

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

PHP >= 7.4 preload
------------------

If you want to enable [preloading][] in your application place `preload.php` in
the root of your application. Keep in mind, the more you preload the longer it
will take for the php server to start.

*NOTE* When `DEVELOPMENT = 1` preloading will not be enabled.

Environment variables
---------------------

### C_UID / C_GID

We have the `C_UID` and `C_GID` environment variables if you want to change the
UID and/or GID of www-data.

~~~ sh
$ docker run -e C_UID=1000 -e G_UID=1000 dockerwest/php:<version>
~~~

To run php-fpm as user www-data with UID 1000 and GID 1000, can be usefull for
development on Unix like machines.

### DEVELOPMENT

There is the `DEVELOPMENT` environment variable wich will enable xdebug,
composer and enable timestamp checking in opcache. Additionally it will enable
the use of the `PHP_EXTRA_MODULES` environment variable.

~~~ sh
$ docker run -e DEVELOPMENT=1 dockerwest/php:<version>
~~~

When `DEVELOPMENT` is enabled xdebug should work out of the box. When you have
issues - like while running docker for mac - you can set the extra environment
variable `XDEBUG_CONFIG` with your hosts ip in it so xdebug can properly
connect back.

example:

~~~ sh
$ docker run -e DEVELOPMENT=1 -e "XDEBUG_CONFIG=remote_host=192.168.65.1" dockerwest/php:<version>
~~~

### PHP_EXTRA_MODULES

You can install extra php modules when starting a new container by using the
`PHP_EXTRA_MODULES` environment variable, this requires the `DEVELOPMENT`
environment variable.  For production ready images make use of the
`/usr/local/bin/extensions` helper to install addtional PHP modules.

~~~ sh
$ docker run -e DEVELOPMENT=1 -e "PHP_EXTRA_MODULES=mongodb zmq" dockerwest/php:<version>
~~~

### PROFILER

When a supported 'profiler' is set in the `PROFILER` environment variable, that
specific profiler will be enabled.  See the Profilers section if extra
configuration is needed to use the selected profiler.

Currently the following profilers are supported:
- xdebug
- xhprof
- tideways
- blackfire

extensions
----------

The base image contains a extensions helper that helps you installing available
php extensions. It can be found at `/usr/local/bin/extensions` and has 3
'functions'.

### list extensions

This will list all available precompiled extensions that can be installed. Some
special extensions like `xdebug` and `tideways` are excluded from the list
since those can be controlled via environment variables.

~~~ sh
$ extensions -l
amqp
apcu
apcu-bc
ast
bcmath
bz2
cgi
cli
common
curl
dba
ds
enchant
fpm
gd
gearman
geoip
gmagick
gmp
http
igbinary
imagick
imap
interbase
intl
json
ldap
mailparse
mbstring
mcrypt
memcache
memcached
mongo
mongodb
msgpack
mysql
oauth
odbc
opcache
pear
pecl-http
pgsql
phpdbg
propro
pspell
radius
raphf
readline
recode
redis
rrd
sass
smbclient
snmp
soap
sodium
solr
sqlite3
ssh2
stomp
sybase
tidy
uploadprogress
uuid
xcache
xml
xmlrpc
xsl
yac
yaml
zip
zmq
~~~

### install extensions

We can install additional PHP extensions with the tool, just give a space
separated list of extensions you need and those will be added to your
installation.

~~~ sh
$ extensions -i mongodb
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  php-mongodb
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 498 kB of archives.
After this operation, 3704 kB of additional disk space will be used.
Get:1 https://packages.sury.org/php stretch/main amd64 php-mongodb amd64 1.3.3-1+0~20180314122024.4+stretch~1.gbpc062c6 [498 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 498 kB in 0s (967 kB/s)
                               Selecting previously unselected package php-mongodb.
(Reading database ... 11653 files and directories currently installed.)
Preparing to unpack .../php-mongodb_1.3.3-1+0~20180314122024.4+stretch~1.gbpc062c6_amd64.deb ...
Unpacking php-mongodb (1.3.3-1+0~20180314122024.4+stretch~1.gbpc062c6) ...
Setting up php-mongodb (1.3.3-1+0~20180314122024.4+stretch~1.gbpc062c6) ...
~~~

### dump available extensions in a php cache file

There is a possibility to dump a php file with the available extensions listed.
This is more needed if you have a slow disk or something and having issues with
the regular reading of the debian package files. When the 'cache' file is found
it will be used instead of the debian package cache to list the available PHP
extensions.

~~~ sh
$ extensions -d
~~~

Profilers
---------

### xdebug

When we choose to profile with xdebug, all requests and cli runs will write
their run profile in the `/xdebug` folder. You can analyse the grind files with
`kcachegrind` or `qcachegrind` and try to find your possible bottlenecks.

### xhprof

When xhprof is enabled, all requests, cli runs will write their run profile in
the `/xhprof` folder. The choice was made to to it like this so your current
application is not polluted with eventually additional modules you might not
need. The easiest way to view and analyze your profiles is with xhgui which has
a dependency on mongodb. You can find a `docker-compose` extension sample in
[xhgui][].

### Tideways

When we use tideways it will give us more information about different parts of
our application. We can use the profiling by installing [tideways-chrome][]. By
using Tideways you get a few extra environment variables:

- `TIDEWAYS_APIKEY`: required, set your api key from the dashbord
- `TIDEWAYS_SAMPLERATE`: optional, set the samplerate
- `TIDEWAYS_FRAMEWORK`: set to the framework you are using
- `TIDEWAYS_COLLECT`: check the tideways documentation how to use this
- `TIDEWAYS_MONITOR`: check the tideways documentation how to use this

You can find extended documentation about tideways here: [tideways-documentation][]

> Note: You will need to setup the tideways daemon to get your information sent to tideways.io

### Blackfire

When we use blackfire we need the blackfire/blackfire daemon. There we need to
configure our `BLACKFIRE_SERVER_ID` and `BLACKFIRE_SERVER_TOKEN`. The
application container must be able to reach the blackfire daemon under the name
'blackfire'. To start profiling your application you can install the
[blackfire-chrome][].  For completeness you can add `BLACKFIRE_CLIENT_ID` and
`BLACKFIRE_CLIENT_TOKEN` environment variables to your blackfire daemon
configuration.

If you are logged into [blackfire][] you can find those environment variables
at the [docker documentation](https://blackfire.io/docs/integrations/docker).

For more documentation about blackfire see: [blackfire-documentation][]

Mailcatcher
-----------

When you use this in development mode with mailcatcher or mailhog, you must
give it the hostname `mailcatcher` to have it all working fine.

Rootless operation
------------------

When using `--user` or create a child image where you set `USER` in the
Dockerfile, you should use `www-data`, everything inside the image is prepared
for use with `www-data` using uid 33 and gid 33. There is a slight drawback,
when running as user you can no longer run the privileged parts, so no
installation of new extensions. But extensions can be enabled and disabled,
profilers can be enabled or disabled and used.

Demo example Dockerfile for rootless production:

``` Dockerfile
FROM dockerwest/php:7.2
RUN /usr/local/bin/extensions -i amqp  && /usr/local/bin/permissions
USER www-data
```

The permissions helper will make sure that the PHP parts are prepared for
rootless operation.

> If you want to allow rootless operation of you modified dockerwest image you
> must run the permissions helper

Versions
--------

The following versions are available:
- 5.6 : supported until 31 Dec 2018
- 7.0 : supported until 3 Dec 2018
- 7.1 : supported until 1 Dec 2019
- 7.2 : supported until 30 Nov 2020
- 7.3 : supported until 6 Dec 2021
- 7.4 : supported until 28 Nov 2022

License
-------

MIT License (MIT). See [license][] for more information.

[license]: LICENSE.md "License"
[xhgui]: https://github.com/dockerwest/compose-xhgui "compose-xhgui"
[tideways-chrome]: https://tideways.io/profiler/article/58-chrome-extension "Tideways browser extension"
[tideways-documentation]: https://tideways.io/profiler/docs "Tideways docs"
[blackfire]: https://blackfire.io "Blackfire"
[blackfire-chrome]: https://chrome.google.com/webstore/detail/blackfire-companion/miefikpgahefdbcgoiicnmpbeeomffld "Blackfire browser extension"
[blackfire-documentation]: https://blackfire.io/docs "Blackfire docs"
[preloading]: https://wiki.php.net/rfc/preload
