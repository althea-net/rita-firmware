# Althea Firmware Builder

This repo is dedicated to building custom OpenWRT firmware for Althea routers.
Similar to LibreMesh's [Lime-SDK](https://github.com/libremesh/lime-sdk) or
SudoMesh's [SudoWRT](https://github.com/sudomesh/sudowrt-firmware) firmware
builder. All of these perform much the same function, maintaining a series of
config files, patches, and packages to insert into a OpenWRT firmware image.

The Althea firmware builder deviates from existing efforts with a heavy reliance
on Ansible instead of bash. This creates a pretty readable workflow and makes it
very easy to apply delta changes onto a modified build directory. Allowing a
dramatic reduction in build time as well as very flexible build options.

Althea itself is an incentivized mesh system. This build system creates a firmware
image preconfigured with Althea's fork of the Babeld mesh software as well as
various utilities and tools to automatically pay mesh nodes for bandwidth.

End user traffic over the mesh is secured with WireGuard, this repository also
includes several helpful features to easily configure devices to work with a
WireGuard server.

---

## Is this where I get Althea?

This page is for developers who want to help improve Althea.
Or technically advanced users who want to try out cutting
edge changes. If you're willing to deal with a less stable version
of Althea or want to try the latest and greatest features use the
nightly build download links in the table below.

