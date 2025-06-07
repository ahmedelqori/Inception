#! /bin/sh

adduser -D -h /ftp ${FTP_USER}
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

sed -i "s|anonymous_enable=YES|anonymous_enable=NO|g" /etc/vsftpd/vsftpd.conf
sed -i "s|#local_enable=YES|local_enable=YES|g" /etc/vsftpd/vsftpd.conf
sed -i "s|#chroot_local_user=YES|chroot_local_user=YES|g" /etc/vsftpd/vsftpd.conf

echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=21100" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=21110" >> /etc/vsftpd/vsftpd.conf
echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf
echo "pasv_address=127.0.0.1" >> /etc/vsftpd/vsftpd.conf

chmod 777 /ftp

echo "Starting FTP server ..."
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf