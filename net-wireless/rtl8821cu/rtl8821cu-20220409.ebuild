# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="Realtek RTL8811CU/RTL8821CU USB wifi adapter driver"
HOMEPAGE="https://github.com/brektrou/rtl8821CU"
SRC_URI="https://github.com/brektrou/rtl8821CU/archive/8c2226a74ae718439d56248bd2e44ccf717086d5.tar.gz -> rtl8821cu-20220409.tar.gz"

LICENSE="GPL-2"
KEYWORDS="*"

DEPEND="virtual/linux-sources"

MODULE_NAMES="8821cu(net/wireless)"
BUILD_TARGETS="all"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/rtl8821CU-* "${S}"
}

src_prepare() {
	default

	# FL-8716: Use the latest kernel instead of the currently running one.
	get_version

	sed -i \
		-e "s|\$(shell uname -r)|${KV_FULL}|g" \
		Makefile
}