Here are the existing hardware config names. As well as download
links for nightly builds, please see the [flashing](#flashing) and [what do
I do now?](#so-i-flashed-the-firmware-what-do-i-do-now)
sections for details on what to expect flashing and using a nightly build.

| Hardware Config | Target Name | Full model name          | Price    | Features/Comments                   | Flashing Difficulty | Buy Link                                                                                          | Firmware Download                                                                                                              | OpenWRT Wiki / Flashing Instructions                                                           | Special Firmware to escape stock                                                                                                                                                                                                                              |
| --------------- | ----------- | ------------------------ | -------- | ------------------------------------|---------------------|-------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| n600            | ar71xx      | WD My Net N600 Model: C3 | $30 new  | Slow CPU 30mbps max, good for dev   | Easy, webpage       | [Rakuten](https://www.rakuten.com/shop/grassroots-computers/product/WDBEAV0000NWTRECF/)           | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n600-squashfs-factory.bin)           | [link](https://openwrt.org/toh/wd/n600)                                                        | N/A                                                                                                                                                                                                                                                           |
| n750            | ar71xx      | WD My Net N750 Model: C3 | $30 new  | Slow CPU 30mbps max, good for dev   | Easy, webpage       | [Rakuten](https://www.rakuten.com/shop/grassroots-computers/product/WDBAJA0000NWTRECF/)           | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n750-squashfs-factory.bin)           | [link](https://openwrt.org/toh/wd/n750)                                                        | N/A                                                                                                                                                                                                                                                           |
| edgerouterlite  | octeon      | Ubiquiti EdgeRouter Lite | $95 new  | HW acceleration not enabled 50mbps  | Medium, drive image | [Amazon](https://www.amazon.com/Ubiquiti-EdgeMax-EdgeRouter-ERLite-3-Ethernet/dp/B00CPRVF5K)      | [link](https://updates.altheamesh.com/targets/octeon/generic-glibc/openwrt-octeon-erlite-squashfs-sysupgrade.tar)              | [link](https://openwrt.org/toh/ubiquiti/edgerouter.lite)                                       | N/A                                                                                                                                                                                                                                                           |
| edgerouterx     | ramips      | Ubiquiti Edgerouter X    | $55 new  | Fast (100mbps), no wifi             | Hard, ssh           | [Amazon](https://www.amazon.com/Ubiquiti-EdgeRouter-Advanced-Gigabit-Ethernet/dp/B00YFJT29C/)     | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt-erx-squashfs-sysupgrade.tar)            | [link](https://openwrt.org/toh/ubiquiti/ubiquiti_edgerouter_x_er-x_ka)                         | intermediary [link](https://updates.altheamesh.com/special/openwrt-ramips-mt7621-ubnt-erx-initramfs-factory.tar)                                                                                                                                              |
| ar750           | ar71xx      | GL.iNet GL-AR750         | $45 new  | Slow CPU 30mbps max, buy an n750    | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B07712LKJM)                                                    | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-gl-ar750-squashfs-sysupgrade.bin)          | [link](https://openwrt.org/toh/hwdata/gl.inet/gl.inet_gl-ar750)                                | N/A                                                                                                                                                                                                                                                           |
| dir860l         | ramips      | D-Link Dir 860L Rev B3   | $40 used | Best value, 100mbps, AC wifi        | Easy, webpage       | [Amazon](https://www.amazon.com/D-Link-DIR-860L-802-11ac-Wireless-Router/dp/B00CCIL9NU)           | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-dir-860l-b1-squashfs-factory.bin)            | [link](https://openwrt.org/toh/d-link/dir-860l)                                                | N/A                                                                                                                                                                                                                                                           |
| omnia           | mvebu       | Turris Omnia             | $300 new | Very fast 300mbps, very finicky     | Expert, serial/ssh  | [Turris](https://omnia.turris.cz/en/)                                                             | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-turris-omnia-sysupgrade.img.gz)            | [link](https://github.com/lede-project/source/commit/9f3f61a0d968fbe7b93899f948f3c34612683ba6) | full [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/omnia-medkit-openwrt-mvebu-cortexa9-turris-omnia-initramfs.tar.gz)                                                                                                                          |
| wdr3600         | ar71xx      | TP-Link wdr3600          | $60 new  | too old to buy, lots lying around   | Easy, webpage       | [Amazon](https://www.amazon.com/2PU1951-TP-LINK-TL-WDR3600-Wireless-802-11n/dp/B008RV51EE)        | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-vmlinux.bin)                               | [link](https://openwrt.org/toh/tp-link/tl-wdr3600)                                             | N/A                                                                                                                                                                                                                                                           | 
| aclite          | ar71xx      | UniFi AP AC LITE         | $85 new  | great for clients not for much else | Hard, ssh           | [Amazon](https://www.amazon.com/Ubiquiti-Unifi-Ap-AC-Lite-UAPACLITEUS/dp/B015PR20GY/)             | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-ubnt-unifiac-lite-squashfs-sysupgrade.bin) | [link](https://wiki.openwrt.org/toh/ubiquiti/unifiac)                                          | N/A                                                                                                                                                                                                                                                           |
| tplinkc7v2      | ar71xx      | TP Link Archer C7 V2     | $85 new  | Best medium budget choice           | Easy, webpage       | [Ebay](https://www.ebay.com/itm/401001274989)                                                     | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-archer-c7-v2-squashfs-factory-us.bin)      | [link](https://wiki.openwrt.org/toh/tp-link/archer-c5-c7-wdr7500)                              | N/A                                                                                                                                                                                                                                                           |
| armorv2         | ipq806x     | Zyxel Armor V2 (nbg6817) | $160 new | Serious software perf issues        | Hard, ssh           | [Amazon](https://www.amazon.com/Wireless-StreamBoost-Beamforming-Antennas-NBG6817/dp/B01I4223HS/) | [link](https://updates.altheamesh.com/targets/ipq806x/generic/openwrt-ipq806x-zyxel_nbg6817-squashfs-sysupgrade.bin)           | [link](https://openwrt.org/toh/zyxel/nbg6817)                                                  | Yes [kernel](https://updates.altheamesh.com/targets/ipq806x/generic/openwrt-ipq806x-zyxel_nbg6817-squashfs-mmcblk0p4-kernel.bin) [rootfs](https://updates.altheamesh.com/targets/ipq806x/generic/openwrt-ipq806x-zyxel_nbg6817-squashfs-mmcblk0p5-rootfs.bin) |                                                                                                                                  
| glb1300         | ipq40xx     | GL.iNet GL-B1300         | $90  new | AC wifi, 100mbps perf, easy to find | Easy, webpage       | [Amazon](https://www.amazon.com/GL-iNet-GL-B1300-Gigabit-Networking-pre-installed/dp/B079FJKZV8)  | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/openwrt-ipq40xx-glinet_gl-b1300-squashfs-sysupgrade.bin)         | [link](https://github.com/lede-project/source/commit/04d3308b6248ef21a6f0bc3378b342906c2d2865) | N/A                                                                                                                                                                                                                                                           |

---

## Getting Started Building Firmware

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

    sudo apt-get install build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python systemtap-sdt-dev npm time

Ubuntu:

    sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev unzip systemtap-sdt-dev npm time

Centos:

    sudo yum install subversion binutils bzip2 gcc gcc-c++ gawk gettext flex ncurses-devel zlib-devel zlib-static make patch unzip perl-ExtUtils-MakeMaker glibc glibc-devel glibc-static quilt ncurses-libs sed sdcc intltool sharutils bison wget git-core openssl-devel xz systemtap-sdt-devel npm time

Fedora:

    sudo dnf install subversion binutils bzip2 gcc gcc-c++ gawk gettext git-core flex ncurses-devel ncurses-compat-libs zlib-devel zlib-static make patch unzip perl-ExtUtils-MakeMaker perl-Thread-Queue glibc glibc-devel glibc-static quilt sed sdcc intltool sharutils bison wget openssl-devel systemtap-sdt-devel npm time

Arch:

    sudo pacman -S subversion binutils bzip2 gcc gcc-libs gawk gettext git flex ncurses zlib automake patch unzip perl glibc quilt sed sdcc intltool sharutils bison wget openssl systemtap npm time

Finally install [Rust](https://www.rustup.rs/) and add Rustup to your PATH

## Building the firmware

If there is an existing device profile building the firmware
should be pretty simple. See the table at the top of the file for 
hardware config names.

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
these profiles build a `gateway` router that can accept WAN connections over the WAN
nic (or the lowest numbered in the absence of a labeled WAN), LAN devices on the NIC
physically furthest from the WAN nic and mesh connections on all NIC's in between.

Other available flags include `client` (implied by setting `-e gateawy=false`)
a client device has a single mesh port on the WAN NIC and all other ports are LAN.
While originally the default we found that most users didn't want this, so it's now
a hidden option.

All versions of the firmware will connect to a user defined 'exit server' and create
a secure Wireguard tunnel over which to route traffic.

## Building

To build the firmware for your device run, replacing '\<Hardware Config\>' with
the value from the table above and '\<Management Profile\>' with a profile that
has been customized to your needs:

> ansible-playbook firmware-build.yml -e @profiles/devices/\<Hardware Config\>.yml -e@profiles/management/\<Management Profile\>.yml

This will take a long time, especially the first run. Nearly an hour on a fast
machine and several on a slower one. After the first run things should be much
faster due to cached builds. On the order of 5-10 minutes.

If you need to build for another target, just run again with a different profile
parameter. The build script will always handle cleanup and updating the source code.

## Flashing

When finished building your firmware images will be located in
`althea-firmware/build/bin/targets/<Target Name>/generic/`. You are looking
for a file named `openwrt-...-\<Router name\>-squashfs-factory.bin` or
the same start with `sysupgrade.bin` on the end. For a lot of models it doesn't
matter if you use the factory or sysupgrade firmware, but for some
(the EdgerouterX for example) it does. See the 'Special firmware to escape stock'
column in the above device support table. If it says `intermediary` then you
need to use this factory firmware as a middle step to get to Althea, if the
firmware to escape stock is marked as `full` then it's a full Althea image and
you can just use that.

In general consult the OpenWRT wiki link next to each supported device above.
Flashing instructions will be available there with known device specific caveats
laid out. Everything is a little bit different, but usually not too complicated.

Once your device is running OpenWRT (any version Althea or not) you no longer need
to follow the factory firmware method, even though it may still be available
(for example a recovery mode), you can simply scp the firmware file to the /tmp/
directory and run `sysupgrade -v -n /tmp/<firmware>`

If you have already flashed a device and want to do some rapid iteration testing
I suggest using the `build-and-upgrade.yml` playbook. It will ssh into the default
router ip and use the appropriate sysupgrade image. Automated flashing from a factory
stock device can be done from `build-and-factory.yml` but only supports devices with
emergency room based recovery modes. So the n600, n750, and dir860l.

### Flashing Gotchas

There's a known bug in the Edgerouterx where the file system is not synced and corruption
can occur. When you flash the EdgerouterX and boot it for the first time _do not_ cut power
until it's been running for at least a minute. This will give Rita time to sync to the disk.
It should really take only a few seconds, but restoring a bricked device is enough of a pain
to just wait. 

We hope to track down the relevent OpenWRT bug and have this fixed upstream soon.

## Building the firmware didn't work

Follow the debugging instructions provided by the build playbook. That should
give you a proper error message. Drop by
[our Matrix channel](https://riot.im/app/#/room/#althea:matrix.org) and let us
know what happened. We'll be happy to help out.

## There's no hardware config for my router

Making a hardware config is a somewhat involved proccess. If you can read and
understand the
[OpenWRT build system documentation](https://wiki.openwrt.org/doc/howto/build)
you should be able to manage it.

The core of the concept is that files in the 'files' folder during firmware build
will get inserted into the root filesystem of the resulting firmware. Combined with
the Make config called a 'diffcofig' setting up the appropriate file is the bulk of
the work done by the Althea firmware builder.

To add support for a device download the OpenWRT repository and run `make menuconfig`
select your target device as well as Althea's required packages. Wireguard (the metapackage)
, ipset, althea-rust-binaries, althea-babeld, and luci (also the metapackage).

Then run `make -j <num cores>' to build the firmware, this will take a while. When it's finished flash the resulting image. Login via ssh and copy`/etc/config/network`and`/etc/config/wireless`, you will edit these files into Althea templates that will reside in`roles/build-config/templates`. Look in that folder for existing examples. The requirements
are pretty simple, gateway mode has at least one dhcp wan port, every device must have at least
one 'LAN' port if possible. To simplify debugging.

The final piece of the picture is in `profiles/devices/<devicename>.yml` you need to edit
this with a list of proper interface names, target data and other fields that will be used
to template not only the network and wireless configs, but also the firewall and ssh config.

After testing that you can make a pull request against our repo to merge your new device support.

If you would like to request support for specific hardware drop by
[our Matrix channel](https://riot.im/app/#/room/#althea:matrix.org) and let us
know. We'll do our best to add support.

## So I flashed the firmware, what do I do now?

First things first, the Althea firmware repurposes some ports for meshing. So those ports will
no longer work to access the LAN of your device. If you plug in and get no results that's
probably what's happening.

The provided nightly builds use the the `althea-dev.yml` management profile and the `gateway`
port selection setting. Since this seems to be what people want most often right now. In gateway
mode every device has a WAN port (to peer to the exit/internet), some mesh ports, and a LAN port.
If the router has a yellow or otherwise marked WAN port Althea keeps that as the WAN interface.
The last LAN port (physically furthest away from the WAN port) is the new Althea LAN. All other ports
are repurposed for meshing. In the case that a device has only numbered ports, the lowest number is the
WAN port.

There are some exceptions to these rules, for example the aclite has only one physical port. Which is
either mesh, or WAN depending on your settings.

Now that you know what to plug in where you can plugin to the LAN port or login to the wifi SSID
`AltheaHome` and use the default password `ChangeMe` (note the capitals). Once you're connected
you can ssh into the router using `ssh root@192.168.10.1` this is passwordless, I strongly suggest
running `passwd` and setting a proper password if you plan to use the device for a while.

If an existing internet connection is plugged into the WAN port or the device is connected by the
mesh port to any other device with a WAN connection you should get proper internet access over the
LAN. This is proxied over a Wireguard VPN and is secure from inspection or attack by other nodes in
the mesh or the backhaul connection provider.

In the very possible case that this doesn't work right away you can run the `wg` command via ssh.
If you see a tunnel called `wg_exit` everything has come online neatly. If you don't see any tunnels
running (defined recent handshakes) you should debug the local tunnel/billing daemon. Run top and
see if `rita` is on the list. If it's not check /var/log/rita.log for the crash error.

If you see successful Wireguard interfaces but no `wg_exit` then the problem is not on your router
but either in the path from the network to the exit server or with the exit server itself. Go find
whatever device on the mesh is connected with the WAN port and see if it has a `wg_exit` interface
and connectivity.

As of this writing the graphical user interface is installed on the routers but not integrated
with the actual on router software. So `http://192.168.10.1/althea` will return a router settings
page, but only show fake placeholder info. We hope to resolve that and add more functionality
for debugging there in the near future.

### The meshing, how does that work?

Babel, and by extension Althea works by building a L3 network out of L2 links, 'mesh ports' on
your router will have any link plugged into them searched for peers and connections made. For
example if you simply use an ethernet cable to link the mesh ports of a set of routers they will
connect to each other and pass connections between each other.

In a real network point to point wireless links will be used. You can find instructions on how
to both select radios and set htem up in [the Althea network getting started guide](https://docs.google.com/document/d/1TeFIUjqG1I4DYxRrkpxk4yEUQoxhIVxkccYWwT5VQD8/edit)

While point to point links are insurmountably superior to meshing with the built in device
radios there may be some situations where you may want to do that for a hop or two to reduce
the number of point to point links or otherwise make life easier. In that case you'll need
to build a firmware with the flag `mesh_wifi=true` you can pass it with `-e` to the firmware
builder or set it in a management profile.

We may switch the nightly firmwares to meshing on built in wifi if there's a larget demand
for that.
