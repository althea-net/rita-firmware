Althea Firmware Builder
===================

This repo is dedicated to building custom OpenWRT firmware for Althea routers.
Similar to LibreMesh's [Lime-SDK](https://github.com/libremesh/lime-sdk) or
SudoMesh's [SudoWRT](https://github.com/sudomesh/sudowrt-firmware) firmware
builder. All of these perform much the same function, maintaining a series of
config files, patches, and packages to insert into a OpenWRT firmware image.

The Althea firmware builder deviates from existing efforts with a heavy reliance
on Ansible instead of bash. This creates a pretty readable workflow and makes it
very easy to apply delta changes onto a modified build directory. Allowing a
dramatic reduction in build time as well as very flexible build options.

Althea itself is a incentivized mesh system. This bulid system creates a firmware
image preconfigured with Althea's fork of the Babeld mesh software as well as
various utilities and tools to automatically pay mesh nodes for bandwidth.

End user traffic over the mesh is secured with WireGuard, this repository also
includes several helpful features to easily configure devices to work with a
WireGuard server.

----------

Is this where I get Althea?
------------------------------------------

If you just want Althea on your router please download a firmware release from
our website once it becomes available. This page is for developers who want
to help improve Althea. Or technically advanced users who want to try out cutting
edge changes.

Getting Started
--------------------

First off you need a Linux machine with at least 15gb of free disk space,
4gb of free ram and Ansible.

On Ubuntu and Debian:
> sudo apt install python-pip

> sudo pip install ansible

On Fedora:
> sudo dnf install ansible

On Centos and RHEL:
> sudo yum install ansible

Once you have Ansible you can use it to manage the rest of the dependencies:
```
git clone https://github.com/althea-mesh/althea-firmware
cd althea-firmware
ansible-playbook first-time-setup.yml --ask-sudo-pass
```
Type in your password to give Ansible permissions to install the required
packages. This will also install Rust and add it to your PATH in your bashrc.
We use Rust Nightly, the build script will update it for you.

If you have a nonstandard setup, or just don't trust Ansible with root
you may want to install dependencies manually using these commands.

Debian:

	sudo apt-get install build essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python systemtap-sdt-dev npm

Ubuntu:

	sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev unzip systemtap-sdt-dev npm

Centos:

	sudo yum install subversion binutils bzip2 gcc gcc-c++ gawk gettext flex ncurses-devel zlib-devel zlib-static make patch unzip perl-ExtUtils-MakeMaker glibc glibc-devel glibc-static quilt ncurses-libs sed sdcc intltool sharutils bison wget git-core openssl-devel xz systemtap-sdt-devel npm

Fedora:

	sudo dnf install subversion binutils bzip2 gcc gcc-c++ gawk gettext git-core flex ncurses-devel ncurses-compat-libs zlib-devel zlib-static make patch unzip perl-ExtUtils-MakeMaker perl-Thread-Queue glibc glibc-devel glibc-static quilt sed sdcc intltool sharutils bison wget openssl-devel systemtap-sdt-devel npm

Arch:

	sudo pacman -S subversion binutils bzip2 gcc gcc-libs gawk gettext git flex ncurses zlib automake patch unzip perl glibc quilt sed sdcc intltool sharutils bison wget openssl systemtap npm

