Althea Firmware Builder
===================

This repo is dedicated to building custom OpenWRT firmware for Althea routers.
Similar to LibreMesh's [Lime-SDK](https://github.com/libremesh/lime-sdk) or
SudoMesh's [SudoWRT](https://github.com/sudomesh/sudowrt-firmware) firmware
builder. All of these perform much the same function, maintaining a series of
config files, patches, and packages to insert into a OpenWRT firmware image.

The Althea firmware builder deviates from existing efforts with a strong focus
on readability and simplicity. There's no reason for everyone to have their
own bespoke tooling to do the same thing, but long bash scripts tend to
encourage that sort of thing by being incomprehensible.

----------

Is this where I get Althea?
------------------------------------------

If you just want Althea on your router please download a firmware release from
our website once it becomes available. This page is for developers who want
to help improve Althea.

Getting Started
--------------------

First off you need a Linux machine with at least 15gb of free disk space,
4gb of free ram and Ansible.

On Ubuntu and Debian:
> sudo apt-get install ansible

On Fedora:
> sudo dnf install ansible

On Centos and RHEL:
> sudo yum install ansible

Once you have Ansible you can use it to manage the rest of the dependencies:
> git clone https://github.com/althea-mesh/althea-firmware
> cd althea-firmware
> ansible-playbook first-time-setup.yml --ask-sudo-pass

Type in your password to give Ansible permissions to install the required
packages. Or go and look at the dependencies list in
`althea-firmware/roles/check-deps/defaults/main.yml` and install them manually.

Building the firmware
-----------------------------

If there is an existing hardware profile for your device building the firmware
should be pretty simple. Here are the existing hardware config names.

Hardware Config | Target Name | Full model name
----------------|-------------|-----------------
      n600      |    ar71xx   | WD My Net N600 Model: C3

To build the firmware for your device run, replacing '<Hardware Config>' with
the value from the table above:
> ansible-playbook firmware-build.yml -e conf_to_build=<Hardware Config>

This will take a long time, especially the first run. Nearly an hour on a fast
machine and several on a slower one. After the first run things should be much
faster due to cached builds. On the order of 5-10 minutes.

If you need to build for another target, just run again with a different conf
parameter.

When finished your firmware images will be located in
`althea-firmware/build/bin/targets/<Target Name>/generic/` depending on what
flashing method you use different files in that directory will be appropriate.

Now that you have the firmware file, follow the OpenWRT guide to
[installing firmware](https://wiki.openwrt.org/doc/howto/generic.flashing).

Or in the case that you already have a version of OpenWRT installed follow the
[firmware update](https://wiki.openwrt.org/doc/howto/generic.sysupgrade) guide.

Follow the instructions carefully, it's possible to destory the device if done
improperly and rarely even when done properly. Never flash anything you can't
afford to lose.

Somthing didn't work
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


