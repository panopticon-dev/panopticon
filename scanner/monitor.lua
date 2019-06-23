--I always define this so I can classify data by device. Not used presently.
chipid = node.chipid()

function nodered_send()
--Transmit to IBM Node Red via MQTT 3rd party broker
mytimer3:stop()
m = mqtt.Client(ClientID, 120)
m:connect("hardfork.asia", 1883, 0, function(client) print("Connection established") m:publish("panopticon/", random_mac_count, 1, 0) print("Transmission confirmed")m:close() end)
sleeptt = tmr.create()
sleeptt:register(6000, tmr.ALARM_SINGLE, function() node.dsleep(0) end)
sleeptt:start()	
	end

function nodered()
--Transmit to local screen over UDP broadcast, allowing multiple screens if needed
wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_B)
station_cfg={}
station_cfg.ssid="presence"
station_cfg.pwd="solfatara"
station_cfg.save=false
wifi.sta.config(station_cfg)	
ClientID = node.chipid()
mytimer3 = tmr.create()
mytimer3:register(1000, tmr.ALARM_AUTO, function() if wifi.sta.getip()==nil then print(" Connecting to IBM Node Red") else nodered_send() end end)
mytimer3:start()
	end

function transmit()
-- This function transmits the total captured packets to the local screen and then to IBM Node Red.
port = 10001
mytimer2:stop()
udpSocket = net.createUDPSocket()
udpSocket:send(port,"192.168.4.255", random_mac_count)
sleeptt = tmr.create()
sleeptt:register(200, tmr.ALARM_SINGLE, function() nodered() end)
sleeptt:start()	
end

--Monitor function. Captures all data packets (notably probe requests and data, but we filter out data -- we only care about probe requests)
function monitor()
channel = 6
table_length = 0
random_mac_count = 0
	
reconnectt = tmr.create()
reconnectt:register(15000, tmr.ALARM_SINGLE, function() reconnect() end)
reconnectt:start()	
	
wifi.monitor.start(channel, 0x50, function(pkt)
			--below we filter so we only count packets that are from phones not connected to an AP using the radio packet header.
	    x = pkt.srcmac_hex
		x = string.sub(x, 1, 2) 
        x = "0x"..x
        x = tonumber(x,16)
		if pkt.srcmac_hex ~= "ff:ff:ff:ff:ff:ff" then
				if bit.isset(x, 1) then
					random_mac_count = random_mac_count+1
					print("Packet intercepted! Count: "..random_mac_count)
				end
end
end)
	end

function startup()
	data = 6 --default channel. Mobile router uses channel 6.
	network ="panopticon" --Default network to scan, in case I implement a filter for it. Not useful to do so presently.
	monitor()
	end
	
function reconnect()
--Disable monitor mode so we can connect to WiFi networks again and send off the collected data.
reconnectt:stop()	
print("Done scanning cycle, preparing to process data")
wifi.monitor.stop()
wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_B)
station_cfg={}
station_cfg.ssid="panopticon"
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.connect()
print("Intercepted " .. random_mac_count .. " packets. Transmitting data")
mytimer2 = tmr.create()
mytimer2:register(1000, tmr.ALARM_AUTO, function() if wifi.sta.getip()==nil then print(" Connecting to Screen") else transmit() end end)
mytimer2:start()
end

mytimer:stop()
startup()

