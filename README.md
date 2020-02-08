## Script to configure the virtual host

The script is suitable for ubuntu, I don't know about the others.

Run:
```bash
sudo sh setVH.sh <site_name>
```

Example:
```bash
sudo sh setVH.sh example.ru
```
<span style="color:red">Important</span>: the file <site_name>.conf should be placed next to the script (in the same directory) (example: `example.ru.conf`).

The script takes the file `<site_name>.conf`, this file is placed in the apache config, then all configuration actions are performed, the name of the site is written to the OS hosts.