# Set required variables

# Onion routing port
OR_PORT=${OR_PORT}

# obfs4 port
PT_PORT=${PT_PORT}

EMAIL=${EMAIL}

# If you want, you could change the nickname of your bridge
#NICKNAME=DockerObfs4Bridge

# If needed, activate additional variables processing
# and define desired torrc entries prefixed with OBFS4V_
OBFS4_ENABLE_ADDITIONAL_VARIABLES=1

# TODO consider adding ipv6
# https://docs.docker.com/config/daemon/ipv6/
OBFS4V_AddressDisableIPv6=1
