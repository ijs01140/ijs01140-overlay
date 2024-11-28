# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop linux-info unpacker xdg

DESCRIPTION="Resolute, a mod manager for Resonite"
HOMEPAGE="https://github.com/Gawdl3y/Resolute"
SRC_URI="https://github.com/Gawdl3y/Resolute/releases/download/v${PV}/${PN}_${PV}_amd64.deb"
S=${WORKDIR}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    net-libs/webkit-gtk:4.1
	x11-libs/gtk+:3
"

RESTRICT="mirror"

QA_PREBUILT="usr/bin/${PN}"

src_install() {
	exeinto /usr/bin
	doexe usr/bin/${PN}

	insinto /usr/share
	doins -r usr/share/icons

	domenu "usr/share/applications/resolute.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
