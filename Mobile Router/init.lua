wifi.setmode(wifi.SOFTAP)
wifi.setphymode(wifi.PHYMODE_B)
cfg={}
cfg.ssid="panopticon"
cfg.channel = "6"
wifi.ap.config(cfg)
dhcp_config ={}
dhcp_config.start = "192.168.4.1"
wifi.ap.dhcp.config(dhcp_config)
wifi.ap.dhcp.start()

mytimer = tmr.create()
mytimer:register(2000, tmr.ALARM_AUTO, function() print("Startup") dofile('main.lua') end)
mytimer:start()
