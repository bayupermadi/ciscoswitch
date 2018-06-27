#!/usr/bin/expect -f

# set the paramater
set timeout 20
set IPaddress [lindex $argv 0]
set Username "username"
set Password "password"
set Directory ./

# logs your session
log_file -a $Directory/session_$IPaddress.log
send_log "### /START-SSH-SESSION/ IP: $IPaddress @ [exec date] ###\r"

# start your session
spawn ssh -o "StrictHostKeyChecking no" $Username@$IPaddress

# login 
expect "*"
send "$Username\r"
expect "*"
send "$Password\r"

# activate config terminal
expect "*#"
send "conf t\r"
expect "(config)#"

# Limit bandwidth targeted interfaces
send "int Fa 4\r"
expect "*(config-if)#"
send "rate-limit 512\r"
expect "*(config-if)#"
send "traffic-shape 1024\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

send "int Fa 8\r"
expect "*(config-if)#"
send "rate-limit 512\r"
expect "*(config-if)#"
send "traffic-shape 1024\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

# migrate devices from vlan 1 to vlan 2
send "int Fa 3\r"
expect "*(config-if)#"
send "no switchport trunk native vlan 2\r"
expect "*(config-if)#"
send "no switchport forbidden default-vlan\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

send "int Fa 4\r"
expect "*(config-if)#"
send "no switchport trunk native vlan 2\r"
expect "*(config-if)#"
send "no switchport forbidden default-vlan\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

send "int Fa 5\r"
expect "*(config-if)#"
send "no switchport trunk native vlan 2\r"
expect "*(config-if)#"
send "no switchport forbidden default-vlan\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

send "int Fa 7\r"
expect "*(config-if)#"
send "no switchport trunk native vlan 2\r"
expect "*(config-if)#"
send "no switchport forbidden default-vlan\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

send "int Fa 11\r"
expect "*(config-if)#"
send "no switchport trunk native vlan 2\r"
expect "*(config-if)#"
send "no switchport forbidden default-vlan\r"
expect "*(config-if)#"
send "exit\r"
expect "*(config)#"

# exit from config terminal and save the configuration
send "exit\r"
expect "*#"
send "copy run start\r"
expect "*"
send "Y\r"
expect "*#"

# Logout
send "exit\r"
sleep 1

# end your session
send_log "\r### /END-SSH-SESSION/ IP: $IPaddress @ [exec date] ###\r"

# exit process
exit