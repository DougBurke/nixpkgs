{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection, gnome3 }:
let
  pname = "libgee";
  version = "0.20.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1fy24dr8imrjlmsqj1syn0gi139gba6hwk3j5vd6sr3pxniqnc11";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  nativeBuildInputs = [ pkgconfig autoconf vala gobjectIntrospection ];
  buildInputs = [ glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
