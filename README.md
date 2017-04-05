Prerequisites
* A domain you can use for openhab-cloud. You'll need access to setup the DNS records to point to the server running docker.
* A server to run the docker on that has ports 80 and 443 avaialble. Basically, not currently hosting any web content.

Setup
1. Setup the DNS for host to point to the server your running docker on. This is required for letsencrypt so do this early as DNS takes time to propagate
2. Make a new directory to hold config.json, mongodb and your certificates
3. Copy the basic config.json and set the correct hostname along with any other settings you want to add/change.
4. Modify the run command below to include the correct host, certbot email and paths
    * /var/lib/mongodb: mongo saves data here
    * /etc/letsencrypt/live/openhab: letsencrypt certificates are saved here 
    * /openhab-cloud/config.json: path to the openhabcloud config file.
5. Run the container and wait. It takes a few minutes. You can keep trying your domain to see if it's up, if it's not up in 10 minutes read the notes.

Notes
* If you're using existing directories for data make sure the permissions are right.
* It appears letsencrypt requires an A record not a CNAME record
* If you have existing certs for domain you can copy them to the certs path you defined above and it should work (permissions)
* nginx default and mongo config files are built into the image. If you want to change these you can either add a new path like the config.json above with run or modify the source and rebuild the image
* If your instance is not starting up you can replace the -d with -it to watch stdout and debug
* Once it's up you'll need to signup like usual. It's a good idea to then turn off registration so others can't use your instance. There is an option for this in the config.json file

Basic Run Command. Change HOSTNAME, YOUR_EMAIL and the three paths
docker run \
    -h <HOSTNAME> \
    -e CERTBOT_EMAIL='<YOUR_EMAIL>' \
    -v /var/docker-openhab/config.json:/openhab-cloud/config.json \
    -v /var/docker-openhab/mongo-data:/var/lib/mongodb \
    -v /var/docker-openhab/certs:/etc/letsencrypt/live/openhab \
    -p 80:80 \
    -p 443:443 \
    -d ryanrdetzel/docker-openhabcloud


Example run command:
docker run \
    -h mqtt.dxxd.net \
    -e CERTBOT_EMAIL='myemail@gmail.com' \
    -v /home/ryan/openhabcloud/config.json:/openhab-cloud/config.json \
    -v /home/ryan/openhabcloud/mongo-data:/var/lib/mongodb \
    -v /home/ryan/openhabcloud/certs:/etc/letsencrypt/live/openhab \
    -p 80:80 \
    -p 443:443 \
    -d ryanrdetzel/docker-openhabcloud
