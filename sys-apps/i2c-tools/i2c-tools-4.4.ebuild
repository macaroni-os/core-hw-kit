# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_OPTIONAL="1"

inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="I2C tools for bus probing, chip dumping, EEPROM decoding, and more"
HOMEPAGE="https://www.kernel.org/pub/software/utils/i2c-tools"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/i2c-tools-4.4.tar.xz -> i2c-tools-4.4.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"

src_prepare() {
	default
	use python && distutils-r1_src_prepare
}

src_configure() {
	use python && distutils-r1_src_configure

	export BUILD_DYNAMIC_LIB=1
	export USE_STATIC_LIB=0
	export BUILD_STATIC_LIB=0
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" EXTRA="eeprog"

	if use python ; then
		cd py-smbus || die
		append-cppflags -I../include
		distutils-r1_src_compile
	fi
}

src_install() {
	emake EXTRA="eeprog" DESTDIR="${D}" libdir="/usr/$(get_libdir)" PREFIX="/usr" install
	dodoc CHANGES README

	if use python ; then
		cd py-smbus || die
		docinto py-smbus
		dodoc README*
		distutils-r1_src_install
	fi
}