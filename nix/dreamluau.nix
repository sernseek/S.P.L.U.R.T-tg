# Dreamluau 的 32 位 Linux 发布版，与 dependencies.sh 中的版本保持一致。
{
  lib,
  pkgsi686Linux,
  autoPatchelfHook,
  fetchurl,
}:

pkgsi686Linux.stdenv.mkDerivation {
  pname = "dreamluau";
  version = "0.1.2";
  src = fetchurl {
    url = "https://github.com/tgstation/dreamluau/releases/download/0.1.2/libdreamluau.so";
    hash = "sha256-rLqrLqqqAkbG+RsYxH/nFpe51yfsP7KTfzs3iwetGlU=";
  };
  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ pkgsi686Linux.stdenv.cc.cc.lib ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib"
    cp "$src" "$out/lib/libdreamluau.so"
    chmod +w "$out/lib/libdreamluau.so"
    runHook postInstall
  '';
  meta = {
    description = "Dreamluau BYOND extension (i686)";
    homepage = "https://github.com/tgstation/dreamluau";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
