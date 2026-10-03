{ ... }:
let
  sharedSettings = {
    "browser.startup.page" = 3;

    "browser.search.defaultenginename" = "DuckDuckGo";

    "signon.rememberSignons" = false;

    "browser.startup.homepage" = "about:home";
    "browser.newtabpage.activity-stream.showSearch" = true;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "browser.discovery.enabled" = false;
    "extensions.pocket.enabled" = false;

    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "media.ffmpeg.vaapi.enabled" = true;
    "gfx.webrender.all" = true;

    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;

    "browser.toolbars.bookmarks.visibility" = "always";

    "browser.uiCustomization.state" = builtins.toJSON {
      placements = {
        widget-overflow-fixed-list = [];
        unified-extensions-area = [
          "myallychou_gmail_com-browser-action"
          "enhancerforyoutube_maximerf_addons_mozilla_org-browser-action"
          "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
          "xifangczy_gmail_com-browser-action"
          "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
          "addon_darkreader_org-browser-action"
        ];
        nav-bar = [
          "back-button"
          "forward-button"
          "stop-reload-button"
          "customizableui-special-spring1"
          "urlbar-container"
          "customizableui-special-spring2"
          "downloads-button"
          "ublock0_raymondhill_net-browser-action"
          "unified-extensions-button"
        ];
        toolbar-menubar = [ "menubar-items" ];
        TabsToolbar = [];
        vertical-tabs = [ "tabbrowser-tabs" ];
        PersonalToolbar = [ "personal-bookmarks" ];
      };
      seen = [ "ublock0_raymondhill_net-browser-action" ];
      dirtyAreaCache = [ "nav-bar" "vertical-tabs" "PersonalToolbar" "toolbar-menubar" "TabsToolbar" "unified-extensions-area" ];
      currentVersion = 26;
      newElementCount = 0;
    };

    "browser.uiCustomization.navBarWhenVerticalTabs" = builtins.toJSON [
      "back-button"
      "forward-button"
      "stop-reload-button"
      "customizableui-special-spring1"
      "urlbar-container"
      "customizableui-special-spring2"
      "downloads-button"
      "ublock0_raymondhill_net-browser-action"
      "unified-extensions-button"
    ];
  };
in
{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSponsoredTopSites = true;
      PromptForDownloadLocation = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = false;
      };

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        "myallychou@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
          installation_mode = "force_installed";
        };

        "enhancerforyoutube@maximerf.addons.mozilla.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/latest.xpi";
          installation_mode = "force_installed";
        };

        "xifangczy@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/cat-catch/latest.xpi";
          installation_mode = "force_installed";
        };

        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
          installation_mode = "force_installed";
        };

        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = sharedSettings;
      };

      secondary = {
        id = 1;
        name = "secondary";
        isDefault = false;
        settings = sharedSettings;
      };
    };
  };

  xdg.desktopEntries.firefox-secondary = {
    name = "Firefox (Secondary)";
    genericName = "Web Browser";
    exec = "firefox -P secondary --no-remote %U";
    icon = "firefox";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" ];
  };
}
