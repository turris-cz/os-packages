#!/bin/bash
# Build the packages that a push or a pull request changes, with the SDK that
# the build of Turris OS publishes on repo.turris.cz.
#
# usage: sdk-build.sh select
#        sdk-build.sh prepare BOARD
#        sdk-build.sh build
#
# The steps pass their results to each other through $GITHUB_ENV.
set -euo pipefail
# The patches of turris-build are applied in glob order
export LC_ALL=C

FEED_DIR="${GITHUB_WORKSPACE:-$PWD}"
SDK_DIR="${SDK_DIR:-${RUNNER_TEMP:-/tmp}/turris-sdk}"
# Kept outside the SDK, which prepare removes, so that the workflow can cache
# them between runs
CCACHE_PATH="${CCACHE_PATH:-${RUNNER_TEMP:-/tmp}/ccache}"
DOWNLOADS_PATH="${DOWNLOADS_PATH:-${RUNNER_TEMP:-/tmp}/dl}"
ARTIFACTS_DIR="${ARTIFACTS_DIR:-$FEED_DIR/artifacts}"
REPO_URL="${REPO_URL:-https://repo.turris.cz}"
OS_BUILD_ARCHIVE_URL="${OS_BUILD_ARCHIVE_URL:-https://codeload.github.com/turris-cz/os-build/tar.gz}"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/turris-cz/os-packages.git}"
# Built when no package changed. It needs the updater and its libraries, so
# the SDK and the feeds are still tested with what most of Turris OS uses.
FALLBACK_PACKAGES="${FALLBACK_PACKAGES:-pkglists}"

group() {
	echo "::group::$*"
}

endgroup() {
	echo "::endgroup::"
}

die() {
	echo "::error::$*"
	exit 1
}

setenv() {
	echo "$1=$2"
	[ -z "${GITHUB_ENV:-}" ] || echo "$1=$2" >>"$GITHUB_ENV"
}

# Prints master or develop, whichever REF was started from. develop contains
# master, so REF counts as started from develop only when it shares a newer
# commit with develop than with master.
started_from() {
	local master develop
	master="$(git merge-base upstream/master "$1")"
	develop="$(git merge-base upstream/develop "$1")"
	if [ "$master" != "$develop" ] \
			&& git merge-base --is-ancestor "$master" "$develop"; then
		echo "develop"
	else
		echo "master"
	fi
}

select_changes() {
	local base range="" tos_branch roots changes packages="" file root best
	cd "$FEED_DIR"

	# The branches of the main repository, as those of a fork may lag behind
	git fetch --quiet --no-tags "$UPSTREAM_URL" \
		"+refs/heads/master:refs/remotes/upstream/master" \
		"+refs/heads/develop:refs/remotes/upstream/develop"

	if [ -n "${GITHUB_BASE_REF:-}" ]; then
		# A pull request
		base="$GITHUB_BASE_REF"
		git rev-parse -q --verify "origin/$base^{commit}" >/dev/null \
			|| die "Unknown base branch: $base"
		range="origin/$base...HEAD"
	else
		base="${GITHUB_REF_NAME:-}"
		case "$base" in
			master|develop|temp/tos10)
				# A push to the branch itself
				if [ -n "${PUSH_BEFORE:-}" ] \
						&& git cat-file -e "$PUSH_BEFORE^{commit}" 2>/dev/null; then
					range="$PUSH_BEFORE..HEAD"
				else
					range="HEAD^..HEAD"
				fi
				;;
			hotfix/*)
				base="master"
				;;
			bugfix/*|feature/*|refactor/*|hack/*)
				base="develop"
				;;
			*)
				base="$(started_from HEAD)"
				;;
		esac
		[ -n "$range" ] || range="upstream/$base...HEAD"
	fi

	# The branches of Turris OS that are built from this repository
	case "$base" in
		master)
			tos_branch="hbk"
			;;
		develop)
			tos_branch="hbl"
			;;
		temp/tos10)
			tos_branch="hbd"
			;;
		*)
			if [ "$(started_from "origin/$base")" = "develop" ]; then
				tos_branch="hbl"
			else
				tos_branch="hbk"
			fi
			;;
	esac

	# A package is a directory with a Makefile, apart from the sources and
	# the other files that a package carries
	roots="$(git ls-files -- '*/Makefile' \
		| grep -v -E '/(src|files|patches)/' | sed 's|/Makefile$||')"
	# Read in full first, a failure inside the loop input would go unnoticed
	changes="$(git diff --diff-filter=d --name-only "$range")"
	group "Files changed in $range"
	while read -r file; do
		[ -n "$file" ] || continue
		echo "$file"
		best=""
		for root in $roots; do
			case "$file" in
				"$root"/*)
					[ "${#root}" -le "${#best}" ] || best="$root"
					;;
			esac
		done
		[ -z "$best" ] || packages="$packages ${best##*/}"
	done <<<"$changes"
	endgroup
	packages="$(echo "$packages" | tr ' ' '\n' | sort -u | xargs)"
	if [ -z "$packages" ]; then
		echo "No package changed, building $FALLBACK_PACKAGES"
		packages="$FALLBACK_PACKAGES"
	fi

	setenv TOS_BRANCH "$tos_branch"
	setenv PACKAGES "$packages"
	# The build jobs take these, the label goes to their names
	if [ -n "${GITHUB_OUTPUT:-}" ]; then
		{
			echo "tos_branch=$tos_branch"
			echo "tos_label=$(echo "$tos_branch" | tr '[:lower:]' '[:upper:]')"
			echo "packages=$packages"
		} >>"$GITHUB_OUTPUT"
	fi
}

