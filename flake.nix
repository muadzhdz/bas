{
  description = "Lapgen Mobile - Material Design 3 Academic Report Generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "34.0.0" "35.0.0" "36.0.0" ];
          platformVersions = [ "34" "35" "36" ];
          abiVersions = [ "x86_64" "arm64-v8a" ];
        };

        androidSdk = androidComposition.androidsdk;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            flutter
            dart
            jdk17
            androidSdk
          ];

          shellHook = ''
            NIX_ANDROID_SDK="${androidSdk}/libexec/android-sdk"
            TARGET_SDK="$HOME/.cache/lapgen-android-sdk"

            mkdir -p "$TARGET_SDK"
            for item in "$NIX_ANDROID_SDK"/*; do
              base=$(basename "$item")
              case "$base" in
                platform-tools|licenses|cmdline-tools) continue ;;
              esac
              ln -sfn "$item" "$TARGET_SDK/"
            done

            # Rebuild platform-tools as a writable dir so the system adb/fastboot can be
            # adopted (single adb for flutter doctor, system tools still usable).
            rm -rf "$TARGET_SDK/platform-tools"
            mkdir -p "$TARGET_SDK/platform-tools"
            for item in "$NIX_ANDROID_SDK/platform-tools"/*; do
              ln -sfn "$item" "$TARGET_SDK/platform-tools/"
            done
            if [ -x /usr/bin/adb ]; then
              ln -sfn /usr/bin/adb "$TARGET_SDK/platform-tools/adb"
              ln -sfn /usr/bin/fastboot "$TARGET_SDK/platform-tools/fastboot"
            fi

            # Licenses must be a writable real dir: sdkmanager persists accepted
            # licenses here, but the Nix store is read-only. Seeded from the
            # store; previously accepted licenses survive re-entry (no-clobber).
            if [ -L "$TARGET_SDK/licenses" ] || [ ! -e "$TARGET_SDK/licenses" ]; then
              rm -f "$TARGET_SDK/licenses"
              mkdir -p "$TARGET_SDK/licenses"
              cp -rL "$NIX_ANDROID_SDK/licenses/." "$TARGET_SDK/licenses/"
            fi
            chmod -R u+w "$TARGET_SDK/licenses"

            # cmdline-tools must be a writable dir so the sdkmanager shim below
            # can live in bin/. Rebuild its tree with per-file symlinks.
            rm -rf "$TARGET_SDK/cmdline-tools"
            mkdir -p "$TARGET_SDK/cmdline-tools/22.0/bin"
            for item in "$NIX_ANDROID_SDK/cmdline-tools/22.0"/*; do
              if [ "$(basename "$item")" = "bin" ]; then
                for inner in "$item"/*; do
                  [ "$(basename "$inner")" = "sdkmanager" ] && continue
                  ln -sfn "$inner" "$TARGET_SDK/cmdline-tools/22.0/bin/"
                done
              else
                ln -sfn "$item" "$TARGET_SDK/cmdline-tools/22.0/"
              fi
            done

            # nixpkgs' sdkmanager wrapper hardcodes --sdk_root to the read-only
            # store, so license acceptance can never persist. Replace it with a
            # shim that reroutes --sdk_root into the writable cache (sdkmanager
            # CLI: the last --sdk_root argument wins).
            SDKM_REAL="${androidSdk}/libexec/android-sdk/cmdline-tools/22.0/bin/sdkmanager"
            printf '#!/bin/sh\nSDK_BIN=$(dirname "$0")\nSDK_ROOT=$(dirname "$(dirname "$(dirname "$SDK_BIN")")")\nexec "%s" --sdk_root="$SDK_ROOT" "$@"\n' "$SDKM_REAL" > "$TARGET_SDK/cmdline-tools/22.0/bin/sdkmanager"
            chmod +x "$TARGET_SDK/cmdline-tools/22.0/bin/sdkmanager"

            # Dummy NDK marker to prevent Gradle from calling sdkmanager on read-only Nix store
            mkdir -p "$TARGET_SDK/ndk/28.2.13676358"
            cat << 'EOF_NDK' > "$TARGET_SDK/ndk/28.2.13676358/source.properties"
Pkg.Desc = Android NDK
Pkg.Revision = 28.2.13676358
EOF_NDK

            # Setup llvm-strip & llvm-objcopy for AGP tasks
            LLVM_BIN="$TARGET_SDK/ndk/28.2.13676358/toolchains/llvm/prebuilt/linux-x86_64/bin"
            mkdir -p "$LLVM_BIN"
            rm -f "$LLVM_BIN/llvm-strip" "$LLVM_BIN/llvm-objcopy"
            if command -v llvm-strip >/dev/null 2>&1; then
              ln -sf "$(command -v llvm-strip)" "$LLVM_BIN/llvm-strip"
              ln -sf "$(command -v llvm-objcopy)" "$LLVM_BIN/llvm-objcopy"
            else
              cat << 'EOF_TOOL' > "$LLVM_BIN/llvm-strip"
#!/bin/sh
output=""
input=""
while [ $# -gt 0 ]; do
  case "$1" in
    -o) output="$2"; shift 2 ;;
    -*) shift ;;
    *) input="$1"; shift ;;
  esac
done
[ -n "$output" ] && [ -n "$input" ] && cp -f "$input" "$output"
exit 0
EOF_TOOL
              cp -f "$LLVM_BIN/llvm-strip" "$LLVM_BIN/llvm-objcopy"
              chmod +x "$LLVM_BIN/llvm-strip" "$LLVM_BIN/llvm-objcopy"
            fi

            export ANDROID_HOME="$TARGET_SDK"
            export ANDROID_SDK_ROOT="$TARGET_SDK"
            export JAVA_HOME="${pkgs.jdk17}"

            # Drop the composed SDK's own bin dir from PATH: it leaks a second adb
            # (${androidSdk}/bin/adb) and re-triggers flutter's "multiple adb
            # binaries" warning. cmdline-tools/22.0/bin adds the same tooling
            # (sdkmanager, avdmanager, lint) without adb.
            export PATH=$(printf '%s\n' "$PATH" | tr ':' '\n' | grep -vxF "${androidSdk}/bin" | paste -sd: -)
            export PATH="${pkgs.jdk17}/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/22.0/bin:$PATH"
            flutter config --android-sdk "$ANDROID_HOME" 2>/dev/null || true
            export CHROME_EXECUTABLE="${pkgs.chromium}/bin/chromium"
            echo "Lapgen Mobile Dev Environment (Nix Flake)"
            echo "Flutter: $(flutter --version 2>/dev/null | head -n 1 || echo 'Ready')"
            echo "Android SDK: $ANDROID_HOME"
          '';
        };
      }
    );
}
