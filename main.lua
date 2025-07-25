--- @since 25.1.0

local M = {}

local config = {
  breakpoint_large = 100,
  breakpoint_medium = 50,
}

function M.setup(opts)
  opts = opts or {}
  
  if type(opts.breakpoint_large) == "number" then
    config.breakpoint_large = opts.breakpoint_large
  end
  if type(opts.breakpoint_medium) == "number" then
    config.breakpoint_medium = opts.breakpoint_medium
  end
  
  local old_layout = Tab.layout
  function Tab:layout()
    local w = self._area.w

    if w > config.breakpoint_large then
      self._chunks = ui.Layout()
        :direction(ui.Layout.HORIZONTAL)
        :constraints({
          ui.Constraint.Ratio(MANAGER.ratio.parent,  MANAGER.ratio.all),
          ui.Constraint.Ratio(MANAGER.ratio.current, MANAGER.ratio.all),
          ui.Constraint.Ratio(MANAGER.ratio.preview, MANAGER.ratio.all),
        })
        :split(self._area)
    elseif w > config.breakpoint_medium then
      self._chunks = ui.Layout()
        :direction(ui.Layout.HORIZONTAL)
        :constraints({
          ui.Constraint.Ratio(1, 4),
          ui.Constraint.Ratio(2, 4),
          ui.Constraint.Ratio(1, 4),
        })
        :split(self._area)
    else
      self._chunks = ui.Layout()
        :direction(ui.Layout.HORIZONTAL)
        :constraints({
          ui.Constraint.Ratio(0, 1),
          ui.Constraint.Ratio(1, 1),
          ui.Constraint.Ratio(0, 1),
        })
        :split(self._area)
    end
  end
end

return M

