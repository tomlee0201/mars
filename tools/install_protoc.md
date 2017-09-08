## Run follow command by sequence:
To build protobuf from source, the following tools are needed:


On Ubuntu, you can install them with:
$ sudo apt-get install autoconf automake libtool curl make g++ unzip

On Mac, you can install them with:
$ sudo apt-get install autoconf automake


Then run the cmd.
$ ./autogen.sh
$ ./configure
$ make
$ make check
$ sudo make install
$ sudo ldconfig # refresh shared library cache.
