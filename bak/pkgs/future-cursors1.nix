{ lib, stdenvNoCC, fetchFromGitHub, inkscape, xorg
, variant ? "svg" # options: "svg", "svg_dark", "svg_black", "svg_cyan"
}:

let
  variantNames = {
    "svg"       = "Future-cursors";
    "svg_dark"  = "Future-cursors-dark";
    "svg_black" = "Future-cursors-black";
    "svg_cyan"  = "Future-cursors-cyan";
  };
  themeName = variantNames.${variant} or (throw "future-cursors: unknown variant '${variant}'. Must be one of: ${lib.concatStringsSep ", " (lib.attrNames variantNames)}");
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "future-cursors";
  version = "unstable-2020-02-18";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Future-cursors";
    rev = "master";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ inkscape xorg.xcursorgen ];

  buildPhase = ''
    runHook preBuild

    SRC=$PWD/src
    THEME="${themeName}"

    cd "$SRC"
    mkdir -p x1 x1_25 x1_5 x2

    cd "$SRC"/${variant}
    find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1/${0%.svg}.png" -w 32 -h 32 $0' {} \;
    find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1_25/${0%.svg}.png" -w 40 -h 40 $0' {} \;
    find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../x1_5/${0%.svg}.png" -w 48 -h 48 $0' {} \;
    find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../x2/${0%.svg}.png" -w 64 -h 64 $0' {} \;

    cd "$SRC"
    BUILD="$SRC"/../dist
    OUTPUT="$BUILD"/cursors
    mkdir -p "$OUTPUT"

    for CUR in config/*.cursor; do
      BASENAME="$CUR"
      BASENAME="${BASENAME##*/}"
      BASENAME="${BASENAME%.*}"
      xcursorgen "$CUR" "$OUTPUT/$BASENAME"
    done

    cd "$OUTPUT"
    while read ALIAS; do
      FROM="${ALIAS#* }"
      TO="${ALIAS% *}"
      if [ -e "$TO" ]; then
        continue
      fi
      ln -sr "$FROM" "$TO"
    done < "$SRC/cursorList"

    INDEX="$OUTPUT/../index.theme"
    echo -e "[Icon Theme]\nName=$THEME\n" > "$INDEX"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r dist $out/share/icons/${themeName}
    runHook postInstall
  '';

  meta = {
    description = "Future cursor theme for Linux desktops, inspired by macOS";
    homepage = "https://github.com/yeyushengfan258/Future-cursors";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
