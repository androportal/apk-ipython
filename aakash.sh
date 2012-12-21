#!/system/bin/sh

export bin=/system/bin
export PATH=$bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:$PATH
export TERM=linux
export HOME=/root

### aakash programming lab
export MNT=/data/local/linux
export EG=/data/example
export SDCARD=/mnt/sdcard/APL
export WWW=/data/local/linux/var/www/html

### gkaakash 
export MNTG=/data/local/gkaakash

### ipython
export MNTI=/data/local/ipy

APL=1
GK=1
IPY=1

function startServicesAPL
    {
        # mounting essential file systems to chroot
        busybox mount -t proc proc $MNT/proc
        busybox mount -o bind /dev $MNT/dev
        busybox mount -t sysfs sysfs $MNT/sys
        busybox  chroot  $MNT /bin/bash -c "mount /dev/pts" 
        busybox  chroot  $MNT /bin/bash -c "chown -R www-data.www-data /var/www/"
        busybox  chroot  $MNT /bin/bash -c "chmod -R a+x /usr/lib/cgi-bin"

        # cleaning and starting apache 
        busybox  chroot  $MNT /bin/bash -c "rm /dev/null"
        busybox  chroot  $MNT /bin/bash -c "rm /var/run/apache2/*"
        busybox  chroot  $MNT /bin/bash -c "rm /var/run/apache2.pid"
        busybox  chroot  $MNT /bin/bash -c "service apache2 stop"
        busybox  chroot  $MNT /bin/bash -c "service apache2 start"

        busybox  chroot  $MNT /bin/bash -c "chmod 777 /var/www/html/c/exbind/.open_file.c"
        busybox  chroot  $MNT /bin/bash -c "chmod 777 /var/www/html/cpp/exbind/.open_file.cpp"
        busybox  chroot  $MNT /bin/bash -c "chmod 777 /var/www/html/python/exbind/.open_file.py"
        busybox  chroot  $MNT /bin/bash -c "chmod 777 /var/www/html/scilab/exbind/.open_file.cde"
        
        # running shellinaboxd, sb_manage and Xvfb
        busybox  chroot  $MNT /bin/bash -c "shellinaboxd --localhost-only -t -s /:www-data:www-data:/:true &"
        busybox  chroot  $MNT /bin/bash -c "rm /tmp/.X0-*" 
        busybox  chroot  $MNT /bin/bash -c "nohup Xvfb :0 -screen 0 640x480x24 -ac < /dev/null > Xvfb.out 2> Xvfb.err &"

        	
        if [ ! -d ${SDCARD} ] || [ ! -d ${WWW} ] || [ ! -d ${EG} ]
        then                                                                  
	    busybox mkdir -p ${SDCARD}/c/code                                         
            busybox mkdir -p ${WWW}/c/code                                            
            busybox mkdir -p ${EG}/c
	    
            busybox mkdir -p ${SDCARD}/cpp/code                                       
            busybox mkdir -p ${WWW}/cpp/code                                          
            busybox mkdir -p ${EG}/cpp
	    
            busybox mkdir -p ${SDCARD}/python/code                                     
            busybox mkdir -p ${WWW}/python/code     
            busybox mkdir -p ${EG}/python
	    
            busybox mkdir -p ${SDCARD}/scilab/code
            busybox mkdir -p ${WWW}/scilab/code   
            busybox mkdir -p ${EG}/scilab

            busybox mkdir -p ${SDCARD}/scilab/image
            busybox mkdir -p ${WWW}/scilab/image   
        fi
        
            
        busybox  chroot  /data/local/linux /bin/bash -c "nohup python /root/sb_manage.py &>'/dev/null'&"
	
        busybox mount -o bind ${SDCARD}/c/code ${WWW}/c/code
        busybox mount -o bind ${SDCARD}/cpp/code ${WWW}/cpp/code
        busybox mount -o bind ${SDCARD}/python/code ${WWW}/python/code
        busybox mount -o bind ${SDCARD}/scilab/code ${WWW}/scilab/code
        busybox mount -o bind ${SDCARD}/scilab/image ${WWW}/scilab/image
	
    	busybox mount -o bind ${EG}/c ${WWW}/c/exbind
        busybox mount -o bind ${EG}/cpp ${WWW}/cpp/exbind
        busybox mount -o bind ${EG}/python ${WWW}/python/exbind
        busybox mount -o bind ${EG}/scilab ${WWW}/scilab/exbind
	
    }

