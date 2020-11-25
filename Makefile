ifndef KVER
KVER=$(shell uname -r)
endif

ifndef KMODVER
KMODVER=$(shell git describe HEAD 2>/dev/null || git rev-parse --short HEAD)
endif

CONFIG_MODULE_SIG=n
MODULE_NAME = gtp5g
obj-m := $(MODULE_NAME).o

buildprep:
	sudo yum install -y gcc kernel-{core,devel,modules}-$(KVER) elfutils-libelf-devel

all:
	make -C /lib/modules/$(KVER)/build M=$(PWD) EXTRA_CFLAGS=-DKMODVER=\\\"$(KMODVER)\\\" modules

clean:
	make -C /lib/modules/$(KVER)/build M=$(PWD) clean

install:
	sudo install -v -m 755 -d /lib/modules/$(KVER)/
	sudo install -v -m 644 gtp5g.ko /lib/modules/$(KVER)/gtp5g.ko
	sudo depmod -a
