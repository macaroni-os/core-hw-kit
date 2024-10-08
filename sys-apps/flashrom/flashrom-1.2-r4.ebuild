# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_P="${PN}-v${PV}"
SRC_URI="https://download.flashrom.org/releases/${MY_P}.tar.bz2"
KEYWORDS="*"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="https://flashrom.org/Flashrom"

LICENSE="GPL-2"
SLOT="0"

# The defaults match the upstream meson_options.txt.
IUSE_PROGRAMMERS="
	atahpt
	atapromise
	+atavia
	+buspirate-spi
	+ch341a-spi
	+dediprog
	+developerbox-spi
	+digilent-spi
	+drkaiser
	+dummy
	+ft2232-spi
	+gfxnvidia
	+internal
	+it8212
	jlink-spi
	+linux-mtd
	+linux-spi
	mstarddc-spi
	+nic3com
	+nicintel
	+nicintel-eeprom
	+nicintel-spi
	nicnatsemi
	+nicrealtek
	+ogp-spi
	+pickit2-spi
	+pony-spi
	+rayer-spi
	+satamv
	+satasii
	+serprog
	+stlinkv3-spi
	+usbblaster-spi
"
IUSE="${IUSE_PROGRAMMERS} +internal-dmi tools"

RDEPEND="atahpt? ( sys-apps/pciutils )
	atapromise? ( sys-apps/pciutils )
	atavia? ( sys-apps/pciutils )
	ch341a-spi? ( virtual/libusb:1 )
	dediprog? ( virtual/libusb:1 )
	developerbox-spi? ( virtual/libusb:1 )
	digilent-spi? ( virtual/libusb:1 )
	drkaiser? ( sys-apps/pciutils )
	ft2232-spi? ( dev-embedded/libftdi:1= )
	gfxnvidia? ( sys-apps/pciutils )
	internal? ( sys-apps/pciutils )
	it8212? ( sys-apps/pciutils )
	jlink-spi? ( dev-embedded/libjaylink )
	nic3com? ( sys-apps/pciutils )
	nicintel-eeprom? ( sys-apps/pciutils )
	nicintel-spi? ( sys-apps/pciutils )
	nicintel? ( sys-apps/pciutils )
	nicnatsemi? ( sys-apps/pciutils )
	nicrealtek? ( sys-apps/pciutils )
	ogp-spi? ( sys-apps/pciutils )
	pickit2-spi? ( virtual/libusb:0 )
	rayer-spi? ( sys-apps/pciutils )
	satamv? ( sys-apps/pciutils )
	satasii? ( sys-apps/pciutils )
	stlinkv3-spi? ( virtual/libusb:1 )
	usbblaster-spi? ( dev-embedded/libftdi:1= )"
DEPEND="${RDEPEND}
	sys-apps/diffutils"
RDEPEND+=" !internal-dmi? ( sys-apps/dmidecode )"

DOCS=( README Documentation/ )

PATCHES=(
	"${FILESDIR}"/${PN}-1.2_meson-fixes.patch
	"${FILESDIR}"/${PN}-1.2_meson-install-manpage.patch
	"${FILESDIR}"/${PN}-1.2_fix_building_on-aarch64.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use atahpt config_atahpt)
		$(meson_use atapromise config_atapromise)
		$(meson_use atavia config_atavia)
		$(meson_use buspirate-spi config_buspirate_spi)
		$(meson_use ch341a-spi config_ch341a_spi)
		$(meson_use dediprog config_dediprog)
		$(meson_use developerbox-spi config_developerbox_spi)
		$(meson_use digilent-spi config_digilent_spi)
		$(meson_use drkaiser config_drkaiser)
		$(meson_use dummy config_dummy)
		$(meson_use ft2232-spi config_ft2232_spi)
		$(meson_use gfxnvidia config_gfxnvidia)
		$(meson_use internal config_internal)
		$(meson_use internal-dmi config_internal_dmi)
		$(meson_use it8212 config_it8212)
		$(meson_use jlink-spi config_jlink_spi)
		$(meson_use linux-mtd config_linux_mtd)
		$(meson_use linux-spi config_linux_spi)
		$(meson_use mstarddc-spi config_mstarddc_spi)
		$(meson_use nic3com config_nic3com)
		$(meson_use nicintel-eeprom config_nicintel_eeprom)
		$(meson_use nicintel-spi config_nicintel_spi)
		$(meson_use nicintel config_nicintel)
		$(meson_use nicnatsemi config_nicnatsemi)
		$(meson_use nicrealtek config_nicrealtek)
		$(meson_use ogp-spi config_ogp_spi)
		$(meson_use pickit2-spi config_pickit2_spi)
		$(meson_use pony-spi config_pony_spi)
		$(meson_use rayer-spi config_rayer_spi)
		$(meson_use satamv config_satamv)
		$(meson_use satasii config_satasii)
		$(meson_use stlinkv3-spi config_stlinkv3_spi)
		$(meson_use serprog config_serprog)
		$(meson_use usbblaster-spi config_usbblaster_spi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use tools; then
		dosbin "${BUILD_DIR}"/util/ich_descriptors_tool/ich_descriptors_tool
	fi
}
