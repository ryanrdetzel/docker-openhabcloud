FILE='/etc/letsencrypt/live/openhab/fullchain.pem'
if [ -f $FILE ]; then
    echo "Cert already exists, using it"
else
    echo "Cert does not exist, generate it"
    /etc/init.d/nginx stop
    curl https://dl.eff.org/certbot-auto --output certbot-auto
    chmod a+x ./certbot-auto
    ./certbot-auto certonly -n --agree-tos --standalone -d $HOSTNAME --text --email $CERTBOT_EMAIL

    cp /etc/letsencrypt/live/$HOSTNAME/* /etc/letsencrypt/live/openhab/
    chmod 777 /var/lib/mongodb
fi

/etc/init.d/mongodb restart
/etc/init.d/redis-server start
/etc/init.d/nginx restart

echo "Waiting for services to start..."
sleep 10
node app.js
