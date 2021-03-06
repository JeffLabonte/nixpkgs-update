{ nixpkgs-tarball ? builtins.fetchTarball {
  name = "nixpkgs-unstable";
  url =
    "https://releases.nixos.org/nixos/unstable/nixos-20.03pre193829.f0fec244ca3/nixexprs.tar.xz";
  sha256 = "03iqwyz5lxaq4k2hw4wfd55gizdf1230jcsqia0zmp3whpyj5y1x";
}, pkgs ? import nixpkgs-tarball { config = { allowBroken = true; }; }
, returnShellEnv ? pkgs.lib.inNixShell }:

let

  compiler = pkgs.haskell.packages."ghc865";

  inherit (pkgs.haskell.lib) dontCheck doJailbreak overrideCabal;

  pkg = compiler.developPackage {
    root = ./.;
    overrides = self: super: {
      aeson = dontCheck super.aeson;
      polysemy = dontCheck super.polysemy_1_2_1_0;
      polysemy-plugin = dontCheck super.polysemy-plugin;
      time-compat = dontCheck super.time-compat;
      binary-orphans = dontCheck super.binary-orphans;
      binary-instances = dontCheck super.binary-instances;
      hpack = dontCheck super.hpack;
      HUnit = dontCheck super.HUnit;
      hspec-core = dontCheck super.hspec-core;
      th-abstraction = dontCheck super.th-abstraction;
      inspection-testing = dontCheck super.inspection-testing;
      partial-order = doJailbreak super.partial-order;
    };
    source-overrides = { };
    inherit returnShellEnv;
  };

in pkg.overrideAttrs (attrs: {
  propagatedBuildInputs = with pkgs; [
    nix
    git
    getent
    gitAndTools.hub
    jq
    tree
    gist
  ];
})
