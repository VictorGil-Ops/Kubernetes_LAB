# vars
ANS_USR='ansible'
PUB_KEY='<PASTE PUBLIC-KEY>'

# Create local ansible user (need passwd)
echo "Creating ansible user"
useradd -p $(openssl rand -base64 14) -b /home/ -m $ANS_USR

# Activate wheel group
echo "Activate wheel group"
sed -i.orig 's/# %wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/g' /etc/sudoers

# Authorize public key
echo "Authorize public key"
mkdir /home/$ANS_USR/.ssh
chmod 700 /home/$ANS_USR/.ssh
echo $PUB_KEY > /home/$ANS_USR/.ssh/authorized_keys
chmod 600 /home/$ANS_USR/.ssh/authorized_keys
chown -R $ANS_USR:$ANS_USR /home/$ANS_USR/.ssh
chmod 400 $ANS_USR:$ANS_USR/.ssh/id_rsa

# add to visudo
echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
visudo -cf /etc/sudoers
