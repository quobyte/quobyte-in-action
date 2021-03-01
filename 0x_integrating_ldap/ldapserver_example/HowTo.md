# how to deploy this example ldap tree

## On a debian based system:


## Installation & Configuration

apt-get install slapd

dpkg-reconfigure slapd

Answer "Omit OpenLDAP server configuration?"

"No"

Answer to DNS-Name:

"myorganization.org"

Anser to Orga-Name: 

"myorganization"

Anwer to password:

"examplepass"

Do you want the database to be removed when slapd is purged? 

"No"

## Importing test database

ldapadd -f ldap-tree.ldif -H ldapi:/// -x -W -D cn=admin,dc=myorganization,dc=org -c

## Adding "memberOf" overlay to mimic AD tree:

ldapadd -f addMemberOfModule.ldif -H ldapi:/// -Q -Y EXTERNAL

### Query database for "memberOf" attribute:

ldapsearch -H ldapi:/// -x -W -D cn=admin,dc=myorganization,dc=org -b dc=myorganization,dc=org uid=exampleuser memberOf



