#!/bin/bash

if [ ! -d "/tmp/check" ]; then

mkdir /tmp/check
echo `date` > /tmp/check/first_`date +%Y%m%d_%H%M%S`

/opt/perforce/sbin/configure-helix-p4d.sh $P4NAME -n -p $P4PORT -r $P4ROOT -u $P4USER -P $P4PASSWD --case $CASE_INSENSITIVE --unicode

cat > ~perforce/.p4config <<EOF
P4USER=$P4USER
P4PORT=$P4PORT
P4PASSWD=$P4PASSWD
EOF

chmod 0600 ~perforce/.p4config
chown perforce:perforce ~perforce/.p4config

p4 login <<EOF
$P4PASSWD
EOF

pushd /opt/perforce/servers/master
rm -Rf db.*
rm -Rf journal
popd

cp /usr/local/bin/backup.ckp.1.gz /opt/perforce/servers/master/root/backup.ckp.1.gz
pushd /opt/perforce/servers/master/root/
rm -Rf db.*
p4d -r /opt/perforce/servers/master/root/ -z -jr /opt/perforce/servers/master/root/backup.ckp.1.gz
chown -R perforce:perforce /opt/perforce/servers/master/root
popd

yes ${P4PASSWD} | p4 -p ${P4PORT} -u super login
pushd /usr/local/bin/
p4 triggers -o > triggers.txt
echo '   CheckCaseTrigger change-submit //... "python3 /usr/local/bin/CheckCaseTrigger3.py %changelist% port=ssl:1666 user=super"' >> triggers.txt
p4 triggers -i < triggers.txt
popd

else
  echo `date` > /tmp/check/second_`date +%Y%m%d_%H%M%S`

fi

exec "$@"
