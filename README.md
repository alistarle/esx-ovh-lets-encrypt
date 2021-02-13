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

## Run the container as a kubernetes cronjob

1. Define some secrets in your kubernetes cluster:

        kubectl create secret generic vmware-credentials --from-literal=username=<esxi-username> --from-literal=password=<esxi-password>
        kubectl create secret generic ovh-credentials --from-literal=application_key=<ovh_application_key> --from-literal=consumer_key=<ovh_consumer_key> --from-literal=application_secret=<ovh_application_secret>

2. Replace in the file cronjob.yml your esxi domain and email:

        ...
        - name: DOMAIN
            value: "your_esxi_fqdn"
        - name: EMAIL
            value: "your_domain_email_address"
        ...

3. Schedule your kubernetes cronjob, he will run the first day of each month at 00:00:

        kubectl apply -f cronjob.yml

4. (Optionnal) Run manually the cronjob, create a job from it:

        kubectl create job --from=cronjob/esx-ovh-lets-encrypt esx-ovh-lets-encrypt-manual-run 

## References:

Let's encrypt DNS OVH blogpost: https://buzut.net/certbot-challenge-dns-ovh-wildcard/
VMware docs to update certificat on ESXi: https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.vsphere.security.doc/GUID-43B7B817-C58F-4C6F-AF3D-9F1D52B116A0.html
