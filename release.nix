/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build release.nix -A <jobname>.<system>

   e.g.

   $ nix-build release.nix -A ruby-overlay.interpreters.ruby_1_8_7.x86_64-linux
*/

{ nixpkgs ? <nixpkgs>
, release ? "pkgs/top-level/release.nix"
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
, nixpkgsArgs ? {
    config = { allowUnfree = false; inHydra = true; };
    overlays = [ (import ./ruby-overlay.nix) ];
  }
}:

let
  jobs = import (builtins.toString nixpkgs + "/" + release) { inherit officialRelease supportedSystems scrubJobs nixpkgsArgs; };
in
  { inherit (jobs) ruby-overlay; }
