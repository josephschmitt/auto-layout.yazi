-- Auto-Layout Yazi Plugin
--
-- This plugin will automatically change the number of columns to show in yazi based on the
-- available width. This is especially useful if you use a terminal layout that might have
-- yazi run in a sidebar (where 1 column is all that's required) but then sometimes zoom into it
-- and you want it to update to use the full 3 column layout.
--
-- Usage:
--   In your init.lua file for yazi
--
--   require("auto-layout")
--
--   If you want to customize the breakpoints where the column shifts happen:
--
--   require("auto-layout").setup({
--     breakpoint_large = 110,  -- new large window threshold, defaults to 100
--     breakpoint_medium = 60,  -- new medium window threshold, defaults to 50
--   })

local config = {
  breakpoint_large = 100,  -- default large window threshold
  breakpoint_medium = 50, -- default medium window threshold
}

local M = {}

local function layout_ratio()
  local ratio = (rt and rt.mgr and rt.mgr.ratio)
    or (MANAGER and MANAGER.ratio)

  if ratio and ratio.parent and ratio.current and ratio.preview and ratio.all then
    return ratio
  end

  -- fall back to default ratio: [1, 4, 3]
  return { parent = 1, current = 4, preview = 3, all = 8 }
end

function M.setup(user_config)
  if type(user_config) == "table" then
    for k, v in pairs(user_config) do
      config[k] = v
    end
  end
end

function Tab:layout()
  local ratio = layout_ratio()
  local w = self._area.w

  if w > config.breakpoint_large then
    self._chunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
        ui.Constraint.Ratio(ratio.parent,  ratio.all),
        ui.Constraint.Ratio(ratio.current, ratio.all),
        ui.Constraint.Ratio(ratio.preview, ratio.all),
      })
      :split(self._area)
  elseif w > config.breakpoint_medium then
    self._chunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
        ui.Constraint.Ratio(0, ratio.all),
        ui.Constraint.Ratio(ratio.current + ratio.parent, ratio.all),
        ui.Constraint.Ratio(ratio.preview + ratio.parent, ratio.all),
      })
      :split(self._area)
  else
    self._chunks = ui.Layout()
      :direction(ui.Layout.HORIZONTAL)
      :constraints({
        ui.Constraint.Ratio(0, ratio.all),
        ui.Constraint.Ratio(ratio.all, ratio.all),
        ui.Constraint.Ratio(0, ratio.all),
      })
      :split(self._area)
  end
end

return M

