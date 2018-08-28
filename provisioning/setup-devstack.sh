cat <<DEVSTACOF >> devstack/local.conf

[[local|localrc]]
disable_all_services
enable_service g-reg
enable_service key
enable_service n-api
enable_service g-api
enable_service mysql
enable_service tls-proxy
enable_service etcd3
enable_service q-dhcp
enable_service n-api-meta
enable_service tempest
enable_service q-l3
enable_service n-novnc
enable_service peakmem_tracker
enable_service n-cauth
enable_service q-agt
enable_service q-metering
enable_service rabbit
enable_service n-cond
enable_service q-meta
enable_service q-svc
enable_service placement-api
enable_service n-cpu
enable_service n-obj
disable_service horizon
enable_service n-sch
enable_service dstat
ADMIN_PASSWORD=secretadmin
CINDER_PERIODIC_INTERVAL=10
DATABASE_PASSWORD=secretdatabase
DEBUG_LIBVIRT_COREDUMPS=True
ENABLE_FILE_INJECTION=True
FIXED_RANGE=10.1.0.0/20
FLOATING_RANGE=172.24.5.0/24
GIT_BASE="https://git.openstack.org"
# TODO ADD HOST_IP
HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
IPV4_ADDRS_SAFE_TO_USE=10.1.0.0/20
LIBVIRT_TYPE=qemu
LOGFILE=/opt/stack/logs/devstacklog.txt
LOG_COLOR=False
NETWORK_GATEWAY=10.1.0.1
NOVA_VNC_ENABLED=True
NOVNC_FROM_PACKAGE=True
PUBLIC_BRIDGE_MTU=1450
PUBLIC_NETWORK_GATEWAY=172.24.5.1
RABBIT_PASSWORD=secretrabbit
SERVICE_HOST=$HOST_IP
SERVICE_PASSWORD=secretservice
SWIFT_HASH=1234123412341234
SWIFT_REPLICAS=1
SWIFT_START_ALL_SERVICES=False
VERBOSE=True
VERBOSE_NO_TIMESTAMP=True
VNCSERVER_LISTEN=0.0.0.0
VNCSERVER_PROXYCLIENT_ADDRESS=$HOST_IP
LIBS_FROM_GIT=nova,requirements,neutron,tempest,glance,keystone,devstack

[[test-config|$TEMPEST_CONFIG]]
[compute]
min_compute_nodes = 1
[[post-config|$NEUTRON_CONF]]
[DEFAULT]
global_physnet_mtu = 1450

DEVSTACOF

