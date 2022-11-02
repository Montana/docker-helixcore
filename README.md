# docker-helixcore

## What is this?

Faster setup times for Perforce Helix-Core for DevOps for Assembla, also if migrating from Windows, change the native case handling behavior of a Perforce Helix `p4d` Server on Linux (case sensitive) to the non-native case insensitive behavior of Windows with scripts. 

## Example

So for example let's say there are two separate files in a Unix Perforce database: `readme` and `README`. If they're on case sensitive mode, to Perforce they are different files completely. If they have any of this in their directories/db's, the filenames need to be renamed/moved. One way to procure a list is to use the script in this repository.

## Routes of fixing filenaming collisions

There's two ways to see the files that could cause collisions:

* Obliterate the case variant paths.
* Perform a "deep rename"  of one (or more) of the case variant paths and rename the associated archive files (scripts inside this repo lists the files that may cause collisions). 

