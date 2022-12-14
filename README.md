# docker-helixcore

## What is this?

Faster setup times for Perforce Helix-Core for DevOps for Assembla, also if migrating from Windows, change the native case handling behavior of a Perforce Helix `p4d` Server on Linux (case sensitive) to the non-native case insensitive behavior of Windows with scripts. 

## Example

So for example let's say there are two separate files in a Unix Perforce database: `readme` and `README`. If they're on case sensitive mode, to Perforce they are different files completely. If they have any of this in their directories/db's, the filenames need to be renamed/moved. One way to procure a list is to use the script in this repository.

## Example case handling conversion

```bash 
p4d -r $P4ROOT -jc myCheckpoint
Checkpointing to myCheckpoint.ckp.66...
Saving journal to myCheckpoint.jnl.65...
Truncating journal...

p4d -r $P4ROOT -C1 -jr myCheckpoint.ckp.66
Perforce db files in '$P4ROOT' will be created if missing...
Recovering from myCheckpoint.ckp.66...

p4d  -C1 -r $P4ROOT -p 1666 &
```
So if all your files were in lowercase and say not camel-case, run `p4 depot depotname` to ensure its Map: is lowercase, and fix it if not. At this point, you can run `p4 verify -q //...` to verify the integrity of the archive files.

### Proxies 

It's recommended that if you have any proxies, have them on the same operating system as the server. The reasons being are case sensitivity is handled on each operating system consistently. Path limits for Windows can be a problem for a Linux Server + Windows and a proxy configuration. Proxy (`P4PCACHE`) paths already tend to be longer then server (`P4ROOT`) paths as proxy cache paths start with doubled depot names, for example: `$P4PCACHE/depot/depot.`

## Routes of fixing filenaming collisions

There's two ways to see the files that could cause collisions:

* Obliterate the case variant paths.
* Perform a "deep rename"  of one (or more) of the case variant paths and rename the associated archive files (scripts inside this repo lists the files that may cause collisions). 

