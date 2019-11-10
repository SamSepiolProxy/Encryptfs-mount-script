#!/bin/bash
echo "Passphrase:"; read -s password 
echo "passphrase_passwd=${password}" > /tmp/pass.txt

printf "%s" "${password}" | ecryptfs-add-passphrase - > tmp.txt

#Now get the signature from the output of the above command
sig=`tail -1 tmp.txt | awk '{print $6}' | sed 's/\[//g' | sed 's/\]//g'`
echo $sig

#remove tmp file
rm -f tmp.txt

#Now perform the mount
sudo mount -t ecryptfs -o key=passphrase:passphrase_passwd_file=/tmp/pass.txt,no_sig_cache,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_enable_filename=y,ecryptfs_passthrough=n,ecryptfs_enable_filename_crypto=y,ecryptfs_fnek_sig=${sig},ecryptfs_sig=${sig},ecryptfs_unlink_sigs /directory-file /directory-file
#remove pass file
rm -rf /tmp/pass.txt

