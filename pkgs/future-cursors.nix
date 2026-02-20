{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "future-cursors";
  version = "unstable-2020-02-18";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Future-cursors";
    rev = "master";
    hash = "sha256-ziEgMasNVhfzqeURjYJK1l5BeIHk8GK6C4ONHQR7FyY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r dist $out/share/icons/Future-cursors
    runHook postInstall
  '';

  meta = {
    description = "Future cursor theme for Linux desktops, inspired by macOS";
    homepage = "https://github.com/yeyushengfan258/Future-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ]; # add yourself if upstreaming to nixpkgs
  };
})
