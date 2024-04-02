{ stdenvNoCC
, lib
, fetchFromGitHub
, lutgen
, version
, base00 ? "262626"
, base01 ? "3a3a3a"
, base02 ? "4e4e4e"
, base03 ? "8a8a8a"
, base04 ? "949494"
, base05 ? "dab997"
, base06 ? "d5c4a1"
, base07 ? "ebdbb2"
, base08 ? "d75f5f"
, base09 ? "ff8700"
, base0A ? "ffaf00"
, base0B ? "afaf00"
, base0C ? "85ad85"
, base0D ? "83adad"
, base0E ? "d485ad"
, base0F ? "d65d0e"
}:
stdenvNoCC.mkDerivation {
  pname = "ndct-sddm-corners";
  version = version;

  src = fetchFromGitHub {
    owner = "id3v1669";
    repo = "ndct-sddm-corners";
    rev = "";
    hash = "";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = 
  let 
    gp = "$out/share/sddm/themes/ndct";
    wn = "default.png";
  in
  ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes/
    cp -r ndct/ $out/share/sddm/themes/
    sed -i "s/d75f5f/${base08}/g" ${gp}/icons/power.svg
    sed -i "s/83adad/${base0D}/g" ${gp}/icons/restart.svg
    sed -i "s/ffaf00/${base0A}/g" ${gp}/icons/sleep.svg
    sed -i "s/d5c4a1/${base06}/g" ${gp}/theme.conf
    sed -i "s/ebdbb2/${base07}/g" ${gp}/theme.conf
    sed -i "s/3a3a3a/${base01}/g" ${gp}/theme.conf

    rm -rf ${gp}/backgrounds/colored/*
    ${lutgen}/bin/lutgen apply ${gp}/backgrounds/ -o ${gp}/backgrounds/colored -- "#ABCDEF" ${base01} ${base04} ${base05} ${base06} ${base07} ${base08} ${base09} ${base0A} ${base0B} ${base0C} ${base0D} ${base0E} ${base0F}
    sed -i "s/default.png/${wn}/g" ${gp}/theme.conf

    runHook postInstall
  '';

  meta = {
    description = "Dynamic Color theme for SDDM";
    homepage = "https://github.com/id3v1669/ndct-sddm-corners";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ id3v1669 ];
    platforms = lib.platforms.linux;
  };
}