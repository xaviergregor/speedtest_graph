# Installation Apache2

sudo apt install apache2

# Creation repertoire

sudo mkdir /var/www/html/rrd

# Droit sur le repertoire

sudo chown $USER:$USER /var/www/html/rrd

# Premier lancement

./speedtest_rrd.sh create && ./speedtest_rrd.sh update && ./speedtest_rrd.sh graph

# Integration au cron 15 minutes

*/15 * * * *  /home/$USER/speedtest_rrd.sh update > /dev/null 2>&1 && /home/$USER/speedtest_rrd.sh graph > /dev/null 2>&1


