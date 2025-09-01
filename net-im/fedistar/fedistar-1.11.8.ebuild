# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop unpacker xdg-utils

DESCRIPTION=" Multi-column Fediverse client for desktop. Supporting Mastodon, Pleroma, Friendica, Gotosocial, and Firefish."
HOMEPAGE="https://fedistar.net/"
#https://github.com/h3poteto/fedistar/releases/download/v1.11.8/fedistar_1.11.8_amd64.deb
SRC_URI="https://github.com/h3poteto/fedistar/releases/download/v${PV}/${PN}_${PV}_amd64.deb"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

#Depends: libwebkit2gtk-4.1-0, libgtk-3-0
RDEPEND="
	net-libs/webkit-gtk:4.1
	x11-libs/gtk+:3
"

RESTRICT="mirror"

QA_PREBUILT="usr/bin/fedistar"

S="${WORKDIR}"

src_unpack(){
    unpack_deb ${A}
} 

src_install() {
	echo "PN is ${PN}"

	dobin "${WORKDIR}/usr/bin/fedistar"

	insinto /usr/share
	doins -r "${WORKDIR}/usr/share/icons"

	domenu "${WORKDIR}/usr/share/applications/fedistar.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
