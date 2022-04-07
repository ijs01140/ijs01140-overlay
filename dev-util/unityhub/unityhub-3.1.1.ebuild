# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
 
EAPI=8

MY_BIN="${PN^}"

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
"
BDEPEND=""

QA_PREBUILT="
	opt/unityhub/${MY_BIN}
	opt/unityhub/libffmpeg.so
	opt/unityhub/libvk_swiftshader.so
	opt/unityhub/libEGL.so
	opt/unityhub/libGLESv2.so
	opt/unityhub/swiftshader/libEGL.so
	opt/unityhub/swiftshader/libGLESv2.so
"

src_prepare() {
	default
}

src_install() {
	doicon usr/share/icons/hicolor/1024x1024/apps/${PN}.png
	domenu usr/share/applications/${PN}.desktop

	insinto /opt/${PN}
	doins -r usr/${PN}/.
	fperms +x /opt/${PN}/${MY_BIN}
	dosym -r /opt/${PN}/${MY_BIN} /usr/bin/${PN}

	pax-mark -m "${ED}"/opt/${PN}/${PN}
}

pkg_postinst() {
	optfeature "Android build support" app-arch/cpio
	optfeature "system tray support" dev-libs/libappindicator
}