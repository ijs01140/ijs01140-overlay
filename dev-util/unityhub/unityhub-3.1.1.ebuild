# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
 
EAPI=8

MY_BIN="${MY_PN^}"

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

	sed -i \
		-e "s:/usr/share/discord/Discord:discord:" \
		usr/share/${MY_PN}/${MY_PN}.desktop || die
}

src_install() {
	doicon usr/share/icons/hicolor/1024x1024/apps/${MY_PN}.png
	domenu usr/share/applications/${MY_PN}.desktop

	insinto /opt/${MY_PN}
	doins -r usr/${MY_PN}/.
	fperms +x /opt/${MY_PN}/${MY_BIN}
	dosym -r /opt/${MY_PN}/${MY_BIN} /usr/bin/${MY_PN}

	pax-mark -m "${ED}"/opt/${MY_PN}/${MY_PN}
}

pkg_postinst() {
	optfeature "Android build support" app-arch/cpio
	optfeature "system tray support" dev-libs/libappindicator
}