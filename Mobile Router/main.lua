mytimer:stop()
port=10001
sda = 2
scl = 1
sla = 0x3C
i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g2.ssd1306_i2c_64x48_er(0,sla)
function u8g2_prepare2()
  disp:setFont(u8g2.font_helvB14_tr)
  disp:setFontRefHeightExtendedText()
  disp:setDrawColor(1)
  disp:setFontPosTop()
  disp:setFontDirection(0)
end

function nap()
	print("Sleep")
	off = tmr.create()
	u8g2_string("Sleep")
    off:register(100, tmr.ALARM_SINGLE, function() node.dsleep(0) end)
    off:start()	
	end

sleeptt = tmr.create()
sleeptt:register(65000, tmr.ALARM_SINGLE, function() nap() end)
sleeptt:start()	


-- Setup screen
   
function u8g2_prepare()
  disp:setFont(u8g2.font_helvB08_tr)
  disp:setFontRefHeightExtendedText()
  disp:setDrawColor(1)
  disp:setFontPosTop()
  disp:setFontDirection(0)
end

function u8g2_string(a)
  disp:clearBuffer()
  disp:setFontDirection(0)
  disp:drawStr(1,15, a)
  disp:sendBuffer()
end

u8g2_prepare2()
u8g2_string("Ready")
srv=net.createServer(net.UDP)
srv:on("receive", function(srv, pl)
   print("Command Received")
   u8g2_prepare2()
   u8g2_string(pl)
end)
srv:listen(port)


