# docker-helixcore

## What is this?

Faster setup times for Perforce Helix-Core for DevOps for Assembla, also if migrating from Windows, change the native case handling behavior of a Perforce Helix `p4d` Server on Linux (case sensitive) to the non-native case insensitive behavior of Windows with scripts. 

## Example

So let's say you have a file called `makefile` and another one called `MAKEFILE`, the case sensitive behavior would pick that up as two different files completely, when in fact it's the same file. This is to stop that problem, and stop file collisions. 

There's two ways to see the files that could cause collisions:

* Obliterate the case variant paths (recommended)
* Perform a "deep rename"  of one (or more) of the case variant paths and rename the associated archive files (scripts inside this repo lists the files that may cause collisions). 

