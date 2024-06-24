# Quobyte Query Engine

The File Query Engine is accessible through Quobyte's command-line tool "qmgmt" and its API, offering flexibility for various use cases. Administrators and researchers can easily construct queries to filter files based on a wide range of criteria, including file attributes, modification times, and custom metadata.

## Example: Find cold image data

Searches for all files that have file names ending in "jpeg" or "jpg" that have not been modified 
the last ten minutes.

``` 
qmgmt query files --list-columns=volume_uuid_path,size 'name~=".*(jpeg|jpg)" AND mtime_age<"10min"'
``` 

## Example: Extended attributes filter

``` 
qmgmt query files 'xattr.origin="FR" AND xattr.width>=1024'
``` 
