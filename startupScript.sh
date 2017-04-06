/etc/init.d/mongodb restart
/etc/init.d/redis-server start
/etc/init.d/nginx restart

echo "Waiting for services to start..."
sleep 10
node app.js
