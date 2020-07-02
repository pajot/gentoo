# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake python-single-r1 xdg-utils

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="https://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode static"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/boost-1.55:=
	>=dev-libs/glib-2.28.0:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	>=sci-libs/libsigrok-0.6.0:=[cxx]
	decode? (
		${PYTHON_DEPS}
		>=sci-libs/libsigrokdecode-0.6.0:=[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

DOCS=( HACKING NEWS README )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		-DENABLE_DECODE=$(usex decode)
		-DSTATIC_PKGDEPS_LIBS=$(usex static)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
