# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop optfeature unpacker xdg-utils

DESCRIPTION="TheDesk is a Mastodon client for PC."
HOMEPAGE="https://thedesk.top/"
SRC_URI="https://github.com/cutls/TheDesk/releases/download/v${PV}/${PN}_${PV}_amd64.deb"
#https://github.com/cutls/TheDesk/releases/download/v24.0.8/thedesk_24.0.8_amd64.deb
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libappindicator
	dev-libs/nss
	gnome-base/gconf:2
	x11-libs/libnotify
	x11-libs/libXtst
"

RESTRICT="mirror"

DESTDIR="/opt/TheDesk/"

QA_PREBUILT="/opt/TheDesk/*"

S="${WORKDIR}"

src_unpack(){
    unpack_deb ${A}
} 

src_install() {
	echo "PN is ${PN}"
	insinto /opt/TheDesk/
	doins -r opt/TheDesk/*

	fperms +x "${DESTDIR}/${PN}"
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

	dodir /usr/bin
	dosym "/opt/TheDesk/${PN}" "/usr/bin/${PN}"

	insinto /usr/share
	doins -r "${WORKDIR}/usr/share/icons"

	domenu "${WORKDIR}/usr/share/applications/${PN}.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
