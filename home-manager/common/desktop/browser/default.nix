{pkgs, ...}: {
  home.file.".mozilla/firefox/ignore-dev-edition-profile".text = "";

  programs.qutebrowser = {
    enable = true;
    settings = {
      url = {
        start_pages = ["https://startpage.com"];
        default_page = "https://startpage.com";
      };
      auto_save.session = true;
      colors.webpage.preferred_color_scheme = "dark";
      content = {
        pdfjs = true;
        blocking.method = "both";
        autoplay = false;
      };
    };
    searchEngines = {
      DEFAULT = "https://startpage.com/search?q={}";
    };
  };

  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf-bin;
    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        canvasblocker
        darkreader
        sponsorblock
        ublock-origin
        zotero-connector
      ];
      settings = {
        "webgl.disabled" = false;
        "app.update.auto" = false;
        "general.autoScroll" = true;
        "middlemouse.paste" = false;
        "layout.spellcheckDefault" = 0;
        "extensions.autoDisableScopes" = 0; # auto-enable
        "devtools.toolbox.host" = "window";
        "extensions.update.enabled" = false;
        "extensions.pocket.enabled" = false;
        "browser.translations.enable" = false;
        "xpinstall.signatures.required" = false;
        "browser.aboutConfig.showWarning" = false;
        "media.videocontrols.picture-in-picture.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
      };
      userChrome = ''
        @media (-moz-bool-pref: "browser.fullscreen.autohide"),
                -moz-pref("browser.fullscreen.autohide") {
          :root{
            --uc-fullscreen-overlay-duration: 82ms;
            --uc-fullscreen-overlay-delay: 0ms;
          }
          :root[sizemode="fullscreen"]{
            &[sessionrestored]{
              #urlbar[popover]{
                pointer-events: none;
                opacity: 0;
                transition: transform var(--uc-fullscreen-overlay-duration) ease-in-out var(--uc-fullscreen-overlay-delay), opacity 0ms calc(var(--uc-fullscreen-overlay-delay) + 82ms);
                transform: translateY(calc(0px - var(--tab-min-height) - (var(--tab-block-margin) * 2) - var(--urlbar-container-height)));
              }
            }
            #navigator-toolbox{
              position: fixed !important;
              width: 100vw;
              z-index: 10 !important;
              transition: transform var(--uc-fullscreen-overlay-duration) ease-in-out var(--uc-fullscreen-overlay-delay) !important;
              margin-top: 0 !important;
              transform: translateY(-100%);
            }
            #navigator-toolbox:is(:hover,:focus-within,[style=""]),
            #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#selection-shortcut-action-panel,#chat-shortcuts-options-panel,#tab-preview-panel)) ~ #navigator-toolbox{
              transition-delay: 0ms !important;
              transform: translateY(0);
            }
            #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#selection-shortcut-action-panel,#chat-shortcuts-options-panel,#tab-preview-panel)) ~ toolbox #urlbar[popover],
            #navigator-toolbox:is(:hover,:focus-within,[style=""]) #urlbar[popover],
            #urlbar-container > #urlbar[popover]:is([focused],[open]){
              pointer-events: auto;
              opacity: 1;
              transition-delay: 0ms;
              transform: translateY(0);
            }
          }
        }
      '';
    };
  };
}
