proxy=$1
cat << DEVSTACKEOF > .ssh/config
Host review.openstack.org
    ProxyCommand /usr/bin/connect -S $proxy %h %p
DEVSTACKEOF

