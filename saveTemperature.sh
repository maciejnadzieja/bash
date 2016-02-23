#save temperature data as js script
cd /var/www/html
#use UTC date as a key
date=`date -u`
#get temperature value from file
temp=`cat /sys/bus/w1/devices/28-0000075a2a05/w1_slave | grep "t=" | cut -d = -f 2`
#save value to data.js
echo "temperatures[\""$date"\"]="$temp";" >> data.js
#keep last 7 days of data (saved each 5min)
tail -2016 data.js > data_tmp.js
mv data_tmp.js data.js
