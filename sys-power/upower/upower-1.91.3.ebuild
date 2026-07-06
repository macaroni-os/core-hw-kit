# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-any-r1 systemd udev xdg-utils

DESCRIPTION="D-Bus abstraction for enumerating power devices, querying history and statistics"
HOMEPAGE="https://upower.freedesktop.org/"
SRC_URI="https://gitlab.freedesktop.org/upower/upower/-/archive/v1.91.3/upower-1.91.3.tar.bz2 -> upower-1.91.3.tar.bz2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gtk-doc +introspection policykit"
BDEPEND="app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gdbus-codegen
	sys-devel/gettext
	gtk-doc? ( dev-util/gtk-doc )
	
"
RDEPEND="dev-libs/glib:2
	sys-apps/dbus:=
	introspection? ( dev-libs/gobject-introspection:= )
	policykit? ( sys-auth/polkit )
	dev-libs/libgudev:=
	virtual/udev
	
"
DEPEND="${RDEPEND}
"
post_src_unpack() {
	mv upower-v* "${S}"
}
src_prepare() {
	default
	xdg_environment_reset
	# https://bugs.gentoo.org/935575
	unset XDG_CONFIG_DIRS XDG_DATA_DIRS
}
src_configure() {
	local backend=linux
	local emesonargs=(
	  --localstatedir "${EPREFIX}"/var
	  -Dman=true
	  -Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
	  -Dos_backend="${backend}"
	  -Didevice=disabled
	  $(meson_use gtk-doc)
	  $(meson_feature introspection)
	  $(meson_feature policykit polkit)
	)
	meson_src_configure
}
src_install() {
	  meson_src_install
	  keepdir /var/lib/upower #383091
}
pkg_postinst() {
	  udev_reload
}
pkg_postrm() {
	  udev_reload
}


# vim: filetype=ebuild
