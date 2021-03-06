{ stdenv, fetchFromGitHub, writeText, elixir }:

let
  shell = drv: stdenv.mkDerivation {
    name = "interactive-shell-${drv.name}";
    buildInputs = [ drv ];
  };

  pkg = self: stdenv.mkDerivation rec {
    pname = "hex";
    version = "0.20.5";

    src = fetchFromGitHub {
      owner = "hexpm";
      repo = "hex";
      rev = "v${version}";
      sha256 = "1wz6n4qrmsb4kkww6lrdbs99xzwp4dyjjmr8m4drcwn3sd2k9ba6";
    };

    setupHook = writeText "setupHook.sh" ''
       addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
    '';

    dontStrip = true;

    buildInputs = [ elixir ];

    buildPhase = ''
      runHook preBuild
      export HEX_OFFLINE=1
      export HEX_HOME=./
      export MIX_ENV=prod
      mix compile
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/erlang/lib
      cp -r ./_build/prod/lib/hex $out/lib/erlang/lib/

      runHook postInstall
    '';

    meta = {
      description = "Package manager for the Erlang VM https://hex.pm";
      license = stdenv.lib.licenses.mit;
      homepage = https://github.com/hexpm/hex;
      maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    };

    passthru = {
      env = shell self;
    };
};
in stdenv.lib.fix pkg
