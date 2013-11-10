screenconfig
============

This utility is a small and simple screen configurator. It consists fo two files (README not included :-)

Files
-----

### screenconfig.sh

'screenconfig.sh' contains the rules for the screen layout and the xrandr calls for activating it. For now you have to change this file according to your needs.

### 99-screenconfig.rules

For automation purposes a udev rule is included in '99-screenconfig.rules'. You generally should not change this file.

Install
-------

1. Copy '99-screenconfig.rules' to '/etc/udev/rules.d/'
2. Copy 'screenconfig.sh' to '/etc/udev/scripts/' (which may not exist, in this case create it)
3. Set appropriate acl on 'screenconfig.sh', e.g. 'chmod 744 /etc/udev/scripts/screenconfig.sh'
4. Modify 'screenconfig.sh' according to your needs, especially modify the 'USER' variable.
5. Reload udev with '/etc/init.d/udev reload'

Example
-------

The included example checks 3 outputs (HDMI/DVI, VGA and LVDS (Notebook included display)) and works as follows:

* HDMI and VGA and LVDS are connected
*    LVDS is deactivated
*    HDMI and VGA are activated
*    HDMI is positioned right of VGA
* HDMI and LVDS are connected
*    VGA is deactivated
*    HDMI and LVDS are activated
*    HDMI is positioned right of LVDS
* VGA and LVDS are connected
*    HDMI is deactivated
*    VGA and LVDS are activated
*    VGA is positioned right of LVDS
* Only LVDS is connected
*    HDMI and VGA are deactivated
*    LVDS is activated

Note
----

* Each time the udev event 'drm' is triggered the screen positioning will be executed. This event is triggered when
*    A display is connected
*    A display is disconnected
*    After waking up from a suspend mode
* Screen repositioning can be manually triggered by executing '/etc/udev/scripts/screenconfig.sh'

Planned Features
----------------

* Separate config from logic
* Use a configuration language
* Use a state machine
