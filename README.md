screenconfig
============

This utility is a small and simple screen configurator. It consists fo two files (README not included :-)

Files
-----

### screenconfig

'screenconfig' contains the rules for the screen layout and the xrandr calls for activating it. For now you have to change this file according to your needs.

### 99-screenconfig.rules

For automation purposes a udev rule is included in '99-screenconfig.rules'. You generally should not need to change this file.

Install
-------

(sorry, currently you have to edit the script in /usr/bin/)

1. checkout sourcecode
2. run make package (you need build-essentials)
3. edit /usr/bin/screenconfig according to your needs, especcially modify the 'USER' variable
4. reload udev: /etc/init.d/udev reload


Example
-------

The included example checks 3 outputs (HDMI/DVI, VGA and LVDS (Notebook included display)) and works as follows:

* HDMI and VGA and LVDS are connected
    * LVDS is deactivated
    * HDMI and VGA are activated
    * HDMI is positioned right of VGA, HDMI is primary
* HDMI and LVDS are connected
    * VGA is deactivated
    * HDMI and LVDS are activated
    * HDMI is positioned right of LVDS, HDMI is primary
* VGA and LVDS are connected, VGA has EDID name of EPSON|BENQ
    * HDMI is deactivated
    * VGA and LVDS are activated, LVDS is primary
    * VGA is positioned right of LVDS
* VGA and LVDS are connected
    * HDMI is deactivated
    * VGA and LVDS are activated
    * VGA is positioned right of LVDS, VGA is primary
* Only LVDS is connected
    * HDMI and VGA are deactivated
    * LVDS is activated, LVDS is primary

Note
----

* Each time the udev event 'drm' is triggered the screen positioning will be executed. This event is triggered when
    * A display is connected
    * A display is disconnected
    * After waking up from a suspend mode
* Screen repositioning can be manually triggered by executing '/etc/udev/scripts/screenconfig.sh'

Planned Features
----------------

see TODO.txt
