{config, ...}: {
  #Theme
  # nerd-fonts.jetbrains-mono
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      app = {
        livePreview = false;
        showInlineTitle= false;
        propertiesInDocument = "source";
        alwaysUpdateLinks= true;
        autoPairMarkdown= false;
        promptDelete = false;
      };
      appearance = {
        showRibbon = true;
      };
      communityPlugins = [ "obsidian-linter" "obsidian-git" ];
      # corePlugins = {};
      # hotkeys = {};
      themes = [ "Material Gruvbox" "Tokyo Night" ];
    };
  };
}
