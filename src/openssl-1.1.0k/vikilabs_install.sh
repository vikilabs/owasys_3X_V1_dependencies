PATH=$PATH:/opt/crosstool/arm-none-linux-gnueabi/bin
export PATH

#Relink Compilation Parameters for ARM

unlink /usr/bin/gcc
unlink /usr/bin/as
unlink /usr/bin/ar
unlink /usr/bin/g++
unlink /usr/bin/nm
unlink /usr/bin/ld
unlink /usr/bin/ranlib

if [ $? -eq 0 ]; then
    echo "[ success ] unlink "
else
    echo "[ failure ] unlink "
    exit 1
fi



ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-gcc     /usr/bin/gcc
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-as      /usr/bin/as
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-ar      /usr/bin/ar
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-g++     /usr/bin/g++      
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-nm      /usr/bin/nm
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-ld      /usr/bin/ld
ln -s  /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-ranlib  /usr/bin/ranlib

if [ $? -eq 0 ]; then
    echo "[ success ] softlink "
else
    echo "[ failure ] softlink "
    exit 1
fi


./Configure --prefix=/opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr --openssldir=/opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr/ssl --cross-compile-prefix=arm-none-linux-gnueabi- shared linux-armv4 no-asm threads


if [ $? -eq 0 ]; then
    echo "[ success ] Configuration"
else
    echo "[ failure ] Configuration"
    exit 1
fi


make depend

if [ $? -eq 0 ]; then
    echo "[ success ] make depend"
else
    echo "[ failure ] make depend"
    exit 1
fi



make -j 4

if [ $? -eq 0 ]; then
    echo "[ success ] make"
else
    echo "[ failure ] make"
    exit 1
fi


sudo env "PATH=$PATH" make install

if [ $? -eq 0 ]; then
    echo "[ success ] make install"
else
    echo "[ failure ] make install"
    exit 1
fi

make clean

if [ $? -eq 0 ]; then
    echo "[ success ] Make Clean"
else
    echo "[ failure ] Make Clean"
    exit 1
fi



#Relink Compilation Parameter for Intel
unlink /usr/bin/gcc
unlink /usr/bin/as
unlink /usr/bin/ar
unlink /usr/bin/g++
unlink /usr/bin/nm
unlink /usr/bin/ld
unlink /usr/bin/ranlib

if [ $? -eq 0 ]; then
    echo "[ success ] unlink "
else
    echo "[ failure ] unlink "
    exit 1
fi



ln -s /usr/bin/gcc-5                      /usr/bin/gcc
ln -s /usr/bin/x86_64-linux-gnu-as        /usr/bin/as
ln -s /usr/bin/x86_64-linux-gnu-ar        /usr/bin/ar
ln -s /usr/bin/g++-5                      /usr/bin/g++      
ln -s /usr/bin/x86_64-linux-gnu-nm        /usr/bin/nm
ln -s /usr/bin/x86_64-linux-gnu-ld        /usr/bin/ld
ln -s /usr/bin/x86_64-linux-gnu-ranlib    /usr/bin/ranlib

if [ $? -eq 0 ]; then
    echo "[ success ] softlink "
else
    echo "[ failure ] softlink "
    exit 1
fi

echo "[ Checking Library ] libssl.so"

ls /opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr/lib/libssl.so

if [ $? -eq 0 ]; then
    echo "[ success ] libssl.so exist"
    echo "[ success ] OpenSSL installed successfully"
else
    echo "[ failure ] libssl.so  doesn't exist"
    echo "[ failure ] OpenSSL installation failed"
    exit 1
fi

mkdir ../../stripped_lib_new
mkdir ../../unstripped_lib_new

cp /opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr/lib/libssl.so* ../../unstripped_lib_new/

cp ../../unstripped_lib_new/libssl.so* ../../stripped_lib_new/

cd ../../stripped_lib_new/
arm-none-linux-gnueabi-strip libssl.so.1.1

if [ $? -eq 0 ]; then
    echo "[ success ] libssl stripped successfully"
else
    echo "[ failure ] unable to strip  libssl"
    exit 1
fi

ls -l libssl.so*
ls -l ../unstripped_lib_new/libssl.so*

