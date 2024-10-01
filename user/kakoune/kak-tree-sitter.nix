{ pkgs, lib, ... }:
let
  hx-src = pkgs.helix.src;
  kts-src = pkgs.unstable.kak-tree-sitter-unwrapped.src;
  inherit (pkgs) fetchFromGitHub;
in
with pkgs.tree-sitter-grammars;
{
  xdg.configFile."kak-tree-sitter/config.toml".text =
    lib.foldlAttrs
      (
        acc: name: vals:
        acc
        + ''
          [language.${name}.grammar.source.local]
          path = "${vals.parser}"
          [language.${name}.grammar]
          compile = "cc"
          compile_args = ["-c", "-fpic", "../scanner.c", "../parser.c", "-I", ".."]
          compile_flags = ["-O3"]
          link = "cc"
          link_args = ["-shared", "-fpic", "scanner.o", "parser.o", "-o", "typescript.so"]
          link_flags = ["-O3"]
          [language.${name}.queries.source.local]
          path = "${vals.queries}"
          [language.${name}.queries]
          path = "${vals.queries}"
        ''
      )
      ""
      {
        nix = {
          parser = tree-sitter-nix + "/parser";
          queries = tree-sitter-nix + "/queries";
        };

        scss = {
          parser = tree-sitter-scss + "/parser";
          queries = tree-sitter-scss + "/queries";
        };
        css = {
          parser = tree-sitter-css + "/parser";
          queries = tree-sitter-css + "/queries";
        };

        javascript = {
          parser = tree-sitter-javascript + "/parser";
          queries = tree-sitter-javascript + "/queries";
        };
        typescript = {
          parser =
            tree-sitter-typescript.overrideAttrs (old: {
              src = fetchFromGitHub {
                owner = "tree-sitter";
                repo = "tree-sitter-typescript";
                rev = "b1bf4825d9eaa0f3bdeb1e52f099533328acfbdf";
                hash = "sha256-oZKit8kScXcOptmT2ckywL5JlAVe+wuwhuj6ThEI5OQ=";
              };
            })
            + "/parser";
          queries = kts-src + "/runtime/queries/typescript";
        };
      };
}
