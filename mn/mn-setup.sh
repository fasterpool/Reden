#!/bin/bash
clear

STRING1="Make sure you double check before hitting enter! Only one shot at these!"
STRING2="If you found this helpful, please donate to EDEN Donation: "
STRING3="EbShbYatMRezVTWJK9AouFWzczkTz5zvYQ"
STRING4="Updating system and installing required packages..."
STRING5="Switching to Aptitude"
STRING6="Some optional installs"
STRING7="Starting your masternode"
STRING8="Now, you need to finally start your masternode in the following order:"
STRING9="Go to your windows wallet and from the Control wallet debug console please enter"
STRING10="masternode start-alias <mymnalias>"
STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
STRING12="once completed please return to VPS and press the space bar"
STRING13=""
STRING14="Please Wait a minimum of 5 minutes before proceeding, the node wallet must be synced"

echo "Make sure you double check before hitting enter! Only one shot at these!"

read -e -p "Server IP Address : " ip
read -e -p "Masternode Private Key (e.g. 7rVTLnLh9GFFrwFrudxMNcikVbf3uQTwH7PrqhTxdWzUfGtdC9f # THE KEY YOU GENERATED EARLIER) : " key

clear
"Updating system and installing required packages..."
sleep 5

# update packages and upgrade Ubuntu
cd ~
sudo apt-get update && apt-get upgrade && apt-get autoremove-y

sudo apt-get -y install wget nano htop git

###################################################
sudo apt-get -y install libzmq3-dev
#sudo apt-get -y install libboost-all-dev
sudo apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev

sudo apt-get -y install libminiupnpc-dev
sudo apt-get -y install libevent-dev
#sudo apt -y install software-properties-common
#######################################

sudo apt-get -y install fail2ban
sudo service fail2ban restart

sudo apt-get install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 13058/tcp
sudo ufw --force enable

#Generating Random Passwords
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
password2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#Install Daemon

wget https://github.com/fasterpool/Reden/tree/1.0/releases

#wget https://github.com/NicholasAdmin/EDEN/releases/download/Linux/eden-ubu1604.tar.gz

#sudo tar -xzvf eden-ubu1604.tar.gz --directory /usr/bin

#sudo rm eden-ubu1604.tar.gz
sudo cp -v ~/EDEN-MN-SETUP/Eden-v1.0.0.1-ubuntu16/edend /usr/bin/
sudo cp -v ~/EDEN-MN-SETUP/Eden-v1.0.0.1-ubuntu16/eden-cli /usr/bin/
sudo chmod 775 /usr/bin/redend
sudo chmod 775 /usr/bin/reden-cli

cd ~

#Starting daemon first time
redend -daemon
echo "sleep for 10 seconds..."
sleep 10

reden-cli stop

#Create eden.conf
echo '
rpcuser=jkGFVjktfv
rpcpassword=liuBH876fjh
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=32

externalip=45.63.37.5

masternode=1
masternodeprivkey=28U5zqqnEgGXae9QPvFs6nU6o8Yij8pTUUcUZVZuCP7SqHCsqfp

addnode=45.76.127.252
addnode=35.178.15.243
' | sudo -E tee ~/.redencore/reden.conf >/dev/null 2>&1

#sudo chmod 0600 ~/.redencore/reden.conf

#Starting daemon second time
redend

tail -f ~/.redencore/debug.log

echo "sleep for 30 seconds..."
sleep 30

#Stop Daemon
eden-cli stop

echo "sleep for 30 seconds..."
sleep 30

#Setting up coin
echo "Setting up coin..."
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10


#Starting coin
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 30 && edend'
) | crontab
(
  crontab -l 2>/dev/null
  echo '* * * * * eden-cli sentinelping 1.1.0'
) | crontab

echo "Coin setup complete."

cd ~

#Start Daemon with newly created conf file (daemon=1)
edend

echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
sleep 10
echo $STRING7
echo $STRING13
echo $STRING8
echo $STRING13
echo $STRING9
echo $STRING13
echo $STRING10
echo $STRING13
echo $STRING11
echo $STRING13
echo $STRING12
echo $STRING14
sleep 5m

read -p "Press any key to continue... " -n1 -s
eden-cli masternode start
eden-cli masternode status
