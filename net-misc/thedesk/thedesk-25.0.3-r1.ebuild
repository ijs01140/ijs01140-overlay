# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop optfeature unpacker xdg-utils

DESCRIPTION="TheDesk is a Mastodon client for PC."
HOMEPAGE="https://thedesk.top/"
#https://github.com/cutls/thedesk-next/releases/download/v25.0.3/thedesk-next_25.0.3_amd64.deb
SRC_URI="https://github.com/cutls/thedesk-next/releases/download/v${PV}/${PN}-next_${PV}_amd64.deb"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

#Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils, libatspi2.0-0, libuuid1, libsecret-1-0
RDEPEND="
	x11-libs/libnotify
	dev-libs/nss
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	app-accessibility/at-spi2-core:2
	sys-apps/util-linux
	app-crypt/libsecret
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

	fperms +x "${DESTDIR}/${PN}-next"
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

    fperms +x "${DESTDIR}/chrome_crashpad_handler"
    fperms +x "${DESTDIR}/libEGL.so"
    fperms +x "${DESTDIR}/libGLESv2.so"
    fperms +x "${DESTDIR}/libffmpeg.so"
    fperms +x "${DESTDIR}/libvk_swiftshader.so"
    fperms +x "${DESTDIR}/libvulkan.so.1"

	dodir /usr/bin
	dosym "/opt/TheDesk/${PN}-next" "/usr/bin/${PN}-next"

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
