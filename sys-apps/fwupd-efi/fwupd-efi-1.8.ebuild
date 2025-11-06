# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
inherit meson python-single-r1

DESCRIPTION="EFI executable for fwupd"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://api.github.com/repos/fwupd/fwupd-efi/tarball/1.8 -> fwupd-efi-1.8-8572a93.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	
"
DEPEND="sys-boot/gnu-efi
	$(python_gen_cond_dep 'dev-python/pefile[${PYTHON_USEDEP}]')
	
"

post_src_unpack() {
	mv fwupd-fwupd-efi-* ${S}
}


src_prepare() {
	default
	python_fix_shebang "${S}/efi"
}
src_configure() {
	local emesonargs=(
	  -Defi-libdir="${EPREFIX}"/usr/$(get_libdir)
	  -Defi_sbat_distro_id="macaroni"
	  -Defi_sbat_distro_summary="MacaroniOS GNU/Linux"
	  -Defi_sbat_distro_pkgname="${PN}"
	  -Defi_sbat_distro_version="${PVR}"
	)
	meson_src_configure
}



# vim: filetype=ebuild
