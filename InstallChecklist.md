# INstallation check list

## This list can be seen as a very short cheat sheet after a Quobyte installation

1. Check alerts in web ui
2. Follow journalctl -fa to see anything unusual
3. Check ulimit for clients. "ulimit -n" is one practical example
4. Do a burn in test: FIO + Small file on a Quobyte mount 
5. Compare that to your local disks: FIO + Small file on a Quobyte mount on a physical device /var/lib/quobyte/<somePath>
6. Check you network: retransmits, "ecn" enabled in sysctl, ulimit from what we have in our "tuned" performance profiles (especially ...)




