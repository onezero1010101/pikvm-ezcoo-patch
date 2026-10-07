# PiKVM EZCoo Patch

Applies the EZCoo switch support from [semool/kvmd](https://github.com/semool/kvmd) (commit `b9fd5b0`) to an existing PiKVM install, without reflashing or rebuilding.

The script patches two locations, backing up both first:

| Part | Path |
| --- | --- |
| Python (`kvmd`) | `/usr/lib/python3.14/site-packages/kvmd` |
| Web UI | `/usr/share/kvmd/web` |

## Install

```bash
sudo apt install -y git curl
curl -fsSLO https://raw.githubusercontent.com/onezero1010101/pikvm-ezcoo-patch/main/patch-kvmd-ezcoo.sh
chmod +x patch-kvmd-ezcoo.sh
sudo ./patch-kvmd-ezcoo.sh
sudo systemctl restart kvmd
```

Then hard refresh the web UI in your browser (Ctrl+Shift+R) so it loads the updated files.

### What the script does

1. Checks that `git`, `curl`, and the target paths exist.
2. Downloads the patch from the semool/kvmd commit.
3. Saves backups to `/root/kvmd-py-backup-<stamp>.tar.gz` and `/root/kvmd-web-backup-<stamp>.tar.gz`.
4. Dry-runs the patch on both parts, and only applies it if both pass.
5. Clears `__pycache__` under the Python package.

If a path isn't found, the script exits without changing anything. Python and web paths are set at the top of the script if yours differ.

## Roll back

Use the `<stamp>` from the backup filenames in `/root/`:

```bash
sudo tar -xzf /root/kvmd-py-backup-<stamp>.tar.gz  -C /usr/lib/python3.14/site-packages
sudo tar -xzf /root/kvmd-web-backup-<stamp>.tar.gz -C /usr/share/kvmd
sudo systemctl restart kvmd
```

Hard refresh the web UI afterward.
