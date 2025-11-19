# bt-cm749-fix
DKMS modules for fixing bluetooth support on Linux for UGREEN Bluetooth 5.4 USB adapter models:
- CM748
- CM749
- and other devices based on the BR8554 chip potentially

## Usage

First, make the script executable, then execute it:
```bash
sudo chmod u+x ./setup_bt-cm749.sh
sudo ./setup_bt-cm749.sh
```

After a successful build of the module and reboot of your machine, you can verify it with following command:
```bash
sudo dkms status
```

You may have some issues related to the DKMS MOK key not being enrolled if you are using secure boot, e.g 
```
$ modprobe btusb
modprobe: ERROR: could not insert 'btusb': Key was rejected by service
```
Which can be fixed by doing
```bash
sudo mokutil --import /var/lib/dkms/mok.pub
```
then rebooting and enrolling the key when prompted.


## Credit

This repo is based on https://github.com/xoocoon/hp-15-ew0xxx-snd-fix/

The patch is taken from here: https://github.com/Seven0492/kernel-patches/blob/main/cm749.patch
