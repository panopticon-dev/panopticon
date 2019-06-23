# panopticon
Panopticon human detector for earthquake response (IBM Challenge)

# Functional Description
The project consists of two hardware components: a chip that emulates a wireless router and a chip that intercepts and inspects communications on the router's radio channel. Each is based on the ESP8266 microcontroller running RTOS.

# Router Chip

This component establishes a wireless network on channel 6. It also has a display driver so other components can use it to display data on a screen when an internet connection is not available.

# Monitor Chip

This component intercepts and inspects packets on channel 6. It filters out packets that are unlikely to be from mobile devices using packet header inspection, and then counts the valid packets, resulting in an indication of the number of active smartphones present in the area. This data is transmitted to the first chip to display on the screen.

Then, if an internet connection is available, it transmits this data via MQTT to IBM Node Red for storage, remote display, and analysis. This is meant to augment machine vision data captured by drones, as the system is low power and light enough for aerial use.



