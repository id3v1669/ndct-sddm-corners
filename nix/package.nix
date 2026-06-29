{ lib
, stdenvNoCC
, lutgen
, qt5
, qt6
, version
, qtVersion ? 6
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
let
  themeSrc = if qtVersion == 6 then "ndct-qt6" else "ndct-qt5";
  qtDeps =
    if qtVersion == 6
    then (with qt6; [ qtdeclarative qtsvg ])
    else (with qt5; [ qtgraphicaleffects qtquickcontrols2 qtsvg ]);
in
stdenvNoCC.mkDerivation {
  pname = "ndct-sddm-corners";
  version = version;

  src = lib.cleanSource ./..;

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  propagatedBuildInputs = qtDeps;

  postFixup = ''
    mkdir -p $out/nix-support
    for dep in ${lib.concatStringsSep " " (map toString qtDeps)}; do
      echo "$dep" >> $out/nix-support/propagated-user-env-packages
    done
  '';

  installPhase =
  let
    gp = "$out/share/sddm/themes/ndct";
    wn = "default.png";
  in
  ''
    runHook preInstall

    mkdir -p ${gp}
    cp -r ${themeSrc}/. ${gp}/
    mkdir -p ${gp}/backgrounds/colored

    cat > ${gp}/metadata.desktop <<EOF
    [SddmGreeterTheme]
    Name=ndct
    Description=Nix Dynamic Color Theme for SDDM
    Author=id3v1669
    License=MIT
    Type=sddm-theme
    Version=${version}
    Theme-Id=ndct
    Theme-API=2.0
    QtVersion=${toString qtVersion}
    MainScript=Main.qml
    ConfigFile=theme.conf
    EOF

    sed -i "s/d75f5f/${base08}/g" ${gp}/icons/power.svg
    sed -i "s/83adad/${base0D}/g" ${gp}/icons/restart.svg
    sed -i "s/ffaf00/${base0A}/g" ${gp}/icons/sleep.svg
    sed -i "s/d5c4a1/${base06}/g" ${gp}/theme.conf
    sed -i "s/ebdbb2/${base07}/g" ${gp}/theme.conf
    sed -i "s/3a3a3a/${base01}/g" ${gp}/theme.conf

    ${lutgen}/bin/lutgen apply ${gp}/backgrounds/${wn} -o ${gp}/backgrounds/colored -- "#ABCDEF" ${base01} ${base04} ${base05} ${base06} ${base07} ${base08} ${base09} ${base0A} ${base0B} ${base0C} ${base0D} ${base0E} ${base0F}
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
