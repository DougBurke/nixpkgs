{ stdenv, fetchFromGitHub, fetchpatch
, boost, zlib, openssl
, upnpSupport ? true, miniupnpc ? null
, aesniSupport ? false
, avxSupport ? false
}:

assert upnpSupport -> miniupnpc != null;

stdenv.mkDerivation rec {

  name = pname + "-" + version;
  pname = "i2pd";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = pname;
    rev = version;
    sha256 = "019psm86n4k7nzxhw7cnbw144gqni59sf35wiy58a6x6dabmvq8h";
  };

  buildInputs = with stdenv.lib; [ boost zlib openssl ]
    ++ optional upnpSupport miniupnpc;
  makeFlags =
    let ynf = a: b: a + "=" + (if b then "yes" else "no"); in
    [ (ynf "USE_AESNI" aesniSupport)
      (ynf "USE_AVX"   avxSupport)
      (ynf "USE_UPNP"  upnpSupport)
    ];

  installPhase = ''
    install -D i2pd $out/bin/i2pd
  '';

  meta = with stdenv.lib; {
    homepage = https://i2pd.website;
    description = "Minimal I2P router written in C++";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
