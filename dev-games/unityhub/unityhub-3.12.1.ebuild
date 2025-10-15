# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop linux-info optfeature unpacker xdg-utils

DESCRIPTION="The Official Unity Hub"
HOMEPAGE="https://unity.com/"
SRC_URI="https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${PV}.deb"
S="${WORKDIR}"

LICENSE="Unity-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror bindist strip"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/nss
    dev-util/lttng-ust
	sys-apps/util-linux
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
"
BDEPEND=""

DESTDIR="/opt/${PN}"

QA_PREBUILT="/opt/${PN}/*"

src_unpack(){
	unpack_deb ${A}
}

src_install() {
	insinto "/opt/${PN}"
	doins -r opt/${PN}/*
	fperms +x "/opt/${PN}/${PN}"
	fperms +x "/opt/${PN}/${PN}-bin"
	fperms +x "/opt/${PN}/UnityLicensingClient_V1/Unity.Licensing.Client"
	fperms +x "/opt/${PN}/resources/app.asar.unpacked/lib/linux/7z/linux64/7z"
	fperms +x "/opt/${PN}/resources/app.asar.unpacked/lib/linux/7z/linux64/7zCon.sfx"
    fperms +x "/opt/${PN}/chrome_crashpad_handler"
    fperms +x "/opt/${PN}/libEGL.so"
    fperms +x "/opt/${PN}/libGLESv2.so"
    fperms +x "/opt/${PN}/libffmpeg.so"
    fperms +x "/opt/${PN}/libvk_swiftshader.so"
    fperms +x "/opt/${PN}/libvulkan.so.1"
    fperms +x "/opt/${PN}/libffmpeg.so"
	dosym -r "/opt/${PN}/${PN}" "/usr/bin/${PN}"

	insinto /usr/share
	doins -r usr/share/icons

	domenu "usr/share/applications/${PN}.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "Android build support" app-arch/cpio
	optfeature "system tray support" dev-libs/libappindicator
}
