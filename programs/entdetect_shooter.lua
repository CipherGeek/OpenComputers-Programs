-- Author: ZeliowPlay
-- Protecting the region from outsiders with a turret
-- Version: 0.0.1
 
-- Config
local radius = 20 -- radius check
local correct = { -- coordinates of the turret from the scanner
  x = 0,
  y = 3,
  z = 0
}

-- Requires
local cmp = require("component")

-- Initialization variables
sensor = cmp.openperipheral_sensor
turr = cmp.os_energyturret
scanner = sensor.getPlayers()

-- Enable turret
if turr.isPowered() == false then
  turr.powerOn()
end

function pointer(x,y,z)
  distXY = math.sqrt(x^2+z^2)
  distDY = math.sqrt(y^2+distXY^2)
  outX = math.deg(math.acos(x/distXY))+90
  outY = 90-math.deg(math.acos(y/distDY))
  if z<0 then
    outX = (180-outX)%360
  end
 
  return outX,outY
end

function shoot()
  for i=1, #scanner do
    pName = scanner[i].name
    pcall(function() player = sensor.getPlayerByName(pName).all() end) -- Crutch
    if player then
      pPos = player.position
      x,y,z = pPos.x-0.5-correct.x,pPos.y+0.3-correct.y,pPos.z-0.5-correct.z
      vx,xy = pointer(x,y,z)

      turr.moveTo(vx,xy)  

      if turr.isOnTarget() then
        if turr.isReady() then
          turr.fire()
        end
      end
    end
  end
end

while true do
  shoot()
end
