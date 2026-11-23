{
  lib,
  buildTypstPackage,
  fetchFromGitHub,
  typstPackages,
}:

buildTypstPackage (finalAttrs: {
  pname = "math-templates";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Chris022";
    repo = "math-templates";
    rev = "86f4f81f4b0d2fac77499e34741e8d2805117ca2";
    hash = "sha256-ZCn9omYmiOdGdfe3btGTTmbPdnwsOvhf32MUWfmD21c=";
  };

  typstDeps = with typstPackages; [ ouset_0_2_0 ];

  meta = {
    homepage = "https://github.com/Chris022/math-templates";
    description = "Typst templates specifically made for writing math notes at Goethe Univiserty";
    license = lib.licenses.gpl3Only;
  };
})