####################################################################################################
####################################################################################################

while true
  do
    if [ $(mount | busybox grep /mnt/sdcard |busybox wc -l) -eq 2 ]
    then    
        busybox mkdir -p $MNT $MNTG $MNTI
    
        if [ -f /mnt/sdcard/apl.img ] && [ $APL -eq 1 ]
        then
            busybox mount -o loop /mnt/sdcard/apl.img /data/local/linux
            startServicesAPL
            APL=0
	
        elif [ -f /mnt/extsd/apl.img ] && [ $APL -eq 1 ]
        then
            busybox mount -o loop /mnt/extsd/apl.img /data/local/linux 
            startServicesAPL
            APL=0
        fi 
        
	##############################################################

        if [ -f /mnt/sdcard/gkaakash.img ] && [ $GK -eq 1 ]
        then
            # mounting essential file systems to chroot for gkaakash
        	busybox mount -o loop /mnt/sdcard/gkaakash.img $MNTG
            busybox mount -t proc proc $MNTG/proc
            busybox mount -o bind /dev $MNTG/dev
            busybox mount -t sysfs sysfs $MNTG/sys
            busybox chroot  $MNTG /bin/bash -c "mount /dev/pts" 
            busybox chroot $MNTG /bin/bash -c "source /root/.bashrc"
        	#busybox chroot /data/local/gkaakash /bin/bash -c "python /root/gkAakashCore/gkstart &> '/dev/null' &"
        	busybox chroot ${MNTG} /bin/bash -c "/root/gkAakashCore/gkstart"
            GK=0
	
            elif [ -f /mnt/extsd/gkaakash.img ] && [ $GK -eq 1 ]
            then
            # mounting essential file systems to chroot for gkaakash
        	busybox mount -o loop /mnt/extsd/gkaakash.img $MNTG
            busybox mount -t proc proc $MNTG/proc
            busybox mount -o bind /dev $MNTG/dev
            busybox mount -t sysfs sysfs $MNTG/sys
            busybox chroot  $MNTG /bin/bash -c "mount /dev/pts" 
            busybox chroot $MNTG /bin/bash -c "source /root/.bashrc"
	        #busybox chroot /data/local/gkaakash /bin/bash -c "python /root/gkAakashCore/gkstart &> '/dev/null' &"
        	busybox chroot ${MNTG} /bin/bash -c "/root/gkAakashCore/gkstart"
            GK=0
        fi
        
	###############################################################

        if [ -f /mnt/sdcard/ipy.img ] && [ $IPY -eq 1 ]
        then
        	busybox mount -o loop /mnt/sdcard/ipy.img $MNTI
            busybox mount -t proc proc $MNTI/proc
            busybox mount -o bind /dev $MNTI/dev
            busybox mount -t sysfs sysfs $MNTI/sys
            busybox chroot $MNTI /bin/bash -c "mount /dev/pts" 
    	    busybox chroot $MNTI /bin/bash -c "ipython notebook --pylab=inline &"
            IPY=0
    
        elif [ -f /mnt/extsd/ipy.img ] && [ $IPY -eq 1 ]
        then
    	    busybox mount -o loop /mnt/extsd/ipy.img $MNTI
            busybox mount -t proc proc $MNTI/proc
            busybox mount -o bind /dev $MNTI/dev
            busybox mount -t sysfs sysfs $MNTI/sys
            busybox chroot $MNTI /bin/bash -c "mount /dev/pts" 
            busybox chroot $MNTI /bin/bash -c "ipython notebook --pylab=inline &"
            IPY=0
        fi
        exit 0
    fi
    sleep 1 
done
