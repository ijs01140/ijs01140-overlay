# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit chromium-2 desktop linux-info unpacker xdg

DESCRIPTION="The CurseForge Electron App"
HOMEPAGE="https://curseforge.com"
SRC_URI="https://curseforge.overwolf.com/downloads/curseforge-latest-linux.deb"
S=${WORKDIR}

LICENSE="CurseForge-EULA"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libnotify
	dev-libs/nss
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	app-accessibility/at-spi2-core
	sys-apps/util-linux
	app-crypt/libsecret
"

RESTRICT="bindist mirror strip"

DESTDIR="/opt/CurseForge"

QA_PREBUILT="opt/CurseForge/*"

src_configure() {
	default
	chromium_suid_sandbox_check_kernel_config
}

src_install() {
    curseforge_dir="opt/CurseForge"

	exeinto ${DESTDIR}
	doexe ${curseforge_dir}/${PN} ${curseforge_dir}/chrome-sandbox ${curseforge_dir}/libEGL.so ${curseforge_dir}/libffmpeg.so ${curseforge_dir}/libEGL.so ${curseforge_dir}/libGLESv2.so ${curseforge_dir}/libvk_swiftshader.so ${curseforge_dir}/libvulkan.so.1
	exeinto ${DESTDIR}/resources/app.asar.unpacked/plugins/curse/linux/
    doexe ${curseforge_dir}/resources/app.asar.unpacked/plugins/curse/linux/Curse.Agent.Host

	insinto "${DESTDIR}"
	doins ${curseforge_dir}/chrome_100_percent.pak ${curseforge_dir}/chrome_200_percent.pak ${curseforge_dir}/icudtl.dat ${curseforge_dir}/resources.pak ${curseforge_dir}/snapshot_blob.bin ${curseforge_dir}/v8_context_snapshot.bin ${curseforge_dir}/vk_swiftshader_icd.json
	insopts -m0755
	doins -r ${curseforge_dir}/locales
	insinto "${DESTDIR}/resources/"
    doins ${curseforge_dir}/resources/app-update.yml ${curseforge_dir}/resources/app.asar ${curseforge_dir}/resources/package-type

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fowners root "${DESTDIR}/chrome-sandbox"
	fperms 4711 "${DESTDIR}/chrome-sandbox"

	# Crashpad is included in the package once in a while and when it does, it must be installed.
	# See #903616 and #890595
    exeinto "${DESTDIR}"
	[[ -x ${curseforge_dir}/chrome_crashpad_handler ]] && doexe ${curseforge_dir}/chrome_crashpad_handler

	insinto /usr/share
	doins -r usr/share/icons

	domenu "usr/share/applications/curseforge.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
