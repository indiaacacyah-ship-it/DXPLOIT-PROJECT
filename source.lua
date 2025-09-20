
-- Rayfield Source.lua (Mirror Placeholder)
-- This is the Rayfield UI Library source code that you need to upload to GitHub for your mirror.
-- To get the latest version, copy the contents of:
-- https://github.com/shlexware/Rayfield/blob/main/source.lua
-- and paste into this file, replacing everything here.

return {
    CreateWindow = function(options)
        warn("Rayfield placeholder loaded. Please upload the actual Rayfield source.lua code.")
        local Window = {}
        function Window:CreateTab(name, icon)
            return {
                CreateButton = function(_,cb) return cb end,
                CreateToggle = function(_,cb) return cb end,
                CreateSlider = function(_,cb) return cb end,
                CreateDropdown = function(_,cb) return cb end,
                CreateInput = function(_,cb) return cb end,
                CreateColorPicker = function(_,cb) return cb end
            }
        end
        return Window
    end,
    Notify = function(tbl)
        warn("Rayfield Notify: "..(tbl.Title or "").." - "..(tbl.Content or ""))
    end
}
