#!/bin/bash
# generate a speedtest result

/usr/bin/speedtest -s 29545 -p no > /tmp/speedtest.txt 2>/dev/null

TRAF=/var/www/html/rrd


case $1 in (create)
                /usr/bin/rrdtool create $TRAF/upload.rrd -s 60 \
                DS:upload:GAUGE:1000:0:U \
                RRA:AVERAGE:0.5:1:4320 \
                RRA:AVERAGE:0.5:1440:3 \
                RRA:MIN:0.5:1440:3 \
                RRA:MAX:0.5:1440:3
                /usr/bin/rrdtool create $TRAF/download.rrd -s 60 \
                DS:download:GAUGE:1000:0:U \
                RRA:AVERAGE:0.5:1:4320 \
                RRA:AVERAGE:0.5:1440:3 \
                RRA:MIN:0.5:1440:3 \
                RRA:MAX:0.5:1440:3
                /usr/bin/rrdtool create $TRAF/echoreply.rrd -s 60 \
                DS:echoreply:GAUGE:1000:0:U \
                RRA:AVERAGE:0.5:1:4320 \
                RRA:AVERAGE:0.5:1440:3 \
                RRA:MIN:0.5:1440:3 \
                RRA:MAX:0.5:1440:3
                ;;
        (update)
                /usr/bin/rrdtool update $TRAF/upload.rrd N:`cat /tmp/speedtest.txt | grep Upload | awk '{print $3}'`
                /usr/bin/rrdtool update $TRAF/download.rrd N:`cat /tmp/speedtest.txt | grep Download | awk '{print $3}'`
                /usr/bin/rrdtool update $TRAF/echoreply.rrd N:`cat /tmp/speedtest.txt | grep Latency | awk '{print $2}'`
                ;;
        (graph)
                /usr/bin/rrdtool graph $TRAF/upload.png \
                --start "-3day" \
                -c "BACK#000000" \
                -c "SHADEA#000000" \
                -c "SHADEB#000000" \
                -c "FONT#DDDDDD" \
                -c "CANVAS#202020" \
                -c "GRID#666666" \
                -c "MGRID#AAAAAA" \
                -c "FRAME#202020" \
                -c "ARROW#FFFFFF" \
                -u 1.1 -l 0 -v "Upload" -w 1100 -h 250 -t "Upload Speed - `/bin/date +%A", "%d" "%B" "%Y`" \
                DEF:upload=$TRAF/upload.rrd:upload:AVERAGE \
                AREA:upload\#FFFF00:"Upload speed (Mbit/s)" \
                GPRINT:upload:MIN:"Min\: %3.2lf " \
                GPRINT:upload:MAX:"Max\: %3.2lf" \
                GPRINT:upload:LAST:"Current\: %3.2lf\j" \
                COMMENT:"\\n"

                /usr/bin/rrdtool graph $TRAF/download.png \
                --start "-3day" \
                -c "BACK#000000" \
                -c "SHADEA#000000" \
                -c "SHADEB#000000" \
                -c "FONT#DDDDDD" \
                -c "CANVAS#202020" \
                -c "GRID#666666" \
                -c "MGRID#AAAAAA" \
                -c "FRAME#202020" \
                -c "ARROW#FFFFFF" \
                -u 1.1 -l 0 -v "Download" -w 1100 -h 250 -t "Download Speed - `/bin/date +%A", "%d" "%B" "%Y`" \
                DEF:download=$TRAF/download.rrd:download:AVERAGE \
                AREA:download\#00FF00:"Download speed (Mbit/s)" \
                GPRINT:download:MIN:"Min\: %3.2lf " \
                GPRINT:download:MAX:"Max\: %3.2lf" \
                GPRINT:download:LAST:"Current\: %3.2lf\j" \
                COMMENT:"\\n"

                /usr/bin/rrdtool graph $TRAF/echoreply.png \
                --start "-3day" \
                -c "BACK#000000" \
                -c "SHADEA#000000" \
                -c "SHADEB#000000" \
                -c "FONT#DDDDDD" \
                -c "CANVAS#202020" \
                -c "GRID#666666" \
                -c "MGRID#AAAAAA" \
                -c "FRAME#202020" \
                -c "ARROW#FFFFFF" \
                -u 1.1 -l 0 -v "Ping" -w 1100 -h 250 -t "Ping Response - `/bin/date +%A", "%d" "%B" "%Y`" \
                DEF:echoreply=$TRAF/echoreply.rrd:echoreply:AVERAGE \
                AREA:echoreply\#FF0000:"Ping Response (ms)" \
                GPRINT:echoreply:MIN:"Min\: %3.2lf " \
                GPRINT:echoreply:MAX:"Max\: %3.2lf" \
                GPRINT:echoreply:LAST:"Current\: %3.2lf\j" \
                COMMENT:"\\n"
                ;;

        (*)
                echo "Invalid option.";;
        esac
