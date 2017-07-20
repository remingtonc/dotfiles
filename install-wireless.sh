sudo apt install build-essential dkms wpasupplicant
git clone https://github.com/sbosshardt/rtl8814AU
cd rtl8814AU
sudo ./dkms-install.sh
echo 8814au | sudo tee -a /etc/modules
sudo cp wl* /etc/network/interfaces.d/
wpa_passphrase 5G\ is\ for\ the\ Boys | sudo tee /etc/wpa_supplicant/wpa_supplicant.conf
wpa_passphrase Prestige\ Worldwide | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
sudo systemctl restart networking
./start_wireless.sh
