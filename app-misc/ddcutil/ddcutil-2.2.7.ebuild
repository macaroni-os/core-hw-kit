# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit autotools udev user

DESCRIPTION="Control monitor settings using DDC/CI and USB"
HOMEPAGE="http://www.ddcutil.com"
SRC_URI="https://api.github.com/repos/rockowitz/ddcutil/tarball/refs/tags/v2.2.7 -> ddcutil-2.2.7-4edf054.tar.gz"
LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="drm usb-monitor user-permissions video_cards_nvidia X"
REQUIRED_USE="drm? ( X )"
BDEPEND="virtual/pkgconfig
	
"
RDEPEND="dev-libs/glib:2
	dev-libs/jansson
	sys-apps/i2c-tools
	virtual/udev
	drm? ( x11-libs/libdrm )
	usb-monitor? (
	  dev-libs/hidapi
	  virtual/libusb:1
	  sys-apps/usbutils
	)
	X? (
	  x11-libs/libXrandr
	  x11-libs/libX11
	)
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv rockowitz-ddcutil-* ${S}
}


pkg_setup() {
	  if use user-permissions; then
	      enewgroup i2c
	  fi
}
src_prepare() {
	  default
	  eautoreconf
}
src_configure() {
	  local myeconfargs=(
	      $(use_enable drm)
	      --enable-udev
	      $(use_enable usb-monitor usb)
	      --enable-lib
	      $(use_enable X x11)
	  )
	  econf "${myeconfargs[@]}"
}
src_install() {
	  default
	  if use user-permissions; then
	      udev_dorules data/etc/udev/rules.d/60-ddcutil-i2c.rules
	      if use usb-monitor; then
	          udev_dorules data/etc/udev/rules.d/60-ddcutil-usb.rules
	      fi
	  fi
}
pkg_postinst() {
	  if use user-permissions; then
	      einfo "To allow non-root users access to the /dev/i2c-* devices, add those"
	      einfo "users to the i2c group: usermod -aG i2c user"
	      einfo "Restart the computer or reload the i2c-dev module to activate"
	      einfo "the new udev rule."
	      einfo "For more information read: http://www.ddcutil.com/i2c_permissions/"
	      if use usb-monitor; then
	          einfo "To allow non-root users access to USB monitors, add those users"
	          einfo "to the video group: usermod -aG video user"
	          einfo "Restart the computer, reload the hiddev and hidraw modules, or replug"
	          einfo "the monitor to activate the new udev rule."
	          einfo "For more information read: http://www.ddcutil.com/usb/"
	      fi
	      udev_reload
	  fi
	  if use video_cards_nvidia; then
	      ewarn "Please read the following webpage on proper usage with the nVidia "
	      ewarn "binary drivers, or it may not work: http://www.ddcutil.com/nvidia/"
	  fi
}
pkg_postrm() {
	  if use user-permissions; then
	      udev_reload
	  fi
}



# vim: filetype=ebuild
