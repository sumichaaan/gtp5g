ifndef KVERSION
KVERSION=$(shell uname -r)
endif

ifndef GTP5GVER
KMODVER=$(shell git describe HEAD 2>/dev/null || git rev-parse --short HEAD)
endif

CONFIG_MODULE_SIG=n
MODULE_NAME = gtp5g
obj-m := $(MODULE_NAME).o

buildprep:
	sudo yum install -y gcc kernel-{core,devel,modules}-$(KVERSION) elfutils-libelf-devel

all:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) EXTRA_CFLAGS=-DKMODVER=\\\"$(KMODVER)\\\" modules

clean:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

install:
	sudo modprobe udp_tunnel
	sudo install -v -m 755 -d /lib/modules/$(KVERSION)/
	sudo install -v -m 644 gtp5g.ko /lib/modules/$(KVERSION)/gtp5g.ko
	depmod -a
