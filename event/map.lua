local Gui = require("api.Gui")
local Event = require("api.Event")
local Chara = require("api.Chara")
local Advice = require("api.Advice")

local function it_is_night(map)
   local hour = save.base.date.hour

   return not map:calc("is_indoor")
      and (hour >= 21 or hour < 6)
end

local function the_snails_come_out(map)
   local s = save.the_snails_come_out_at_night
   local enabled = s.the_snails_come_out
   if enabled then
      return
   end

   s.the_snails_come_out = true
   Gui.play_default_music(map)
end

local function the_snails_stop_coming_out(map)
   local s = save.the_snails_come_out_at_night
   local enabled = s.the_snails_come_out
   if not enabled then
      return
   end

   s.the_snails_come_out = false
   Gui.play_default_music(map)
end

local function proc(map)
   if it_is_night(map) then
      the_snails_come_out(map)
   else
      the_snails_stop_coming_out(map)
   end
end

local function current_map()
   local player = Chara.player()
   if Chara.is_alive(player) then
      local map = player:current_map()
      if map then
         return map
      end
   end
end

local function proc_current_map()
   local map = current_map()
   if map then proc(map) end
end

Event.register("base.on_turn_begin", "The snails come out at night.", proc_current_map)
Event.register("base.on_map_entered", "The snails come out at night.", proc)

local function the_snails(map)
   local player = Chara.player()
   return {
      race_filter = "elona.snail",
      initial_level = player and player:calc("level")
   }
end

local function override_chara_filter(filter)
   if save.the_snails_come_out_at_night.the_snails_come_out then
      return the_snails
   end
   return filter
end
Advice.add("filter_return", "mod.elona.api.ElonaChara", "random_filter", "The snails come out at night.", override_chara_filter)

local function set_music(map)
   if save.the_snails_come_out_at_night.the_snails_come_out then
      return "the_snails_come_out_at_night.untitled"
   end
end
Event.register("elona_sys.calc_map_music", "The snails come out at night.", set_music)
