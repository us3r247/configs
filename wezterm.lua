local wezterm = require 'wezterm'
local config = wezterm.config_builder() -- Better for performance in newer versions

config = {
  -- --- Performance Tweaks ---
  max_fps = 144, -- Higher FPS makes scrolling feel "snappier"
  animation_fps = 1,
  webgpu_power_preference = "HighPerformance",
  front_end = "WebGpu", -- Faster than default on most modern systems
  
  -- Disable ligatures for raw speed (as you had with harfbuzz_features)
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  -- --- Font ---
  font = wezterm.font_with_fallback {
    "JetBrains Mono",
    "Symbols Nerd Font Mono",
    "Noto Color Emoji"
  },
  font_size = 11.0,
  adjust_window_size_when_changing_font_size = false,

  -- --- Window/UI settings ---
  window_decorations = "RESIZE",
  window_background_opacity = 1.0, -- Opacity < 1.0 slows down rendering
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  show_new_tab_button_in_tab_bar = true,
  enable_scroll_bar = false,
  tab_bar_at_bottom = false,
  initial_rows = 27,
  initial_cols = 100,

  -- --- Colors (Preserving your exact OLED theme) ---
  colors = {
  background = "#000000",     -- OLED black
  foreground = "#e0e6f5",     -- soft steel

  ansi = {
    "#2b2d3f", -- black
    "#b9474f", -- richer crimson red ← updated
    "#3fa24f", -- richer foliage green ← updated
    "#d6883d", -- ochre yellow
    "#4770c0", -- ultramarine blue
    "#a46cc9", -- clean lavender-magenta
    "#4ccac3", -- ocean teal
    "#9da2ba", -- gray-lavender white
  },

  brights = {
    "#34364b", -- black bright
    "#cb5e66", -- brighter crimson (warm rose)
    "#54be60", -- vivid leaf green
    "#dea656", -- warm peach
    "#6182e0", -- cobalt blue
    "#bd84e6", -- vibrant lavender
    "#70e6df", -- mint aqua
    "#bbc1d8", -- soft cool white
  },

  tab_bar = {
    background = "#1e1e2e",
    active_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#a7cfff",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#737799",
    },
    new_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#a7cfff",
    },
  },
},
}

return config
