-- Connect to mobile router
wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_B)
station_cfg={}
station_cfg.ssid="panopticon"
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.connect()

-- Let the router know we're ready to scan, then start scanning
function start_scan()
udpSocket = net.createUDPSocket()
udpSocket:send(10001,"192.168.4.255", "Scan")
sleeptt = tmr.create()
sleeptt:register(200, tmr.ALARM_SINGLE, function() dofile('monitor.lua') end)
sleeptt:start()	
end

--Wait for connection to mobile router to be established
mytimer = tmr.create()
mytimer:register(1000, tmr.ALARM_AUTO, function() if wifi.sta.getip()==nil then print(" Connecting to mobile router") else start_scan() end end)
mytimer:start()
