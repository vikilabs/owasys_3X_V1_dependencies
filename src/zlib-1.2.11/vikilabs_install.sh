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



./configure -shared -prefix=/opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr



if [ $? -eq 0 ]; then
    echo "[ success ] Configuration"
else
    echo "[ failure ] Configuration"
    exit 1
fi

make

if [ $? -eq 0 ]; then
    echo "[ success ] Make"
else
    echo "[ failure ] Make"
    exit 1
fi



sudo env "PATH=$PATH" make install

if [ $? -eq 0 ]; then
    echo "[ success ] Make Install"
else
    echo "[ failure ] Make Install"
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

echo "[ Checking Library ] libz.so"

ls /opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr/lib/libz.so

if [ $? -eq 0 ]; then
    echo "[ success ] libz.so exist"
    echo "[ success ] zlib installed successfully"
else
    echo "[ failure ] libz.so  doesn't exist"
    echo "[ failure ] zlib installation failed"
    exit 1
fi

mkdir ../../stripped_libs_new
mkdir ../../unstripped_libs_new

sudo cp -r /opt/crosstool/arm-none-linux-gnueabi/arm-none-linux-gnueabi/libc/usr/lib/libz.so* ../../unstripped_libs_new/

sudo cp -r ../../unstripped_libs_new/libz.so* ../../stripped_libs_new/

cd ../../stripped_libs_new/
sudo /opt/crosstool/arm-none-linux-gnueabi/bin/arm-none-linux-gnueabi-strip libz.so.1.2.11

if [ $? -eq 0 ]; then
    echo "[ success ] libz stripped successfully"
else
    echo "[ failure ] unable to strip  libz"
    exit 1
fi

sudo rm libz.so
sudo rm libz.so.1
sudo ln -s libz.so.1.2.11 libz.so
sudo ln -s libz.so.1.2.11 libz.so.1

ls -l libz.so*
ls -l ../unstripped_libs_new/libz.so*


