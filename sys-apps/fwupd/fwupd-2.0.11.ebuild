# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit bash-completion-r1 meson python-single-r1 vala udev xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://api.github.com/repos/fwupd/fwupd/tarball/2.0.11 -> fwupd-2.0.11.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
PATCHES=(
	"${FILESDIR}/elogind.patch"
)
IUSE="amdgpu amt archive bash-completion bluetooth +dell +elogind flashrom
+gnutls gtk-doc introspection logitech lzma +man minimal modemmanager nvme
policykit spi +sqlite synaptics thunderbolt tpm +uefi +hsi +lvfs
"
REQUIRED_USE="^^ ( elogind minimal )
dell? ( uefi )
minimal? ( !introspection )
spi? ( lzma )
synaptics? ( gnutls )
uefi? ( gnutls )
"
# Commons depends
CDEPEND="${PYTHON_DEPS}
	app-arch/gcab
	app-arch/xz-utils
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgudev:=
	dev-libs/libjcat[gpg,pkcs7]
	dev-libs/libxmlb:=[introspection?]
	$(python_gen_cond_dep '
	  dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
	net-libs/libsoup:2.4[introspection?]
	net-misc/curl
	archive? ( app-arch/libarchive:= )
	dell? ( sys-libs/libsmbios )
	elogind? ( sys-auth/elogind )
	flashrom? ( sys-apps/flashrom )
	gnutls? ( net-libs/gnutls )
	logitech? ( dev-libs/protobuf-c:= )
	lzma? ( app-arch/xz-utils )
	modemmanager? ( net-misc/modemmanager[qmi] )
	policykit? ( sys-auth/polkit )
	sqlite? ( dev-db/sqlite )
	tpm? ( app-crypt/tpm2-tss:= )
	uefi? (
	  sys-apps/fwupd-efi
	  sys-boot/efibootmgr
	  sys-fs/udisks
	  sys-libs/efivar
	)
	
"
BDEPEND="$(vala_depend)
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	introspection? ( dev-libs/gobject-introspection )
	man? (
	  app-text/docbook-sgml-utils
	  sys-apps/help2man
	)
	
"
RDEPEND="${CDEPEND}
	sys-apps/dbus
	
"
DEPEND="${CDEPEND}
	x11-libs/pango[introspection]
	
"

post_src_unpack() {
	mv fwupd-fwupd-* ${S}
}


src_prepare() {
	default
	sed -e "/install_dir.*'doc'/s/fwupd/${PF}/" \
	  -i data/meson.build || die
	 vala_src_prepare
}
src_configure() {
	local emesonargs=(
	  --localstatedir "${EPREFIX}"/var
	  -Dbuild="$(usex minimal standalone all)"
	  -Dsystemd="disabled"
	  -Ddocs="$(usex gtk-doc enabled disabled)"
	  -Defi_binary="false"
	  -Dsupported_build="enabled"
	  $(meson_feature archive libarchive)
	  $(meson_use bash-completion bash_completion)
	  $(meson_feature bluetooth bluez)
	  $(meson_feature elogind)
	  $(meson_feature gnutls)
	  $(meson_feature flashrom plugin_flashrom)
	  $(meson_feature modemmanager plugin_modem_manager)
	  $(meson_use uefi plugin_uefi_capsule_splash)
	  $(meson_feature introspection)
	  $(meson_feature policykit polkit)
	  $(meson_use man)
	  $(meson_use lvfs)
	  $(meson_feature hsi)
	  -Dtests=false
	)
	use uefi && emesonargs+=( -Defi_os_dir="macaronios" )
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}
src_install() {
	meson_src_install
	if ! use minimal ; then
	  newinitd "${FILESDIR}"/${PN}-r2 ${PN}
	  # Don't timeout when fwupd is running (#673140)
	  sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
	    -i "${ED}"/etc/${PN}/fwupd.conf || die
	fi
}
pkg_postinst() {
	xdg_pkg_postinst
	use minimal || udev_reload
}
pkg_postrm() {
	xdg_pkg_postrm
	use minimal || udev_reload
}



# vim: filetype=ebuild
