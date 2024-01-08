#!/bin/bash

VRFY_USER=$(grep -c "${SMB_USER}" /etc/passwd)
VRFY_GROUP=$(grep -c "${SMB_GROUP}" /etc/group)

# add username for samba

if [ ${VRFY_USER} -ne 0 ];
then
echo "user ${SMB_USER} already exist"
else
echo "adding user ${SMB_USER}"
useradd ${SMB_USER} -s /bin/nologin
echo -ne "${SMB_PASS}\n${SMB_PASS}\n" | smbpasswd -a -s ${SMB_USER}
fi

# add group

if [ ${VRFY_GROUP} -ne 0 ];
then
echo "user ${SMB_USER} already exist"
else
groupadd ${SMB_GROUP}
gpasswd -a ${SMB_USER} ${SMB_GROUP}
fi

# set user and group on smb.conf

sed -i "s|valid users = @samba|valid users = @${SMB_GROUP}|g" /etc/samba/smb.conf
sed -i "s|write list = @samba|write list = @${SMB_GROUP}|g" /etc/samba/smb.conf
sed -i "s|force group = samba|force group = ${SMB_GROUP}|g" /etc/samba/smb.conf

# set directory permissions

chown root.${SMB_GROUP} -R /share
chmod 2770 /share

unset SMB_USER
unset SMB_PASS
unset SMB_GROUP

# start samba
smbd --foreground --debug-stdout
