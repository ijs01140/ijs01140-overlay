# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
 
EAPI=8

inherit desktop linux-info optfeature pax-utils unpacker

DESCRIPTION="Some words here"
HOMEPAGE="https://unity3d.com/"
SRC_URI="https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${PV}.deb"
S="${WORKDIR}"

LICENSE="Unity-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="
	dev-libs/nss
	x11-libs/gtk+:3
	app-crypt/mit-krb5
	dev-util/lttng-ust
"
BDEPEND=""

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default
}

src_install() {
	doicon usr/share/icons/hicolor/1024x1024/apps/${PN}.png
	domenu usr/share/applications/${PN}.desktop

	insinto /opt/${PN}
	doins -r opt/${PN}/.
	fperms +x /opt/${PN}/${PN}
	fperms +x /opt/${PN}/${PN}-bin
	dosym -r /opt/${PN}/${PN} /usr/bin/${PN}

	pax-mark -m "${ED}"/opt/${PN}/${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "Android build support" app-arch/cpio
	optfeature "system tray support" dev-libs/libappindicator
}