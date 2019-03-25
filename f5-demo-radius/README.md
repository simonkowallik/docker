# intro
[![](https://images.microbadger.com/badges/image/simonkowallik/f5-demo-radius.svg)](https://microbadger.com/images/simonkowallik/f5-demo-radius)

This container provides a pre-configured freeradius server for use with F5 BIG-IP Remote Authentication or F5 BIG-IP APM.
It is intended for use in testing and demo environments and should not be used in production environments.

# details
- Any client IP address is accepted by the radius server, the secret is `SECRET` (see: etc/raddb/clients.conf)
- The list of pre-defined users and F5 User Roles is configured in `etc/raddb/users.default`. The entry on the left of `Cleartext-Password` is the username, the entry on the right of `Cleartext-Password :=` is the password (excluding "")
- if you want to add users see further below for an example (add custom user database)

pre-defined `users:passwords`:

    test:test
    smith:agent
    admin:secret
    viewer:viewer
    noaccess:noaccess

# quickstart guide

run container, save container IP address to \$containerip and run radtest to verify functionality

    docker run -p 1812:1812/udp --name f5-demo-radius simonkowallik/f5-demo-radius

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
        f5-demo-radius | read containerip
    docker exec -it f5-demo-radius radtest test test $containerip 0 SECRET


# docker image

download from docker hub:

    docker pull simonkowallik/f5-demo-radius:latest

To create your own image download this directory and run docker build:

    docker build -t my/f5-demo-radius .


# start container and bind port 1812/udp to host machine
from docker hub:

    docker run -p 1812:1812/udp --name f5-demo-radius simonkowallik/f5-demo-radius

from a local image:

    docker run -p 1812:1812/udp --name f5-demo-radius my/f5-demo-radius


# test functionality

You can use radtest (shipped in the container) to test the container functionality.

    docker exec -it <containername> radtest <user> <password> <container-ip> 0 SECRET

Get the container IP address and store it in \$containerip:

    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' f5-demo-radius | read containerip

Use radtest with thest user credentials:

    docker exec -it f5-demo-radius radtest test test $containerip 0 SECRET

    Sent Access-Request Id 161 from 0.0.0.0:53840 to 172.17.0.2:1812 length 74
            User-Name = "test"
            User-Password = "test"
            NAS-IP-Address = 172.17.0.2
            NAS-Port = 0
            Message-Authenticator = 0x00
            Cleartext-Password = "test"
    Received Access-Accept Id 161 from 172.17.0.2:1812 to 172.17.0.2:53840 length 20


The container should log something similar to:

    (0) Received Access-Request Id 161 from 172.17.0.2:53840 to 172.17.0.2:1812 length 74
    (0)   User-Name = "test"
    (0)   User-Password = "test"
    (0)   NAS-IP-Address = 172.17.0.2
    (0)   NAS-Port = 0
    (0)   Message-Authenticator = 0xfc1b049c91760b520c69ea620217c94f
    (0) # Executing section authorize from file /etc/raddb/sites-enabled/default
    (0) # Executing group from file /etc/raddb/sites-enabled/default
    (0) pap: Login attempt with password
    (0) pap: Comparing with "known good" Cleartext-Password
    (0) pap: User authenticated successfully
    (0) # Executing section post-auth from file /etc/raddb/sites-enabled/default
    (0) Sent Access-Accept Id 161 from 172.17.0.2:1812 to 172.17.0.2:53840 length 0


# add custom user database

use a local user file like `./my.users.custom` and map it to the container file `/etc/raddb/users.custom` to add custom users.

Example:

    docker run -p 1812:1812/udp -v $PWD/my.users.custom:/etc/raddb/users.custom --name f5-demo-radius simonkowallik/f5-demo-radius

# example authentication via F5 WebUI

    (0) Received Access-Request Id 226 from 172.17.0.1:50543 to <container-ip>:1812 length 91
    (0)   User-Name = "viewer"
    (0)   User-Password = "viewer"
    (0)   NAS-IP-Address = 192.168.0.245
    (0)   NAS-Identifier = "httpd"
    (0)   NAS-Port = 20188
    (0)   NAS-Port-Type = Virtual
    (0)   Service-Type = Authenticate-Only
    (0)   Calling-Station-Id = "192.168.0.1"
    (0) # Executing section authorize from file /etc/raddb/sites-enabled/default
    (0) # Executing group from file /etc/raddb/sites-enabled/default
    (0) pap: Login attempt with password
    (0) pap: Comparing with "known good" Cleartext-Password
    (0) pap: User authenticated successfully
    (0) # Executing section post-auth from file /etc/raddb/sites-enabled/default
    (0) Sent Access-Accept Id 226 from <container-ip>:1812 to 172.17.0.1:50543 length 0
    (0)   F5-LTM-User-Role = Guest
    (0)   F5-LTM-User-Info-1 = "mgmt"
    (0)   F5-LTM-User-Partition = "Common"
    (0)   F5-LTM-User-Shell = "disable"

# references
For F5 setup information check:

[https://support.f5.com/csp/article/K14324](https://support.f5.com/csp/article/K14324)

    tmsh modify /auth remote-role role-info add { mgmt_group { attribute "F5-LTM-User-Info-1=mgmt" console %F5-LTM-User-Shell line-order 1001 role %F5-LTM-User-Role user-partition %F5-LTM-User-Partition } }