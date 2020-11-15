#!/bin/bash
set -e

# Prepare ovh credentials
cat > ./ovh.ini << EOL
dns_ovh_endpoint = ovh-eu
dns_ovh_application_key = $OVH_APPLICATION_KEY
dns_ovh_application_secret = $OVH_APPLICATION_SECRET
dns_ovh_consumer_key = $OVH_CONSUMER_KEY
EOL

# Request let's encrypt certificate with DNS challange
/usr/local/bin/certbot certonly --dns-ovh --dns-ovh-credentials ./ovh.ini --non-interactive --agree-tos --email ${EMAIL} -d ${DOMAIN}

# Update ESXi SSL Cert with the newly generated one
curl -X PUT --data-binary "@/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" https://${DOMAIN}/host/ssl_cert -u ${VMWARE_USERNAME}:${VMWARE_PASSWORD}
curl -X PUT --data-binary "@/etc/letsencrypt/live/${DOMAIN}/privkey.pem" https://${DOMAIN}/host/ssl_key -u ${VMWARE_USERNAME}:${VMWARE_PASSWORD}

# Restart hostd service on the ESXi host to apply the new certificate
export SSHPASS=${VMWARE_PASSWORD}
sshpass -e ssh -o StrictHostKeyChecking=no ${VMWARE_USERNAME}@${DOMAIN} "/etc/init.d/hostd restart"
