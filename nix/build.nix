{
  stdenv,
  libGLU,
  pkg-config,
  qmake4Hook,
  qt4,
}:
stdenv.mkDerivation {
  pname = "cosmographia";
  version = "1.0.0";

  src = ./..;

  buildInputs = [
    libGLU
    pkg-config
    qt4
  ];

  nativeBuildInputs = [qmake4Hook];

  installPhase = ''
    mkdir -p $out/bin
    cp build/Cosmographia $out/bin/
    cp -r data/ $out/
  '';
}
