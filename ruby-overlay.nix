self: super:

let
  inherit (super) callPackage recurseIntoAttrs;
in

{
  ruby-overlay = recurseIntoAttrs rec {
    interpreters = recurseIntoAttrs {
      ruby_1_8_7 = callPackage ./ruby-1.8.7/ruby.nix {};
    };

    packages = recurseIntoAttrs {
      ruby_1_8_7 = recurseIntoAttrs rec {
        ruby = interpreters.ruby_1_8_7;
        rubygems = callPackage ./ruby-1.8.7/rubygems.nix { inherit ruby; };
        buildRubyGem = callPackage ./ruby-1.8.7/build-gem.nix { inherit ruby rubygems; };

        bundler = super.bundler.override { inherit ruby buildRubyGem; };
      };
    };
  };

  buildRubyGem_1_8_7 = self.ruby-overlay.packages.ruby_1_8_7.buildRubyGem;
  ruby_1_8_7 = self.ruby-overlay.packages.ruby_1_8_7.ruby;
  rubygems = self.ruby-overlay.packages.ruby_1_8_7.rubygems;
}
