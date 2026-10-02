# Patch for PiKVM EZCool Switches
Reference https://github.com/semool/kvmd

## Install
Need to hard refresh after install/update
```
sudo apt install -y git curl
chmod +x patch-kvmd-ezcoo.sh
sudo ./patch-kvmd-ezcoo.sh
sudo systemctl restart kvmd
```

## Roll back
```
sudo tar -xzf /root/kvmd-py-backup-<stamp>.tar.gz  -C /usr/lib/python3.14/site-packages
sudo tar -xzf /root/kvmd-web-backup-<stamp>.tar.gz -C /usr/share/kvmd
sudo systemctl restart kvmd
```
