# Integrating LDAP

Quobyte can be configured to use LDAP as backend for its user database.

Yuo can use your own LDAP server. If you just want to test/ play around you can install
an ldap server as described in ldapserver_example/HowTo.md.

# Use LDAP as Quobyte user directory to authenticate Quobyte users

You can use an external directory tree to authenticate users who want to access a Quobyte system. 
This authentication works for Webconsole, CLI and API.

You will need a dedicated LDAP user ("bind user") too look up the username that is going to be authenticated in the given LDAP database.
I a second step the users distinguished name + the presented password will be taken to authenticate against the LDAP directory database.

To configure LDAP user access you will need the following information:

1. Connection URL (something like ldap://192.168.2.123 or ldap://ldap.myorganization.org)
2. The distinguished name for a bind user (something like cn=quobyte,ou=systemusers,dc=myorganization,dc=org)
3. The password belonging to that specific user 
4. A base DN (the root for your search requests. Something like dc=myorganization,dc=org)



# Use LDAP as group directory determine file system group membership
# Use LDAP as group directory determine tenant membership

# Use LDAP to store and retreive access keys


## Resources:
### Quoybte documentation:
https://support.quobyte.com/docs/16/latest/user_authorization.html
