Prerequisites
* A domain you can use for openhab-cloud. You'll need access to setup the DNS records to point to the server running the docker.
* A server to run the docker on that has ports 80 and 443 avaialble. Basically, not currently hosting any web content.

Setup
* Setup the DNS for host to point to the server your running docker on. This is required for letsencrypt so do this early.
* Update conf.json and set the correct hostname. Change any other settings you want in there too.
* Modify the run command to include the correct host, certbot email and path to config.json
* Modify the run command to point to a mongodb data dir and a certs directory. Mongodb will save data here so it won't get lost when the container is stopped and it will also store the certificates here so they don't have to be regenerated.

Paths
* /var/lib/mongodb: mongo saves data here
* /etc/letsencrypt/live/openhab: letsencrypt certificates are saved here 
* /openhab-cloud/config.json: path to the openhabcloud config file.

Notes
* If you're using existing directorys for data make sure permissions are right.
* It appears letsencrypt requires an A record not a CNAME record
* If you have existing certs for domain you can copy them to the certs path you defined above and it should work
* nginx default and mongo config files are built into the image. If you want to change these you can either add a new path like the config.json above with run or modify the source and rebuild the image: docker build -t ryanrdetzel/openhabcloud .
* If your instance is not starting up you can replace the -d with -it to leave it open so you can watch the logs.
* Once it's up you'll need to signup like usual. It's a good idea to then turn off registration so others can't use your instance. There is an option for this in the config.json file


docker run \
    -h <HOSTNAME> \
    -e CERTBOT_EMAIL='<YOUR_EMAIL>' \
    -v /var/docker-openhab/config.json:/openhab-cloud/config.json \
    -v /var/docker-openhab/mongo-data:/var/lib/mongodb \
    -v /var/docker-openhab/certs:/etc/letsencrypt/live/openhab \
    -p 80:80 \
    -p 443:443 \
    -d ryanrdetzel/openhabcloud


Example run command:
docker run \
    -h mqtt.dxxd.net \
    -e CERTBOT_EMAIL='myemail@gmail.com' \
    -v /home/ryan/docker-openhab/config.json:/openhab-cloud/config.json \
    -v /home/ryan/openhabcloud/mongo-data:/var/lib/mongodb \
    -v /home/ryan/openhabcloud/certs:/etc/letsencrypt/live/openhab \
    -p 80:80 \
    -p 443:443 \
    -it ryanrdetzel/openhabcloud
