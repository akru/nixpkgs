{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "licensor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "raftario";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zr8hcq7crmhrdhwcclc0nap68wvg5kqn5l93ha0vn9xgjy8z11p";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/raftario/licensor/commit/77ae1ea6d9b6de999ee7590d9dbd3c8465d70bb6.patch";
    sha256 = "0kfyg06wa2v7swm7hs9kkazjg34mircd4nm4qmljyzjh2yh8icg3";
  })];

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "042dplm0cdxkv73m5qlkc61h0x9fpzxn2b0c8gjx2hwvigcia139";

  meta = with lib; {
    description = "Write licenses to stdout";
    homepage = "https://github.com/raftario/licensor";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