Finally install [Rust](https://www.rustup.rs/) and add Rustup to your PATH

Building the firmware
-----------------------------

If there is an existing device profile building the firmware
should be pretty simple. Here are the existing hardware config names.

| Hardware Config | Target Name | Full model name          | Price    |  Features/Comments                | Buy Link                                                                                      | Firmware Download                                                                                                             | OpenWRT Wiki / Flashing Instructions         |
|-----------------|-------------|--------------------------|----------|---------------------------------- |-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
|      n600       |    ar71xx   | WD My Net N600 Model: C3 | $30 new  | Slow CPU 30mbps max, good for dev |[Rakuten](https://www.rakuten.com/shop/grassroots-computers/product/WDBEAV0000NWTRECF/)        | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n600-squashfs-factory.bin)          | [link](https://openwrt.org/toh/wd/n600)                                                                 |
|      n750       |    ar71xx   | WD My Net N750 Model: C3 | $30 new  | Slow CPU 30mbps max, good for dev |[Rakuten](https://www.rakuten.com/shop/grassroots-computers/product/WDBAJA0000NWTRECF/)        | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n750-squashfs-factory.bin)          | [link](https://openwrt.org/toh/wd/n750)                                                                 |
|  edgerouterlite |    octeon   |  Ubiquiti EdgeRouter Lite| $95 new  |Even faster than the x, less ports |[Amazon](https://www.amazon.com/Ubiquiti-EdgeMax-EdgeRouter-ERLite-3-Ethernet/dp/B00CPRVF5K)   | [link](https://updates.altheamesh.com/targets/octeon/generic-glibc/openwrt-octeon-erlite-squashfs-sysupgrade.tar)             | [link](https://openwrt.org/toh/ubiquiti/edgerouter.lite)                                                |
|  edgerouterx    |    ramips   |  Ubiquiti Edgerouter X   | $55 new  | Fast (>500mbps), no wifi          |[Amazon](https://www.amazon.com/Ubiquiti-EdgeRouter-Advanced-Gigabit-Ethernet/dp/B00YFJT29C/)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt-erx-squashfs-sysupgrade.tar)           | [link](https://openwrt.org/toh/ubiquiti/ubiquiti_edgerouter_x_er-x_ka)                                  |
|      ar750      |    ar71xx   |     GL.iNet GL-AR750     | $45 new  | Slow CPU 30mbps max, buy an n750  |[Amazon](https://www.amazon.com/dp/B07712LKJM)                                                 | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-gl-ar750-squashfs-sysupgrade.bin)         | [link](https://openwrt.org/toh/hwdata/gl.inet/gl.inet_gl-ar750)                                         |
|     dir860l     |    ramips   |  D-Link Dir 860L Rev B3  | $40 used | Fast, AC wifi, if you find one buy|[Amazon](https://www.amazon.com/D-Link-DIR-860L-802-11ac-Wireless-Router/dp/B00CCIL9NU)        | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-dir-860l-b1-squashfs-factory.bin)           | [link](https://openwrt.org/toh/d-link/dir-860l)                                                         |
|      omnia      |     mvebu   |       Turris Omnia       | $300 new | very expensive, very fast         |[Turris](https://omnia.turris.cz/en/)                                                          | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-turris-omnia-sysupgrade.img.gz)           | [link](https://github.com/lede-project/source/commit/9f3f61a0d968fbe7b93899f948f3c34612683ba6)          |
|     wdr3600     |    ar71xx   |      TP-Link wdr3600     | $60 new  | too old to buy, lots lying around |[Amazon](https://www.amazon.com/2PU1951-TP-LINK-TL-WDR3600-Wireless-802-11n/dp/B008RV51EE)     | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-vmlinux.bin)                              | [link](https://openwrt.org/toh/tp-link/tl-wdr3600)                                                      |
|      aclite     |    ar71xx   |     UniFi AP AC LITE     | $85 new  |great for clients not for much else|[Amazon](https://www.amazon.com/Ubiquiti-Unifi-Ap-AC-Lite-UAPACLITEUS/dp/B015PR20GY/)          | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-ubnt-unifiac-lite-squashfs-sysupgrade.bin)| [link](https://wiki.openwrt.org/toh/ubiquiti/unifiac)                                                   |
|    tplinkc7v2   |    ar71xx   |   TP Link Archer C7 V2   | $85 new  |  Best medium budget choice 60mbps |[Ebay](https://www.ebay.com/itm/401001274989)                                                  | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-archer-c7-v2-squashfs-factory-us.bin)     | [link](https://wiki.openwrt.org/toh/tp-link/archer-c5-c7-wdr7500)                                       |
Profiles
--------

To simplify the process of building and configuring the firmware we use
variable files in the `profiles/` directory. These are split into management
and device categories. One set contains hardware specific variables for supported
routers the other set contain administrator preferences. These are not meant to
be taken as gospel, for example if you wanted to have mesh on one of the wireless
radios you could edit the device profile. Or if you wanted to insert your own ssh
key every time you would edit a management profile (the `keys_to_insert` list).
If you'd like to temporarily overwrite a profile's SSH key list, add
`-e keys_to_insert="['$(cat <keyfile1>)', '$(cat <keyfile2)', ...]"` to your
command line when using one of the `build*` playbooks. Most users might want
to set it to `-e keys_to_insert=['$(cat ~/.ssh/id_rsa.pub)']`.

Review and edit the profiles and make whatever changes you would like. By default
these profiles build a end user router that runs mesh only over the wan nic and
provides a secured default route over a wireguard endpoint defined in the management
profile.

Other available flags include `gateway` and `extender` a gateway bridges from a
backhaul connection over the wan port to mesh devices on the lan port, feeding
internet over Wireguard tunnels into the mesh.

An extender acts as a sort of mesh hub, all possible ports on an extender are
mesh enabled, making it a good way to plug together a ton of antennas.

To define a gateway simply add `gateway=true` to your device profile and whatever
value of `gateway_port` is unused on the wireguard server end.

Likewise for an extender simply add 'extender=true' to the device profile.

Building
--------

To build the firmware for your device run, replacing '\<Hardware Config\>' with
the value from the table above and '\<Management Profile\>' with a profile that
has been customized to your needs:
> ansible-playbook firmware-build.yml -e @profiles/devices/\<Hardware Config\>.yml -e@profiles/management/\<Management Profile\>.yml

This will take a long time, especially the first run. Nearly an hour on a fast
machine and several on a slower one. After the first run things should be much
faster due to cached builds. On the order of 5-10 minutes.

If you need to build for another target, just run again with a different profile
parameter. The build script will always handle cleanup and updating the source code.

Flashing
---------


When finished your firmware images will be located in
`althea-firmware/build/bin/targets/<Target Name>/generic/` if you are flashing
using the factory recovery interface use the factory image, if you are flashing
using an existing OpenWRT install you want the sysupgrade file. You are looking
for a file named `openwrt-...-\<Router name\>-squashfs-factory.bin` or
the same start with `sysupgrade.bin` on the end.

Next you have two options, you can follow the OpenWRT guide to [installing firmware](https://wiki.openwrt.org/doc/howto/generic.flashing).
or you can use the integrated tools in this repository for flashing.

In either case the firmware is uploaded, then the file /etc/setup.ash is run.
This file does stuff like generate WireGuard keys, mesh ip's and passwords.

To do it by hand just flash the router, login and run the following. Replacing `Value`
with the WireGuard ip you get from the server administrator.
> internal_ip=\<Value\> ash /etc/setup.ash

you will see a generated wifi password and a WireGuard public key printed to
the terminal.

The integrated flashing tools are designed to make it easy to handle large numbers
of devices. They take the same profile arguments as the build firmware build
playbook.

Create a file `internal_ip_list.txt` which contains ip addresses to be assigned
to WireGuard tunnels for the router. The flashing Ansible playbooks will take
an IP from this file, assign it to the router at setup time and then save details
from these routers to `users.txt` and `gateways.txt` the contents of these files
can then be copy pasted into the [Althea Exit installer's](https://github.com/althea-mesh/installer)
own profile system. Then it's a one-button operation to setup all these routers on the WireGuard
server.

There are two playbooks, `factory-upload.yml` and `upgrade-firmware.yml` the factory
upload playbook uploads the firmware to the manufacturer recovery webpage this
only works with the n600 and n750 currently. The upgrade playbook will work with
any OpenWRT device. But requires that passwordless ssh into the router is possible.
In the case that the router is not located at `192.168.1.1` specify the ip address
using the variable `router_ip` in your profile.

As a corner case extenders should be flashed using the factory playbook and require
the magic router ip value of `router_ip=fde6::1` because they have no lan ports.

In another corner case Gateways will DHCP over the wan port and you may have to
use nmap to find the router ip. Or use the mesh ip address by running Babel
on your own machine.

Once you have all of this sorted our in your profiles run.

> ansible-playbook \<Playbook\> -e @profiles/devices/\<Hardware Config\>.yml -e@profiles/management/\<Management Profile\>.yml

You may also find `build-and-upgrade.yml` interesting. It simply runs the build
and firmware upgrade playbooks back to back for one button testing of changes.

Something didn't work
---------------------

Follow the debugging instructions provided by the build playbook. That should
give you a proper error message. Drop by
[our Matrix channel](https://riot.im/app/#/room/#althea:matrix.org) and let us
know what happened. We'll be happy to help out.

There's no hardware config for my router
----------------------------------------

Making a hardware config is a somewhat involved proccess. If you can read and
understand the
[OpenWRT build system documentation](https://wiki.openwrt.org/doc/howto/build)
you should be able to manage it.

If you successfully make a build profile for your device, please open a pull
request.

If you would like to request support for specific hardware drop by
[our Matrix channel](https://riot.im/app/#/room/#althea:matrix.org) and let us
know. We'll do our best to add support.


