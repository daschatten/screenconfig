#
# Regular cron jobs for the screenconfig package
#
0 4	* * *	root	[ -x /usr/bin/screenconfig_maintenance ] && /usr/bin/screenconfig_maintenance
