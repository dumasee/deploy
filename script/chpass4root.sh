#!/bin/bash
sudo -S su  << EOF 
000000
whoami
echo "root:Ubuntu123!" | chpasswd && echo "change root password success "
EOF