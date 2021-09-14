--[[
LuCI - Lua Configuration Interface
Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>
Licensed under the Apache License, Version 2.0 (the "License")
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
--]]


require("luci.sys")

local SYS  = require "luci.sys"

local Status
local m,s,e

--local mac=luci.sys.exec("uci -q get uart2mqtt.uart2mqtt_conf.preset_mac")

-- /etc/config/serial2mqtt_cfg, mapping the config file

m = Map("serial2mqtt_cfg", translate("LuCI config tools for serial2mqtt"))
m.description = translate("serial2mqtt - UART data exchange to/from MQTT Broker.<br> \
 	details refer to:   <a href=\"https://github.com/halfbakery/serial2mqtt-openwrt\" target=\"_blank\">[[serial2mqtt-openwrt]]</a>  \
 	and <a href=\"https://github.com/vortex314/serial2mqtt\" target=\"_blank\">[[serial2mqtt]] </a> <br>")

--check serial2mqtt status
if SYS.call("pidof serial2mqtt > /dev/null") == 0 then
	Status = translate("<br>serial2mqtt is <strong><font color=\"green\">Running...</font></strong><br><br>")
else
	Status = translate("<br>serial2mqtt <strong><font color=\"red\">Stopped...</font></strong><br><br>")
end

--
-- LuCI UI configuration
--
s = m:section(TypedSection,"working","")
s.anonymous = true
s.description = translate(string.format("%s", Status))

s:tab("mqtt_tab",	translate("MQTT Settings"))
s:tab("uart_tab",	translate("UART Settings"))
s:tab("data_tab",	translate("Data Format"))
s:tab("app_tab",	translate("Application"))
s:tab("log_tab",	translate("LOG Settings"))

--
-- MQTT Settings TAB
--
e = s:taboption("mqtt_tab", Flag, "mqtt_enable", translate("serial2mqtt Enable"))
e.default = 1
e.rmempty = false

e = s:taboption("mqtt_tab", Value, "mqtt_hostname", translate("Broker"))
e.rmempty = true

e = s:taboption("mqtt_tab", Value, "mqtt_hostport", translate("Port"))
e.rmempty = true

e = s:taboption("mqtt_tab", Value, "mqtt_topic_pub", translate("Publish Topic"))
e.default = "test/message"
e.rmempty = false

e = s:taboption("mqtt_tab", Value, "mqtt_topic_sub", translate("Subscribe Topic"))
e.default = "test/message"
e.rmempty = false

--
-- MQTT Login
--
e = s:taboption("mqtt_tab", ListValue,"mqtt_login_enable", translate("use Login"))
e.optional = false
e.rmempty = false
e.default = 0
e.datatype = "uinteger"
e:value(1, translate("True"))
e:value(0, translate("False"))

e = s:taboption("mqtt_tab", Value,"mqtt_login_username", translate("UserName"))
e.optional = true
e.rmempty = true
e.default = "MyLoginName01"
e.datatype = "string"
e:depends("mqtt_login_enable", "1")

e = s:taboption("mqtt_tab", Value,"mqtt_login_password", translate("Password"))
e.optional = true
e.rmempty = true
e.default = "1234567890"
e.datatype = "string"
e:depends("mqtt_login_enable", "1")

--
-- MQTT SSL 
--
e = s:taboption("mqtt_tab", ListValue,"mqtt_ssl_enable", translate("use SSL"))
e.optional = false
e.rmempty = false
e.default = 0
e.datatype = "uinteger"
e:value(1, translate("True"))
e:value(0, translate("False"))

e = s:taboption("mqtt_tab", Value,"mqtt_ssl_cafile", translate("ca"))
e.optional = true
e.rmempty = true
e.default = '/usr/share/serial2mqtt/ssl/ca.crt'
e.datatype = "string"
e:depends("mqtt_ssl_enable", "1")

e = s:taboption("mqtt_tab", Value,"mqtt_ssl_crtfile", translate("crt"))
e.optional = true
e.rmempty = true
e.default = '/usr/share/serial2mqtt/ssl/client.crt'
e.datatype = "string"
e:depends("mqtt_ssl_enable", "1")

e = s:taboption("mqtt_tab", Value,"mqtt_ssl_keyfile", translate("key"))
e.optional = true
e.rmempty = true
e.default = '/usr/share/serial2mqtt/ssl/client.key'
e.datatype = "string"
e:depends("mqtt_ssl_enable", "1")

--
-- Host MAC address to wakeup
--
--host = s:taboption("mqtt_tab", Value, "preset_mac", translate("Host to wake up"), translate("Choose the host MAC or enter a custom MAC address to use."))
--host.title = translate("Preset MAC address")
--SYS.net.mac_hints(function(mac, name)
--	host:value(mac, "%s (%s)" %{ mac, name })
--end)

