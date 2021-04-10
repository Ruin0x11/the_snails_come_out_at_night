local Event = require("api.Event")

local function init_save()
   local s = save.the_snails_come_out_at_night
   s.the_snails_come_out = false
end

Event.register("base.on_init_save", "Init save (the_snails_come_out_at_night)", init_save)
