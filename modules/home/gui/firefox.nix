{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.firefox;
in {
  options = {
    aidan.gui.firefox.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the firefox browser";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;

          # Search Engines
          search = {
            force = true; # This should be `true` so we fully wipe firefox every `just home`.
            # idk how to kill "This time, search with..." popup programmatically
            # so it's a bit annoying. mozilla removed "browser.urlbar.oneOffSearches"
            default = "ddg";
            engines = {
              "bing".metadata.hidden = true; # TODO: These don't seem to work
              "wikipedia".metadata.hidden = true;

              "MyNixOS" = {
                urls = [
                  {
                    template = "https://mynixos.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@mynix"];
              };

              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@nixpkgs"];
              };

              "Home Manager" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@hm"];
              };
            };
          };

          # Firefox settings
          settings = {
            # Appearance
            "general.smoothScroll" = false;
            "layout.css.always_underline_links" = true;
            "layout.css.prefers-color-scheme.content-override" = 0; # prefer dark theme
            "browser.tabs.hoverPreview.showThumbnails" = false;
            "widget.gtk.overlay-scrollbars.enabled" = false;
            "extensions.ui.dictionary.hidden" = true;
            "extensions.ui.lastCategory" = "addons://list/extension";
            "extensions.ui.locale.hidden" = true;
            "extensions.ui.sitepermission.hidden" = true;

            # New tab
            "browser.newtabpage.enabled" = false;
            "browser.urlbar.placeholderName.private" = "DuckDuckGo";
            "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSearch" = false;

            # Behavior
            "extensions.autoDisableScopes" = 0; # Auto-enable extensions
            "accessibility.browsewithcaret" = true;
            "accessibility.typeaheadfind.flashBar" = 0;
            "browser.aboutwelcome.didSeeFinalScreen" = true;
            "browser.aboutConfig.showWarning" = false;
            "browser.download.dir" = "/tmp/Downloads";
            "browser.download.folderList" = 2;
            "browser.bookmarks.restore_default_bookmarks" = false;
            # https://support.mozilla.org/en-US/questions/1249212
            "browser.startup.homepage_override.mstone" = "ignore";

            # Autofill
            "signon.autofillForms" = false;
            "signon.autofillForms.autocompleteOff" = true;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;

            # Privacy
            # TODO: https://amiunique.org/fingerprint
            "datareporting.healthreport.uploadEnabled" = false;
            "browser.ml.chat.enabled" = false; # No
            "privacy.annotate_channels.strict_list.enabled" = true;
            "privacy.bounceTrackingProtection.mode" = 1;
            "privacy.donottrackheader.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.globalprivacycontrol.enabled" = true;
            "privacy.globalprivacycontrol.was_ever_enabled" = true;
            "privacy.query_stripping.enabled" = true;
            "privacy.query_stripping.enabled.pbmode" = true;
            "privacy.trackingprotection.emailtracking.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "signon.management.page.breach-alerts.enabled" = false;
            "signon.rememberSignons" = false;

            # Security
            "browser.contentblocking.category" = "strict";
            "dom.security.https_only_mode_pbm" = true;
            "network.cookie.cookieBehavior.optInPartitioning" = true;
            "network.dns.disablePrefetch" = true;
            "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
            "network.http.speculative-parallel-limit" = 0;
            "network.predictor.enabled" = false;
            "network.prefetch-next" = false;
            "network.proxy.type" = 0;
            "extensions.webcompat.enable_shims" = true;
            "extensions.webcompat.perform_injections" = true;
            "extensions.webcompat.perform_ua_overrides" = true;
          };

          # Setup extensions: https://gitlab.com/rycee/nur-expressions/-/tree/master
          # https://nur.nix-community.org/repos/rycee/
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            youtube-shorts-block
            skip-redirect
            privacy-badger
          ];
        };
      };

      # This might be a way to dynamically allow extensions in private windows,
      # but it doesn't seem to work for me for some reason...
      #policies = {
      #  # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
      #  # uBlock Origin
      #  "uBlock0@raymondhill.net" = {
      #    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      #    installation_mode = "forced_install";
      #    permissions = ''
      #      [
      #        "internal:privateBrowsingAllowed"
      #      ]
      #    '';
      #  };
      #};
    };
  };
}
