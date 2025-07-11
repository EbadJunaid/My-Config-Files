local wezterm = require 'wezterm'

local config = {}

-- Theme with custom selection colors
config.color_scheme = "Catppuccin Mocha"

-- Force override selection colors to match Alacritty
config.colors = {
  selection_fg = '#000000',     -- Pure white text
  selection_bg = '#F5E0DC',     -- Bright blue like Alacritty
  
  -- Alternative: Try these if above doesn't work
  -- selection_bg = '#4285f4',  -- Google blue
  -- selection_bg = '#0078d4',  -- Microsoft blue
  -- selection_bg = '#007acc',  -- VS Code blue
}

-- Font (Ubuntu Mono)
config.font = wezterm.font({
  family = "Monospace",
  weight = "Regular",
})
config.font_size = 18.0

-- Window
config.enable_tab_bar = false
config.hide_mouse_cursor_when_typing = true
config.scrollback_lines = 10000

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Cursor with better visibility
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600    -- Slower blink (800ms total cycle)
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_thickness = 1.5

-- Image preview support
config.enable_kitty_graphics = true

-- Shell
config.default_prog = { "/bin/bash" }



-- Smart key bindings
config.keys = {
  -- Smart Copy: Ctrl+C → copy if text is selected, else send ^C
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
      else
        window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
      end
    end),
  },

  -- Ctrl+V → paste
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom("Clipboard"),
  },

  -- Ctrl+Shift+C → force kill (^C)
  {
    key = "C",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendString("\x03"),
  },

  -- Terminal Search
  {
    key = "f",
    mods = "CTRL",
    action = wezterm.action.Search("CurrentSelectionOrEmptyString")
  },

  -- Font size
  { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

  -- Scrolling
  { key = "UpArrow", mods = "CTRL", action = wezterm.action.ScrollToTop },
  { key = "DownArrow", mods = "CTRL", action = wezterm.action.ScrollToBottom },
}

return config