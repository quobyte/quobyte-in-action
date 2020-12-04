# Using S3

s3cfg:

```
host_base = s3.quobyte.example 
host_bucket = %(bucket)s.s3.quobyte.example
access_key = AyqBH6dZ6dGAT6TXUDty
secret_key = tXTUT4u73vaFdTJuWuD0kS5Q2vREjWRt0k2w1Q/q
use_https = False
```

basic operations:
```
deploy@coreserver0:~$ s3cmd ls
deploy@coreserver0:~$ s3cmd mb s3://newbucket
Bucket 's3://newbucket/' created
deploy@-coreserver0:~$ cat /etc/hosts
127.0.0.1 localhost
.
.
.
35.233.133.161 s3.quobyte.example
35.233.133.161 newbucket.s3.quobyte.example
```


# Using NFS

Pro/Con

technical howto

# Using native client

technical howto