prepare_sdk() {
	local board="$1" url link target turris_build version
	: "${TOS_BRANCH:?unknown Turris OS branch, run the select step first}"
	url="$REPO_URL/$TOS_BRANCH/$board/packages"
	rm -rf "$SDK_DIR"
	mkdir -p "$SDK_DIR"

	group "Download the SDK from $url"
	curl -fsSL --retry 3 "$url/sdk-$board-x86-64.tar.zst" \
		| zstd -dc | tar -x --strip-components=1 -C "$SDK_DIR"
	curl -fsSL --retry 3 -o "$SDK_DIR/turris-git-hash" "$url/git-hash"
	curl -fsSL --retry 3 -o "$SDK_DIR/turris-config.buildinfo" "$url/config.buildinfo"
	cat "$SDK_DIR/turris-git-hash"
	endgroup

	version="$(sed -n 's/^CONFIG_VERSION_NUMBER="\(.*\)"$/\1/p' "$SDK_DIR/turris-config.buildinfo")"
	echo "Turris OS ${version:-unknown} ($TOS_BRANCH) for $board"
	if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
		echo "Built with the SDK of Turris OS ${version:-unknown} ($TOS_BRANCH) for $board" \
			>>"$GITHUB_STEP_SUMMARY"
	fi

	# A few links of the SDK point into the directory it was built in
	while IFS= read -r -d '' link; do
		target="$(readlink "$link")"
		case "$target" in
			*/build/*)
				if [ -e "$SDK_DIR/${target#*/build/}" ]; then
					ln -sfn "$SDK_DIR/${target#*/build/}" "$link"
					echo "Fixed link ${link#"$SDK_DIR"/} -> ${target#*/build/}"
					continue
				fi
				;;
		esac
		echo "::warning::Broken link in the SDK: ${link#"$SDK_DIR"/} -> $target"
	done < <(find "$SDK_DIR/staging_dir/host" -xtype l -print0)

	# Turris OS builds the kernel image in the kernel package and installs
	# it to /boot (hack/0005 in turris-build). The SDK has neither the
	# whole kernel tree nor the image. Apply the change proposed for
	# turris-build, which skips both in the SDK, until the SDK has it.
	if ! grep -q '^ifndef SDK$' "$SDK_DIR/package/kernel/linux/Makefile"; then
		patch -p1 -d "$SDK_DIR" <"$FEED_DIR/.github/workflows/sdk-kernel-package.patch"
	fi

	# The feeds.conf.default of the SDK can point to the local mirrors of
	# the build server. Take the feeds from turris-build at the commit the
	# SDK was built from, at the commits they had then, and this repository
	# in place of the turrispackages feed.
	group "feeds.conf"
	turris_build="$(awk '$2 == "turris-build:" { print $3 }' "$SDK_DIR/turris-git-hash")"
	[ -n "$turris_build" ] || die "git-hash does not name the turris-build commit"
	mkdir -p "$SDK_DIR/turris-build"
	curl -fsSL --retry 3 "$OS_BUILD_ARCHIVE_URL/$turris_build" \
		| tar -xz --strip-components=1 -C "$SDK_DIR/turris-build"
	echo "$board" >"$SDK_DIR/turris-board"
	cp "$SDK_DIR/turris-build/feeds.conf" "$SDK_DIR/turris-feeds.conf"
	if [ -f "$SDK_DIR/turris-build/feeds.conf.$board" ]; then
		cat "$SDK_DIR/turris-build/feeds.conf.$board" >>"$SDK_DIR/turris-feeds.conf"
	fi
	# The mirrors on openwrt.turris.cz hold the same commits as these
	# repositories on GitHub, which can serve a single commit. The mirrors
	# can only be cloned in full.
	awk -v feed="$FEED_DIR" '
		function github(url,  path) {
			path = url
			if (!sub(/^https:\/\/openwrt\.turris\.cz\//, "", path))
				return ""
			sub(/\.git$/, "", path)
			if (path == "openwrt/openwrt")
				return "https://github.com/openwrt/openwrt.git"
			if (path ~ /^(feed|project)\/[^\/]+$/) {
				sub(/^[^\/]+\//, "", path)
				return "https://github.com/openwrt/" path ".git"
			}
			if (path ~ /^(nxhack|CESNET)\/[^\/]+$/)
				return "https://github.com/" path ".git"
			return ""
		}
		function line(vcs, flags, name, url,  gh) {
			sub(/[;^].*$/, "", url)
			if (!(name in pin)) {
				print "::warning::No commit known for the feed " name > "/dev/stderr"
				return vcs flags " " name " " url
			}
			gh = github(url)
			if (gh == "") {
				print "::warning::Cloning the feed " name " in full from " url > "/dev/stderr"
				return vcs flags " " name " " url "^" pin[name]
			}
			# src-git clones only the one commit
			return "src-git" flags " " name " " gh "^" pin[name]
		}
		FILENAME ~ /turris-git-hash$/ {
			if ($1 == "*" && $2 == "openwrt:")
				pin["base"] = $3
			else if ($1 == "*" && $2 ~ /^feeds\/.+:$/)
				pin[substr($2, 7, length($2) - 7)] = $3
			next
		}
		# The SDK knows how to use the main repository as its base feed,
		# for example with --root=package since OpenWrt 25.12
		FILENAME ~ /feeds\.conf\.default$/ {
			for (i = 2; i <= NF && $i ~ /^--/; i++)
				base_flags = base_flags " " $i
			if ($1 ~ /^src-/ && $i == "base")
				base_vcs = $1
			else
				base_flags = ""
			if (base_vcs != "")
				nextfile
			next
		}
		$1 == "#" && $2 == "openwrt" {
			print line(base_vcs == "" ? "src-git-full" : base_vcs, base_flags, "base", $3)
			next
		}
		$1 ~ /^src-/ && $2 == "turrispackages" {
			print "src-link turrispackages " feed
			next
		}
		$1 ~ /^src-git/ {
			print line($1, "", $2, $3)
			next
		}
		$1 ~ /^src-/ {
			print
		}
	' "$SDK_DIR/turris-git-hash" "$SDK_DIR/feeds.conf.default" \
		"$SDK_DIR/turris-feeds.conf" >"$SDK_DIR/feeds.conf"
	cat "$SDK_DIR/feeds.conf"
	grep -q -E '^src-[a-z-]+( --[^ ]+)* base ' "$SDK_DIR/feeds.conf" \
		|| die "turris-build does not name the main repository"
	endgroup
}

apply_patches() {
	local repo="$1" patch
	for patch in "$2"/*/*.patch; do
		[ -e "$patch" ] || continue
		echo "${patch#"$SDK_DIR/turris-build/"}"
		git -C "$repo" -c commit.gpgsign=false \
			-c "user.name=Turris build system" \
			-c user.email=auto-build@example.com \
			am --whitespace=nowarn "$patch" >/dev/null \
			|| die "A patch of turris-build does not apply: ${patch#"$SDK_DIR/turris-build/"}"
	done
}

# Turris OS builds its packages from feeds with the patches and files of
# turris-build on top (patch_openwrt and repatch_feeds in compile_pkgs).
# The SDK fetches the plain feeds, so add them the same way.
patch_feeds() {
	local osb="$SDK_DIR/turris-build" board name dir repo overlay
	board="$(cat "$SDK_DIR/turris-board")"
	while read -r name; do
		# turris-build calls the main repository openwrt
		dir="$name"
		[ "$name" != base ] || dir=openwrt
		repo="$(git -C "feeds/$name/" rev-parse --show-toplevel)"
		group "turris-build changes of the feed $name"
		apply_patches "$repo" "$osb/patches/$dir"
		if [ "$dir" = openwrt ]; then
			apply_patches "$repo" "$osb/patches/$board/openwrt"
		fi
		for overlay in "" "$board/"; do
			if [ -f "$osb/src/${overlay}clean.list.$dir" ]; then
				echo "src/${overlay}clean.list.$dir"
				git -C "$repo" rm -q -r \
					--pathspec-from-file="$osb/src/${overlay}clean.list.$dir"
			fi
			if [ -d "$osb/src/$overlay$dir" ]; then
				echo "src/$overlay$dir"
				cp -R "$osb/src/$overlay$dir/." "$repo/"
			fi
		done
		endgroup
	done < <(awk '$1 ~ /^src-git/ {
			for (i = 2; i <= NF && $i ~ /^--/; i++)
				;
			print $i
		}' feeds.conf)
}

build_packages() {
	local pkg ret=0
	: "${PACKAGES:?no packages to build, run the select step first}"
	cd "$SDK_DIR"

	group "feeds update -a"
	./scripts/feeds update -a
	endgroup

	patch_feeds
	group "feeds update -i"
	./scripts/feeds update -i
	endgroup

	for pkg in $PACKAGES; do
		group "feeds install -p turrispackages -f $pkg"
		./scripts/feeds install -p turrispackages -f "$pkg"
		endgroup
	done

	# Build with the package options of the Turris OS build, for example
	# curl with OpenSSL, which the updater needs. The options of the build
	# itself, such as the target or building an SDK or a toolchain, are
	# left out.
	group "make defconfig"
	grep -v -E '^(# )?CONFIG_(SDK|MAKE_TOOLCHAIN|TOOLCHAINOPTS|DEVEL|EXTRA_GCC_CONFIG_OPTIONS|GCC_[A-Z0-9_]+|KERNEL_BUILD_[A-Z]+|TARGET_[A-Za-z0-9_-]+)( is not set|=)' \
		"$SDK_DIR/turris-config.buildinfo" >.config
	mkdir -p "$CCACHE_PATH" "$DOWNLOADS_PATH"
	echo "CONFIG_CCACHE_DIR=\"$CCACHE_PATH\"" >>.config
	echo "CONFIG_DOWNLOAD_FOLDER=\"$DOWNLOADS_PATH\"" >>.config
	make defconfig
	endgroup
	# Every board and branch stores a cache of its own, so keep each small
	export CCACHE_MAXSIZE=500M

	for pkg in $PACKAGES; do
		# The sources of some Turris packages are only on gitlab.nic.cz,
		# which sometimes refuses a runner, so try more than once
		group "make package/$pkg/download"
		for try in 1 2 3; do
			if make "package/$pkg/download" V=s; then
				break
			fi
			[ "$try" -lt 3 ] || die "Unable to download the sources of $pkg"
			echo "::warning::Download of the sources of $pkg failed, trying again"
			sleep 60
		done
		endgroup

		group "make package/$pkg/check"
		if ! make "package/$pkg/check" V=s 2>&1 | tee check.log; then
			endgroup
			die "The check of $pkg failed"
		fi
		endgroup
		if grep -q -E 'HASH does not match |HASH uses deprecated hash,|HASH is missing,' check.log; then
			die "The hash of the sources of $pkg is wrong"
		fi
	done

	# A package that depends on another target is not offered for this one
	make -f .config -f tmp/.packagedeps \
		-f <(echo "\$(info \$(sort \$(package-y) \$(package-m)))"; echo -en "a:\n\t@:") \
		| tr ' ' '\n' >enabled-package-subdirs.txt

	for pkg in $PACKAGES; do
		if ! grep -m1 -q -E "(^|/)$pkg$" enabled-package-subdirs.txt; then
			# The fallback must build, or the run tests nothing at all
			[ "$PACKAGES" != "$FALLBACK_PACKAGES" ] \
				|| die "$pkg is not available for this board"
			echo "::warning::Skipping $pkg, it is not available for this board"
			continue
		fi
		group "make package/$pkg/compile"
		if ! make -j"$(nproc)" BUILD_LOG=1 V=s "package/$pkg/compile"; then
			echo "::error::$pkg failed to build"
			ret=1
		fi
		endgroup
	done

	group "ccache statistics"
	CCACHE_DIR="$CCACHE_PATH" staging_dir/host/bin/ccache -s || true
	endgroup

	mkdir -p "$ARTIFACTS_DIR/packages" "$ARTIFACTS_DIR/logs"
	cp -v bin/packages/*/turrispackages/*.ipk "$ARTIFACTS_DIR/packages/" 2>/dev/null || true
	[ ! -d logs ] || cp -R logs/. "$ARTIFACTS_DIR/logs/"
	return "$ret"
}

case "${1:-}" in
	select)
		select_changes
		;;
	prepare)
		[ -n "${2:-}" ] || die "usage: $0 prepare BOARD"
		prepare_sdk "$2"
		;;
	build)
		build_packages
		;;
	*)
		die "usage: $0 select|prepare BOARD|build"
		;;
esac
