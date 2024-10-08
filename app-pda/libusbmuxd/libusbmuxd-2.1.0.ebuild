# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Support library for libimobiledevice projects"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/libusbmuxd/releases/download/2.1.0/libusbmuxd-2.1.0.tar.bz2 -> libusbmuxd-2.1.0.tar.bz2"
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/2.0-6" # based on SONAME of libusbmuxd-2.0.so
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.2.0:=
	>=app-pda/libimobiledevice-glue-1.2.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libimobiledevice-libusbmuxd* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
	cp "${ED}"/usr/lib64/pkgconfig/${PN}-*.pc "${ED}"/usr/lib64/pkgconfig/${PN}.pc
}