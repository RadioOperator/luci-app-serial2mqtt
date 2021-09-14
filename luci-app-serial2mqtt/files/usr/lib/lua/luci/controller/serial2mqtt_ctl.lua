module("luci.controller.serial2mqtt_ctl", package.seeall)
function index()
	entry({"admin", "services", "serial2mqtt"}, cbi("serial2mqtt_cbi"), _("Serial2MQTT"), 102)
end