--
-- UART Settings TAB
--
function get_device_name(s, ...)
	--
	local device_suggestions = nixio.fs.glob("/dev/tty[A-Z]*")
		or nixio.fs.glob("/dev/tts/*")
	if device_suggestions then
		local node
		for node in device_suggestions do
			s:value(node)
		end
	end
	--
end

e = s:taboption("uart_tab", Value, "uart_serial", translate("UART Device"))
e.rmempty = false
get_device_name(e)

e = s:taboption("uart_tab", ListValue, "uart_baudrate", translate("Baudrate (bps)"))
e:value("B115200", "115200")
e:value("B57600", "57600")
e:value("B38400", "38400")
e:value("B19200", "19200")
e:value("B9600", "9600")
e.default = "B115200"

e = s:taboption("uart_tab", ListValue, "uart_databit", translate("Databit"))
e:value("CS8", "8")
e:value("CS7", "7")
e.default = "CS8"

e = s:taboption("uart_tab", ListValue, "uart_parity_check", translate("Odd-Even Check"))
e:value("NONE", translate("None Check"))
e:value("PARODD", translate("Odd Check"))
e:value("PARENB", translate("Even Check"))
e.default = "NONE"

e = s:taboption("uart_tab", ListValue, "uart_stopbit", translate("Stopbit"))
e:value("", "1")
e:value("CSTOPB", "2")
e.default = "0"

e = s:taboption("uart_tab", Value,"uart_reconnectInterval",translate("UART reconnect (ms)"))
e.optional = true
e.rmempty = true
e.default = "1000"

e = s:taboption("uart_tab", Value,"uart_idleTimeout",translate("UART keep alive (ms)"))
e.optional = true
e.rmempty = true
e.default = "60000"

--
-- Data Format
--
e = s:taboption("data_tab", ListValue,"data_uart_type",translate("UART data type"))
e:value("uart_json_array", translate("Json Array"))
e:value("uart_json_object", translate("Json Object"))
e:value("uart_data_hex", translate("HEX string"))
e:value("uart_data_char", translate("Char string"))
e:value("uart_data_bin", translate("BIN raw data"))
e.default = "uart_json_array"

e = s:taboption("data_tab", Value,"data_uart_format",translate("UART Json Object format"))
e.optional = true
e.rmempty = false
e.default = "non_defined"
e.datatype = "string"
e:depends("data_uart_type", "uart_json_object")

e = s:taboption("data_tab", ListValue,"data_mqtt_type",translate("MQTT data type"))
e:value("mqtt_json_array", translate("Json Array"))
e:value("mqtt_json_object", translate("Json Object"))
e:value("mqtt_raw_data", translate("Raw Data"))
e.default = "mqtt_json_array"

e = s:taboption("data_tab", Value,"data_mqtt_format",translate("MQTT Json Object format"))
e.optional = true
e.rmempty = false
e.default = "non_defined"
e.datatype = "string"
e:depends("data_mqtt_type", "mqtt_json_object")

--
-- Application
--
e = s:taboption("app_tab", Value, "app_project", translate("Project Name"))
e.default = 'My project name'
e.datatype = "string"
e.rmempty = false

e = s:taboption("app_tab", Value, "app_gateway_fw", translate("Gateway FW"))
e.default = '1.2.34-5'
e.datatype = "string"
e.rmempty = false

e = s:taboption("app_tab", Value, "app_gateway_mac", translate("Gateway MAC"))
e.default = '1a2b3c4d5e6f'
e.datatype = "string"
e.rmempty = false

e = s:taboption("app_tab", Value, "app_remarks", translate("Project remarks"))
e.default = 'Remarks: '
e.datatype = "string"
e.rmempty = false
	
--
-- LOG Settings
--
e = s:taboption("log_tab", Value,"log_file", translate("log_file"))
e.default = 'log.serial2mqtt'
e.rmempty = false

e = s:taboption("log_tab", Value, "log_level", translate("log_level"))
e.default = 'I'
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_protocol", translate("log_protocol"))
e.default = 1
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_debug", translate("log_debug"))
e.default = 1
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_useColors", translate("log_useColors"))
e.default = 1
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_mqtt", translate("log_mqtt"))
e.default = 1
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_program", translate("log_program"))
e.default = 1
e.rmempty = false

e = s:taboption("log_tab", Flag, "log_console", translate("log_console"))
e.default = 1
e.rmempty = false


--local apply = luci.http.formvalue("cbi.apply")
--if apply then
--	io.popen("/etc/init.d/serial2mqtt_init restart")
--end


return m

