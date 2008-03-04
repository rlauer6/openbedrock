#!/usr/bin/expect -f
# -*-tcl-*-

# bedrock-create-site-example.com: Simple wrapper around
# bedrock-create-site(1).
#
# Demonstrates a secure way of automating the invocation of the
# bedrock-create-site(1) program without passing the Apache auth db password
# on the command line.
#
# See bedrock-create-site(1)

set force_conservative 0  ;# set to 1 to force conservative mode even if
			  ;# script wasn't run conservatively originally
if {$force_conservative} {
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- $arg
	}
}

set timeout 10

# We don't want the user to see the password prompt
log_user 0

spawn "/path/to/bedrock-create-site" \
    --verbose \
    --domain-name=example.com \
    --site-dir=/var/www/vhosts/example.com \
    --site-conf=/etc/httpd/conf.d/example.com.conf \
    --apache-mod-perl-startup=/etc/httpd/conf.d/example.com-startup.pl \
    --apache-auth-db-user=foouser \
    $argv
expect -re "DB Password for .*: "
send -- "foopass\r"

# Restore user-visible output
log_user 1

interact
# (pid, spawn_id, -1|0, status|errno) = wait
set waitout [wait]
flush stdout
#
# Exit with the exit status of bedrock-create-site
exit [lindex $waitout 3]
