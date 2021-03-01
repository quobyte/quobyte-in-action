# an example ldap tree we use to deploy our different scenarios

## scenario 1: Auth-Only, anonymous bind

In this example anonymous auth is allowed by LDAP-ACLs. 
We do not need a dedicated bind user, so this example brings least complexity.

## scenario 2: Auth-Only, bind-user

This example works in environments where anonymous auth is not allowed.
It requires a configured bind-user that is allowed to search the LDAP tree (maybe also read

## scenario 3: Auth + group-membership, / group object holds user <--> group relation

This example is used to not only do authentication for users, but also lookup their group membership. 
It reflects examples where users are stored in group objects. This is commonly seen in environments 
using openldap as a LDAP implementation.

## scenario 4: Auth + group-membership, / user object holds user <--> group relation

This example is used to not only do authentication for users, but also lookup their group membership. 
It reflects examples where group membership is stored as part of a user object. This is commonly seen in environments 
using AD as their LDAP implementation.

# optional extended ldap schema
## scenario 5: Auth +  role mapping comes from LDAP

This scenario will need a modified LDAP schema to contain the attributes needed to determine a role a user should have in Quobyte.

