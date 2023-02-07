# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="https://github.com/erocarrera/pefile https://pypi.org/project/pefile/"
SRC_URI="https://files.pythonhosted.org/packages/48/30/4559d06bad5bb627733dac1ef28c34f5e35f1461247ba63e5f6366901277/pefile-2022.5.30.tar.gz -> pefile-2022.5.30.tar.gz
"

DEPEND=""
IUSE=""
SLOT="0"
LICENSE=""
KEYWORDS="*"
S="${WORKDIR}/pefile-2022.5.30"