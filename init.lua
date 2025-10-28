-- https://github.com/alacritty/alacritty/issues/862
--


-- c+space --> alacritty
hs.hotkey.bind({"ctrl"}, "space", function()
  local alacritty = hs.application.get('ghostty')
  if (alacritty ~= nil and alacritty:isFrontmost()) then
    alacritty:hide()
  else
    hs.application.launchOrFocus("/Applications/Ghostty.app")
  end
end)

-- reload this file
hs.hotkey.bind({"ctrl", "shift"}, "r", function()
  hs.reload()
end)

-- numpad --> pcalc

hs.hotkey.bind({}, 'F16', function()
  local app = hs.application.get('pcalc')
  if (app ~= nil and app:isFrontmost()) then
    app:hide()
  else
    hs.application.launchOrFocus("/Applications/PCalc.app")
  end
end)

