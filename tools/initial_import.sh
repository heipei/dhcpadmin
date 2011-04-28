sed -e "s/ACCEPT.*eth1\s*/Machine.create :mac => \"/" -e "s/\t\t*# /\", :creator => \"Jojo\", :category => \"Hausbewohner\", :comment => \"/" -e "s/$/\"/" dynamic_wlan_list dynamic_pool_maclist
grep host dhcpd.conf|sed -e "s/host \(.*\)\s\s*{ hardware ethernet \(.*\); fixed-address \(.*\); }/Room.create :dns => \"\1\", :mac => \"\2\", :ip => \"\3\"/"
