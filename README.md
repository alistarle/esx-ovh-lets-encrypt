# ESX/OVH Let's encrypt requestor

This container will automatically request a let's encrypt certificate based on
a DNS challenge (using OVH API) and update it in an ESXi host using REST API
and ssh to reload certificate on the host.

You can schedule this container using a cronjob every 30 days in kubernetes by
example.

Note it will require SSH service to be activated in your esxi host for
restarting the hostd service.

## Run the container

    export DOMAIN=<my-esx-domain-name>
    export EMAIL=<my-domain-email>
    export VMWARE_USERNAME=<esxi-ssh-username>
    export VMWARE_PASSWORD=<esxi-ssh-password>

    export OVH_APPLICATION_KEY=<ovh application key>
    export OVH_CONSUMER_KEY=<ovh consumer key>
    export OVH_APPLICATION_SECRET=<ovh application secret>

    docker run -e DOMAIN=$DOMAIN -e EMAIL=$EMAIL -e VMWARE_USERNAME=$VMWARE_USERNAME -e VMWARE_PASSWORD=$VMWARE_PASSWORD -e OVH_APPLICATION_KEY=$OVH_APPLICATION_KEY -e OVH_CONSUMER_KEY=$OVH_CONSUMER_KEY -e OVH_APPLICATION_SECRET=$OVH_APPLICATION_SECRET alistarle/esx-ovh-lets-encrypt

## References:

Let's encrypt DNS OVH blogpost: https://buzut.net/certbot-challenge-dns-ovh-wildcard/
VMware docs to update certificat on ESXi: https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.vsphere.security.doc/GUID-43B7B817-C58F-4C6F-AF3D-9F1D52B116A0.html
