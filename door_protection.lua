-- Author: ZeliowPlay
-- Work of private doors from OpenSecurity using a combination lock


-- User password
local pin = 12345678 -- Max lenght 8
 
-- Requires
local cmp = require("component")
local event = require("event")
local os = require("os")
 
-- Misc
local char_space = string.byte(" ")
local running = true
local currButton = ""
 
-- Initialization event
local myEventHandlers = setmetatable({}, {
  __index = function()
    return unknownEvent
  end
  }
)
 
-- Initialization variables
dc = cmp.os_door
kp = cmp.os_keypad
alarm = cmp.os_alarm

function createAlarm()
  alarm.setAlarm("klaxon2") -- The default config is klaxon1 and klaxon2
  alarm.setRange(15) -- Sets the range in blocks from the alarm block, allowed range is 15 - 150
  alarm.activate() -- alarm activation
end
 
function myEventHandlers.key_up(adress, chat, code, playerName)
  if (char == char_space) then
    running = false
  end
end
 
function myEventHandlers.keypad(address, id, buttonLabel)
  if (id == 10) then
    currButton = ""
    kp.setDisplay("", 15)
  else if (id == 12) then
    if (currButton == tostring(pin)) then
      dc.toggle()
      alarm.deactivate()
      kp.setDisplay("GRANTED", 10)
      -- Opening the door at the time
      -- if (dc.isOpen == false) then
      --  dc.toggle()
      -- end
      -- os.sleep(.5)
      -- if (dc.isOpen) then
      --  dc.toggle()
      -- end
    else
      currButton = ""
      createAlarm()
      kp.setDisplay("DENIED", 12)
    end
  else
    currButton = currButton .. buttonLabel
    kp.setDisplay(currButton, 15)
  end
  end
end
 
function handleEvent(eventID, ...)
  if (eventID) then
    myEventHandlers[eventID](...)
  end
end
 
while running do
  handleEvent(event.pull())
end
