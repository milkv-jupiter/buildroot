################################################################################
#
# toolchain-external-linaro-aarch64
#
################################################################################

TOOLCHAIN_EXTERNAL_JDSK_RISCV64_VERSION = v0.1.5-20230324T022642
TOOLCHAIN_EXTERNAL_JDSK_RISCV64_SITE = http://lnode1.dc.com:20000/software/toolchain

ifeq ($(HOSTARCH),x86)
TOOLCHAIN_EXTERNAL_JDSK_RISCV64_SOURCE = spacemit-gcc-linux-glibc-x86_64-jdsk-$(TOOLCHAIN_EXTERNAL_JDSK_RISCV64_VERSION).tar.gz
else
TOOLCHAIN_EXTERNAL_JDSK_RISCV64_SOURCE = spacemit-gcc-linux-glibc-x86_64-jdsk-$(TOOLCHAIN_EXTERNAL_JDSK_RISCV64_VERSION).tar.gz
endif

$(eval $(toolchain-external-package))
