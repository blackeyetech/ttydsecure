# Introduction

**ttydsecure** is a wrapper script around **ttyd** which is a simple
command-line tool for sharing a terminal over the web. More information on ttyd
can be found [here](https://github.com/tsl0922/ttyd).

_ttydsecure_ helps make the terminal connection to the browser more secure.

_Please note that any user of *ttydsecure* must ensure they understand the risks
involved in exposing a terminal via a web browser and take the required steps to
stay secure._

_ttydsecure_ helps to improve security in the following ways:

- HTTPS is the only connection type
- SSL/TLS certs are automatically created unless the user wishes to use their
  own
- Only one connection from a browser is allowed by default
- Operating System (OS) level authentication is enforced by default and the user
  automatically created and password set
- HTTP Basic Authentication can be enabled instead os OS level authentication

This image is based on _debian:stretch-slim_. In addition to _ttydsecure_ and
ttyd, and the following executables have been installed for the user's convience
in this image:

    - openssh-client
    - vim
    - sudo

This image can be used either as an executable or a base image.

_ttydsecure_ uses environmental variables to automatically set the appropriate
parameters to pass to ttyd.

# _ttydsecure_ options:

_ttydsecure_ can take any of the ttyd parameters, however any parameters set
automatically because of environmental variables settings should not be used.
See each of the environmental variables to learn which ttyd parameters are set.

NOTE: The following parameters are **always** passed to ttyd:

- --ssl
- --ssl-cert
- --ssl-key

# Ports to expose

By default, ttyd listens on port _7681_ therefore this port needs to be exposed
on the port the user prefers.

# Running as an executable

The default command is **ttydsecure** if there are no parameters passed during
container creation.

# Environmental Variables

_ttydsecure_ uses environmental variables to automatically set the appropriate
parameters to pass ttyd.

By using environmental variables the user can control:

- Location of the SSL/TLS certs
- The authentication type
- The user name and password to use for authentication
- The maximum number of allowed connections
- If the OS use should be made into a sudoer

## TTYD_AUTH_TYPE

The _TTYD_AUTH_TYPE_ environmental variable allows the user to specify if
Operating System level authentication is choosen or HTTP Basic Authentication.

The default is Operating System level authentication.

To use HTTP Basic Authentication _TTYD_AUTH_TYPE_ must be set to _basic_.

## SERVER_CRT

The _SERVER_CRT_ environmental variable allows the user to specify the name and
location of the server cert file.

The following ttyd parameter will be passed automatically:

- --ssl-cert \$SERVER_CRT

The default value is _/certs/server.crt_.

## SERVER_KEY

The _SERVER_KEY_ environmental variable allows the user to specify the name and
location of the server key file.

The following ttyd parameter will be passed automatically:

- --ssl-key \$SERVER_KEY

The default value is _/certs/server.key_.

## TTYD_USER

If using Operating System level authentication is choosen, the _TTYD_USER_
environmental variable will be the name of the OS user created in the container.
Otherwise this is the user name that must be provided for HTTP Basic
Authentication.

The following ttyd parameter will be passed automatically if HTTP Basic
Authentication is choosen.

- --credential $TTYD_AUTH_USER:$TTYD_AUTH_PASSWD

## TTYD_PASSWD

If using Operating System level authentication is choosen, the _TTYD_PASSWD_
environmental variable will be the password of the OS user in the container.
Otherwise this is the user password that must be provided for HTTP Basic
Authentication.

The following ttyd parameter will be passed automatically if HTTP Basic
Authentication is choosen.

- --credential $TTYD_AUTH_USER:$TTYD_AUTH_PASSWD

## TTYD_SUDOER

If using Operating System level authentication is choosen, the _TTYD_SUDOER_
environmental variable allows the user to indicate if the OS user should be
added as a sudoer in the container.

Valid values are "Y" or "y" to indicate yes. All other values mean no.

## TTYD_MAX_CONNS

The _TTYD_MAX_CONNS_ environmental variable allows the user to specify the
maximum number of allowed connections. 0 means unlimited connections.

The default value is 1.

The following ttyd parameter will be passed automatically:

- --max-clients \$TTYD_MAX_CONNS
