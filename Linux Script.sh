#!/bin/bash

sudo rm -r temp.txt
sudo rm -r packagelist.csv
sudo rm -r PackageList.json


echo "Active Internet Connection Required"



echo "Installing NPM jq"
echo "sudo apt-get install npm jq -y" > requirement.sh
echo "sudo npm install -g csvtojson" >> requirement.sh
echo "sudo apt-get install mutt -y" >> requirement.sh
echo "sudo apt-get install sendemail >> requirement.sh

sudo bash requirement.sh

echo "Getting List of Installed Packages..."

grep "status installed" /var/log/dpkg.log.1 >> temp.txt
grep "status installed" /var/log/dpkg.log >> temp.txt

LOG="temp.txt"

echo "Date,Time,Status,Package Name,Package Version"> packagelist.csv

< $LOG awk '{print $1"," $2 "," $3" "$4 "," $5"," $6}' >> packagelist.csv

csvtojson packagelist.csv > PackageList.json

sudo rm -r temp.txt
sudo rm -r packagelist.csv
sudo rm -r requirement.sh

#SEND FILE TO EMAIL

sendemail -f grazettitest@outlook.com -t adminemail@email.com -u "Packages list of $(hostname)" -m "Check Attachment" -s smtp.office365.com:587 -a ./PackageList.json -xu yourmail@outlook.com -xp "password"

echo "Please Check Your Email (yogeshc@grazitti.com) Inbox/Spam Folder"

#DELETEJSON FILE
#sudo rm -r PackageList.json
