-- https://github.com/alacritty/alacritty/issues/862

hs.hotkey.bind({"ctrl"}, "space", function()
  local alacritty = hs.application.get('alacritty')
  if (alacritty ~= nil and alacritty:isFrontmost()) then
    alacritty:hide()
  else
    hs.application.launchOrFocus("/Applications/Alacritty.app")
  end
end)
