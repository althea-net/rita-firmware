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

---

## Is this where I get Althea?

If you are an Althea user, talk to your local network organizer or [contact us](mailto:hello@althea.net) to buy a pre-flashed device.
This page is for advanced users and network organizers.

If you are an advanced user or a network organizer yes, this is where you get the firmware images
to install Althea on routers. For supported devices we have special supported images, these firmware
images send some non-identifying data such as bug reports, crashes, and mesh status logs to Althea.

Please see the [flashing](#flashing) and [what do I do now?](#so-i-flashed-the-firmware-what-do-i-do-now)
sections for details on what to expect flashing and using a firmware.

### Supported device targets

These devices recieve first class citizen testing and support

| Hardware Config | Target Name | Full model name           | Price    | Features/Comments                   | Flashing Difficulty | Buy Link                                                                                         | Latest Release Firmware Download                                                                                                | Latest Release Plus Remote Monitoring/Support Firmware Download                                                                          | OpenWRT Wiki / Flashing Instructions                                                           | Special Firmware to escape factory stock                                                                                             |
| --------------- | ----------- | ------------------------- | -------- | ----------------------------------- | ------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| x86_64          | x86_64      | Any 64 bit x86 processor  | varies   | Essentially any desktop or laptop   | Moderate, USB       | N/A                                                                                              | [link](https://updates.altheamesh.com/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz)                                       | [link](https://updates.altheamesh.com/supported/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz)                                       | Unzip, write to flash drive, boot from flash drive                                             | N/A                                                                                                                          |
| mikrotik_hap-ac2 | ipq40xx    | Mikrotik HAP-AC2          | $70 new  | AC wifi, 200mbps perf               | Moderate, TFTP      | [Amazon](https://www.amazon.com/dp/B079SD8NVQ), [Baltic](https://www.balticnetworks.com/mikrotik-hap-ac2-dual-band-desktop-ap-us) | [link](https://updates.altheamesh.com/targets/ipq40xx/mikrotik/openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin)          | [link](https://updates.altheamesh.com/targets/ipq40xx/mikrotik/openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-squashfs-sysupgrade.bin)          | [Same as OpenWRT](https://openwrt.org/toh/mikrotik/common) | [link](https://updates.altheamesh.com/targets/ipq40xx/mikrotik/openwrt-ipq40xx-mikrotik-mikrotik_hap-ac2-initramfs-kernel.bin)                                                                                                                         |
| glb1300         | ipq40xx     | GL.iNet GL-B1300          | $90 new  | AC wifi, 200mbps perf, easy to find | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B079FJKZV8)                                                   | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/openwrt-ipq40xx-generic-glinet_gl-b1300-squashfs-sysupgrade.bin)          | [link](https://updates.altheamesh.com/supported/targets/ipq40xx/generic/openwrt-ipq40xx-generic-glinet_gl-b1300-squashfs-sysupgrade.bin)          | [link](https://forum.altheamesh.com/t/a-humans-illustrated-router-flashing-guide/113/3?u=ttk2) | N/A                                                                                                                          |
| ea6350v3        | ipq40xx     | Linksys EA 6350 v3        | $70-100 new  | AC wifi, 200mbps perf  | Easy, webpage, hard to find  | [Amazon](https://www.amazon.com/dp/B00JZWQW4C)                                                   | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/openwrt-ipq40xx-generic-linksys_ea6350v3-squashfs-sysupgrade.bin) | [link](https://updates.altheamesh.com/supported/targets/ipq40xx/generic/openwrt-ipq40xx-generic-linksys_ea6350v3-squashfs-sysupgrade.bin) | [link](https://forum.altheamesh.com/t/althea-router-flashing-guide/113/5?u=ttk2) very similar  | N/A                                                                                                                          |
| mr8300          | ipq40xx     | Linksys MR 8300           | $140 new | 250mbps, solid construction         | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B07L9282JK), [Linksys](https://www.linksys.com/us/p/MR8300/), [Best Buy](https://www.bestbuy.com/site/6309260.p), [B&H](https://www.bhphotovideo.com/c/product/1459850-REG/), [Staples](https://www.staples.com/product_24474905) | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/-ipq40xx-generic-linksys_mr8300-squashfs-sysupgrade.bin) | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/openwrt-ipq40xx-generic-linksys_mr8300-squashfs-sysupgrade.bin) | similar to [OpenWRT](https://openwrt.org/toh/linksys/mr8300#oem_easy_installation)   go to https://192.168.1.1/fwupdate.html login with admin:admin                        | [link](https://updates.altheamesh.com/targets/ipq40xx/generic/openwrt-ipq40xx-generic-linksys_mr8300-squashfs-factory.bin) |
| wrt3200acm      | mvebu       | Linksys WRT 3200 ACM      | $205 new | Fast (500mbps), solid construction  | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B01JOXW3YE), [B&H](https://www.bhphotovideo.com/c/product/1281287-REG/) | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt3200acm-squashfs-sysupgrade.bin) | [link](https://updates.altheamesh.com/supported/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt3200acm-squashfs-sysupgrade.bin) | [link](https://oldwiki.archive.openwrt.org/toh/linksys/wrt_ac_series)                          | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt3200acm-squashfs-factory.img) |
| wrt32x          | mvebu       | Linksys WRT 32x           | $290 new | Fast (500mbps), solid construction  | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B078216T6C), [Walmart](https://www.walmart.com/ip/490521971), [newegg](https://www.newegg.com/p/N82E16833124643)  | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt32x-squashfs-sysupgrade.bin)     | [link](https://updates.altheamesh.com/supported/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt32x-squashfs-sysupgrade.bin)     | [link](https://oldwiki.archive.openwrt.org/toh/linksys/wrt_ac_series)                          | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt32x-squashfs-factory.img)     |
| pi4-64          | bcm2711     | Raspberry PI 4 B          | $35 new  | good to start with                  | Moderate, USB       | [Adafruit](https://www.adafruit.com/product/4295) | [link](https://updates.altheamesh.com/targets/brcm2708/bcm2710-glibc/openwrt-brcm2708-bcm2710-rpi-3-ext4-factory.img.gz)    |  [link](https://updates.altheamesh.com/targets/brcm2708/bcm2710-glibc/openwrt-brcm2708-bcm2710-rpi-3-ext4-factory.img.gz) | Unzip, write to sd card, insert into pi and boot                                               | N/A                                                                                                                                                                                                                                                           |
| nanopi-r2s      | rockchip    | FriendlyElec NanoPi R2S   | $55 new  | 500mbps perf                        | Moderate, SD card   | [China](https://www.friendlyarm.com/index.php?route=product/product&product_id=282)              | [link](https://updates.altheamesh.com/targets/rockchip/armv8/openwrt-rockchip-armv8-friendlyarm_nanopi-r2s-ext4-sysupgrade.img.gz)      | [link](https://updates.altheamesh.com/targets/rockchip/armv8/openwrt-rockchip-armv8-friendlyarm_nanopi-r2s-ext4-sysupgrade.img.gz)      | Gunzip, flash to [class10 SD](https://www.amazon.com/SanDisk-Endurance-microSDHC-Adapter-Monitoring-dp-B07P14QHB7) ([more info](http://wiki.friendlyarm.com/wiki/index.php/NanoPi_R2S))| N/A                                                                                          |
| edgerouter-x    | ramips      | Ubiquiti Edgerouter X     | $59 new  | 150mbps, no wifi, many ports        | Hard, CLI, SSH      | [Amazon](https://www.amazon.com/dp/B00YFJT29C), [UI](https://store.ui.com/collections/operator-isp-infrastructure/products/edgerouter-x)    | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt_edgerouter-x-squashfs-sysupgrade.bin)             | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt_edgerouter-x-squashfs-sysupgrade.bin)         | [guide](https://forum.altheamesh.com/t/flash-and-configure-the-ubiquiti-edgerouter-x-er-x/350), [link](https://openwrt.org/toh/ubiquiti/ubiquiti_edgerouter_x_er-x_ka)                         | [link](https://updates.altheamesh.com/special/openwrt-ramips-mt7621-ubnt-erx-sfp-initramfs-factory.tar)         |
| edgerouter-x-sfp | ramips     | Ubiquiti Edgerouter X SFP | $99 new  | 150mbps, no wifi, many ports        | Hard, CLI, SSH      | [Amazon](https://www.amazon.com/dp/B012X45WH6), [UI](https://store.ui.com/collections/operator-isp-infrastructure/products/edgerouter-x-sfp)    | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt_edgerouter-x-sfp-squashfs-sysupgrade.bin)     | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-ubnt_edgerouter-x-sfp-squashfs-sysupgrade.bin)             | [guide](https://forum.altheamesh.com/t/flash-and-configure-the-ubiquiti-edgerouter-x-er-x/350), [link](https://openwrt.org/toh/ubiquiti/ubiquiti_edgerouter_x_er-x_ka)                         | [link](https://updates.altheamesh.com/special/openwrt-ramips-mt7621-ubnt-erx-initramfs-factory.tar)             |


### Best best effort device targets

These devices have hardware profies and are confirmed to have worked at least once. But they may
or may not work now.

The mips64 targets won't work without a special Rust target see [this error](https://github.com/rust-lang/rust/issues/50890)

| Hardware Config | Target Name   | Full model name          | Price      | Features/Comments                    | Flashing Difficulty | Buy Link                                                                                             | Latest Release Download                                                                                                        | OpenWRT Wiki / Flashing Instructions                                                           | Special Firmware to escape stock                                                                                                                                                                                                                              |
| --------------- | ------------- | ------------------------ | ---------- | ------------------------------------ | ------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| aircube         | ath79         | Ubiquiti airCube ISP     | $30 new    | Slow CPU 20mbps max, flexible        | Moderate, webpage   | [Ubiquiti](https://store.ui.com/products/aircube-isp?_pos=1&_sid=08dc8c1ce&_ss=r)                    | [link](https://updates.altheamesh.com/targets/ath79/generic/openwrt-ath79-generic-ubnt_acb-isp-squashfs-sysupgrade.bin")       | [link](https://openwrt.org/toh/ubiquiti/ubiquiti_aircube_isp)                                  | intermediary [link](http://downloads.openwrt.org/snapshots/targets/ath79/generic/openwrt-ath79-generic-ubnt_acb-isp-squashfs-factory.bin)                                                                                                                     |
| aclite          | ar71xx        | UniFi AP AC LITE         | $85 new    | great for clients not for much else  | Hard, ssh           | [Amazon](https://www.amazon.com/Ubiquiti-Unifi-Ap-AC-Lite-UAPACLITEUS/dp/B015PR20GY/)                | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-ubnt-unifiac-lite-squashfs-sysupgrade.bin) | [link](https://wiki.openwrt.org/toh/ubiquiti/unifiac)                                          | N/A                                                                                                                                                                                                                                                           |
| edgerouterlite  | octeon        | Ubiquiti EdgeRouter Lite | $95 new    | HW acceleration not enabled 50mbps   | Medium, drive image | [Amazon](https://www.amazon.com/Ubiquiti-EdgeMax-EdgeRouter-ERLite-3-Ethernet/dp/B00CPRVF5K)         | [link](https://updates.altheamesh.com/targets/octeon/generic-glibc/openwrt-octeon-erlite-squashfs-sysupgrade.tar)              | [link](https://openwrt.org/toh/ubiquiti/edgerouter.lite)                                       | N/A                                                                                                                                                                                                                                                           |
| n750            | ar71xx        | WD My Net N750 Model: C3 | $30 new    | Slow CPU 30mbps max, good for dev    | Easy, webpage       | [Rakuten](https://www.rakuten.com/shop/grassroots-computers/product/WDBAJA0000NWTRECF/)          | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n750-squashfs-factory.bin)            | [link](https://updates.altheamesh.com/supported/targets/ar71xx/generic/openwrt-ar71xx-generic-mynet-n750-squashfs-factory.bin)            | [link](https://forum.altheamesh.com/t/a-humans-illustrated-router-flashing-guide/113/3?u=ttk2) | N/A                                                                                                                          |
| tplinkc7v2      | ar71xx        | TP Link Archer C7 V2     | $85 new    | great wifi range, slow cpu           | Easy, webpage       | [Ebay](https://www.ebay.com/itm/401001274989)                                                        | [link](https://updates.altheamesh.com/targets/ar71xx/generic/openwrt-ar71xx-generic-archer-c7-v2-squashfs-factory-us.bin)      | [link](https://wiki.openwrt.org/toh/tp-link/archer-c5-c7-wdr7500)                              | N/A                                                                                                                                                                                                                                                           |
| ea3500          | kirkwood      | Linksys ea3500 'audi'    | $30 refurb | Low ram, may or may not work now     | Moderate, webpage   | [Amazon](https://www.amazon.com/Linksys-EA3500-Dual-Band-Certified-Refurbished/dp/B00L4HWY3E/)       | [link](https://updates.altheamesh.com/targets/kirkwood/generic/openwrt-kirkwood-linksys_audi-squashfs-factory.bin)             | [link](https://forum.openwrt.org/t/installing-lede-on-ea3500/4460/12)                          | intermediary [link](https://downloads.openwrt.org/snapshots/trunk/kirkwood/generic/openwrt-kirkwood-linksys-audi-squashfs-factory.bin)                                                                                                                        |
| ea7300v2        | ramips      | Linksys EA 7300 v2        | $80-130 new  | AC wifi, 120mbps perf, easy to find | Easy, webpage   | [Amazon](https://www.amazon.com/dp/B01JOXW58I), [Linksys](https://www.linksys.com/us/p/p-ea7300/)                  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7300-v2-squashfs-sysupgrade.bin)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7300-v2-squashfs-sysupgrade.bin) | [link](https://forum.altheamesh.com/t/althea-router-flashing-guide/113/5?u=ttk2) very similar  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7300-v2-squashfs-factory.bin)                                                                    |
| ea7500v2        | ramips      | Linksys EA 7500 v2        | unavailable  | AC wifi, 200mbps perf, easy to find | Easy, webpage   | [Amazon](https://www.amazon.com/dp/B019WAQMVY)                                                   | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7500-v2-squashfs-sysupgrade.bin)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7500-v2-squashfs-sysupgrade.bin) | [link](https://forum.altheamesh.com/t/althea-router-flashing-guide/113/5?u=ttk2) very similar  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_ea7500-v2-squashfs-factory.bin)                                                                    |
| wrt1900acs      | mvebu       | Linksys WRT 1900 ACS      | $180 new | Fast (430mbps), solid construction  | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B014MIBLSA/), [B&H](https://www.bhphotovideo.com/c/product/1232984-REG/) | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt1900acs-squashfs-sysupgrade.bin) | [link](https://updates.altheamesh.com/supported/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt1900acs-squashfs-sysupgrade.bin) | [link](https://oldwiki.archive.openwrt.org/toh/linksys/wrt_ac_series)                          | [link](https://updates.altheamesh.com/targets/mvebu/cortexa9/openwrt-mvebu-cortexa9-linksys_wrt1900acs-squashfs-factory.img) |
| pi2             | brcm2708      | Raspberry PI 2B/3B/+     | $35 new    | good to start with                   | Moderate, USB       | [Amazon](https://www.amazon.com/Raspberry-Pi-RASPBERRYPI3-MODB-1GB-Model-Motherboard/dp/B01CD5VC92/) | [link](https://updates.altheamesh.com/targets/brcm2708/bcm2709/openwrt-brcm2708-bcm2709-rpi-2-ext4-sdcard.img.gz)              | Unzip, write to sd card, insert into pi and boot                                               | N/A                                                                                                                                                                                                                                                           |
| pi3-64          | brcm2710      | Raspberry PI 3B+         | $35 new    | good to start with                   | Moderate, USB       | [Amazon](https://www.amazon.com/Raspberry-Pi-RASPBERRYPI3-MODB-1GB-Model-Motherboard/dp/B01CD5VC92/) | [link](https://updates.altheamesh.com/targets/brcm2708/bcm2710-glibc/openwrt-brcm2708-bcm2710-rpi-3-ext4-factory.img.gz)       | Unzip, write to sd card, insert into pi and boot                                               | N/A                                                                                                                                                                                                                                                           |
| x86             | i386_pentium4 | Any 32 bit x86 processor | varies     | Essentially old desktops or laptops  | Moderate, USB       | N/A                                                                                                  | [link](https://updates.altheamesh.com/targets/x86/generic/openwrt-x86-generic-combined-squashfs.img.gz)                        | Unzip, write to flash drive, boot from flash drive                                             | N/A                                                                                                                                                                                                                                                           |
| tplinka6v3      | ramips      | TP-Link Archer A6 V3      | $50 new  | AC wifi, 120mbps perf, easy to find | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B08KJF5BS7), [B&H](https://www.bhphotovideo.com/c/product/1643221-REG/), [newegg](https://www.newegg.com/p/N82E16833704585)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-tplink_archer-a6-v3-squashfs-sysupgrade.bin)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-tplink_archer-a6-v3-squashfs-sysupgrade.bin) | [TODO](https://forum.altheamesh.com) | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-tplink_archer-a6-v3-squashfs-factory.bin)                                                                                                                          |
| linksys_e5600   | ramips      | Linksys E5600             | $50 new  | AC wifi, 120mbps perf, easy to find | Easy, webpage       | [Amazon](https://www.amazon.com/dp/B08FBMDYJ3), [Linksys](https://www.linksys.com/us/p/E5600), [Walmart](https://www.walmart.com/ip/517432635)   | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_e5600-squashfs-sysupgrade.bin)  | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_e5600-squashfs-sysupgrade.bin) | [TODO](https://forum.altheamesh.com) | [link](https://updates.altheamesh.com/targets/ramips/mt7621/openwrt-ramips-mt7621-linksys_e5600-squashfs-factory.bin)                                                                                                                          |

---

## Getting Started Building Firmware

First off you need a Linux machine with at least 15gb of free disk space,
4gb of free ram and Ansible >=2.5.

On Ubuntu < 18.04 and Debian:

> curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

> python get-pip.py

> pip install --user ansible

On Ubuntu >= 18.04:

> sudo apt-get install ansible

On Fedora:

> sudo dnf install ansible

On Centos and RHEL:

> sudo yum install ansible

Once you have Ansible you can use it to manage the rest of the dependencies:

```
git clone https://github.com/althea-mesh/althea-firmware
cd althea-firmware
ansible-playbook first-time-setup.yml -bK
```

Type in your password to give Ansible permissions to install the required
packages. This will also install Rust and add it to your PATH in your bashrc.

If you have a nonstandard setup, or just don't trust Ansible with root
you may want to install dependencies manually using these commands.

Debian:

    sudo apt-get install build-essential libncurses5-dev gawk git subversion libssl-dev gettext unzip zlib1g-dev file python systemtap-sdt-dev npm time curl which ansible rsync

Ubuntu:

    sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext libssl-dev unzip systemtap-sdt-dev npm time curl which ansible rsync

Centos:

    sudo yum install subversion binutils bzip2 gcc gcc-c++ gawk gettext flex ncurses-devel zlib-devel make patch unzip perl-ExtUtils-MakeMaker glibc glibc-devel quilt ncurses-libs sed intltool bison wget git-core openssl-devel xz systemtap-sdt-devel npm time curl which ansible rsync genisoimage qemu-img

Fedora:

    sudo dnf install subversion binutils bzip2 gcc gcc-c++ gawk gettext git-core flex ncurses-devel ncurses-compat-libs zlib-devel zlib-static make patch unzip perl-ExtUtils-MakeMaker perl-Thread-Queue glibc glibc-devel glibc-static quilt sed sdcc intltool sharutils bison wget openssl-devel systemtap-sdt-devel npm time curl which ansible rsync genisoimage qemu-img perl-FindBin

Arch:

    sudo pacman -S subversion binutils bzip2 gcc gcc-libs gawk gettext git flex ncurses zlib automake patch unzip perl glibc quilt sed sdcc intltool sharutils bison wget openssl systemtap npm time curl which ansible rsync

You can then install Yarn using npm

sudo npm -g install yarn

Finally install [Rust](https://www.rustup.rs/)

    curl https://sh.rustup.rs -sSf | sh

Follow the onscreen instructions. Then add Rustup to your PATH. For a default install:

    export PATH="$HOME/.cargo/bin:$PATH"

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

By default most devices come with all mesh ports and a single lan port, or in cases
like the Raspberry pi where only a single port is available they will have that port
assigned as mesh and wifi assigned as the only way to access LAN.

Port assignment can be changed live once the router is built. But it does take some time.
If you want a device to have a gateway port by default for example you can simply move
a given interface from mesh interfaces into the wan interface slot.

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

## Building the firmware didn't work

Follow the debugging instructions provided by the build playbook. That should
give you a proper error message. Drop by
[our Matrix channel](https://riot.im/app/#/room/#althea:matrix.org) and let us
know what happened. We'll be happy to help out.

You might [clean the build folder](https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#cleaning_up) if you've made any changes and are starting over.

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

Then run `make -j <num cores>` to build the firmware, this will take a while. When it's finished flash the resulting image.
Login via ssh and copy `/etc/config/network`and`/etc/config/wireless`, you will edit these files into Althea templates that
will reside in `roles/build-config/templates`. Look in that folder for existing examples. The requirements
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

For typical use cases see the [Setting up your Althea router](https://forum.altheamesh.com/t/setting-up-your-new-althea-router/) guide.

If you would like to do techncial debugging here are some tips and tricks.

You can ssh into the rotuer using `ssh root@192.168.10.1` from the lan port of the WiFi networks.
This connection is passwordless and I strongly suggest running `passwd` and setting a proper password if you plan to use the device for a while.

Once logged into ssh, run the `top` command and look for a process called `rita` this is our primary network and payment daemon. If it's crashed
you can try to restart it with `service rita start` (there will be a 30 wait period on startup). If it crashes again after checking top you can
use this debugging trick to get a stack trace.

`ssh root@192.168.10.1 RUST_BACKTRACE=full RUST_LOG=trace rita --config=/etc/rita.toml --platform=linux &> out.log`

What this line does is execude Rita as a one off command over ssh, allow the logging output to be redirected into a local file on your computer
for easy inspection.

If Rita is running properly but you can't see any peers on the dashboard (see the setup guide above) then run the command `wg` you should
see at least one active tunnel or several if you have a connection plugged into the WAN port. If you don't you should either debug your
WAN connection or your mesh neighbors router respectively.

### The meshing, how does that work?

Babel, and by extension Althea works by building a L3 network out of L2 links, 'mesh ports' on
your router will have any link plugged into them search for peers and connect. For
example if you simply use an ethernet cable to link the mesh ports of a set of routers they will
connect to each other and pass connections between each other.

In a real network point to point wireless links will be used. You can find instructions on how
to both select radios and set them up in [the Althea network getting started guide](https://docs.google.com/document/d/1TeFIUjqG1I4DYxRrkpxk4yEUQoxhIVxkccYWwT5VQD8/edit)

While point to point links are insurmountably superior to meshing with the built in device radios there may be some situations
where you may want to do that for a hop or two to reduce the number of point to point links or otherwise make life easier.
In that case you'll need to ssh in and edit `/etc/config/wireless` and enable the `AltheaMesh` SSID by flipping `enabled` form `0` to `1`

followed by `wifi restart`

We may switch the firmwares to meshing on built in wifi by default if there's a larger demand for that.


## Setting up an Exit server

An Althea Exit server is essentially a WireGuard proxy server setup to integrate
with the mesh network.

Copy the file `profiles/exit/config-example.yml` to `profiles/exit/config.yml` and modify it as needed.

There's a lot of data that goes into the config file for an exit.  

If you configure your gateway with a url containing multiple DNS entires for each server Althea clients will automatically connect and failover. 

If you don't want to run multiple servers simply remove that line.

Next are authentication settings, we've included blank SMTP mail auth settings. If you leave mailer
`true` you can fill out those details and have the exit send users emails to authorize. If you turn
mailer to `false` it will disable authentication of new users.  
If you set `phone` to `true` and include `phone_auth_api_key`, `twillio_account_id`, 
and `twillio_auth_token`, it will send an auth code from `send_number`

Finally you need to generate another set of keys and uncomment the appropriate blockchain full nodes and settings. 
You must also select an arbitrary valid ipv6 address out of the fd00::/8 range

When setting up a new postgres database you'll need to run the migrations [here](https://github.com/althea-net/althea_rs/tree/master/exit_db)

Installing and running PostgreSQL is a large topic not fully described here.
A simple TLDR to install locally on Fedora:
```
sudo dnf install postgresql-server
sudo /usr/bin/postgresql-setup --initdb
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

sudo su - postgres 
psql postgres
postgres=# create database exitdb;
postgres=# create user exituser with encrypted password 'exitpassword';
postgres=# grant all privileges on database exitdb to exituser;
postgres=# exit
nano data/pg_hba.conf

# make sure the following lines end with 'trust' or 'md5'
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust

# now you should be able to do: 
psql "postgresql://exituser:exitpassword@localhost/exitdb"
```

Assuming you have PostgreSQL running and a database URL, proceed:

```
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# you may need to install additional dependencies
# fedora
sudo dnf install libpq-devel community-mysql-devel

# install diesel
cargo install diesel_cli
# clone althea_rs
git clone https://github.com/althea-net/althea_rs
# run the migrations
cd althea_rs/exit_db
diesel migration run --database-url=""
```

Now that everything is finally configured you can run ansible to build your exit server image

> ansible-playbook -e @profiles/devices/x86_64.yml -e @profiles/management/althea-managed.yml -e @profiles/exit/config-example.yml firmware-build.yml



### Adding your new exit to an Althea client

Currently we ship exits as part of the default config file in [the firmware](https://github.com/althea-net/althea-firmware/blob/master/roles/build-config/templates/rita.toml.j2#L29) but that's
hardly the only way to configure one.

You can manually edit the /etc/rita.toml file on a client and paste in a block like this

```
[exit_client.exits.test]
registration_port = 4875
description = "The Althea testing exit cluster. Unstable!"
state = "New"
[exit_client.exits.test.id]
mesh_ip = "fd00::1337:1e0f"
eth_address = "0x5aee3dff733f56cfe7e5390b9cc3a46a90ca1cfa"
wg_public_key = "zgAlhyOQy8crB0ewrsWt3ES9SvFguwx5mq9i2KiknmA="
```

Replace the eth address with the public address of the private key you configured in the exit hosts file and the public key should be the value of `the wg_exit_public_key` likewise `mesh_ip`
is the value of `exit_mesh_ip` as configured above. The description is arbitrary so put whatever you like.

You can also use curl to directly insert a new exit

```
curl -vv -XPOST -H 'Content-Type: application/json' -d
 "test_exit": {
      "id": {
        "mesh_ip": "fd00::1337:e4f",
        "eth_address": "0xe4ad1f9aa23957d294d869b70fc8f28774df896e",
        "wg_public_key": "1kKSpzdhI4kfqeMqch9I1bXqOUXeKN7EQBecVzW60ys=",
      },
      "registration_port": 4875,
      "description": "An arbitrary testing exit",
      "state": "New",
    }
192.168.10.1:4877/exits
```

Or even direct curl to a remote list of exits over https. This will load a file from the
destination and extract a Json formatted list of exits (see the formatting of the previous request as an example).

```
curl 127.0.0.1:4877/exits/sync -H "Content-Type:application/json" -d '\{"url": "https://somewhere.safe"\}
```
