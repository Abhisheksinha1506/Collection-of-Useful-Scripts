import psutil, easygui
battery = psutil.sensors_battery()
plugged = battery.power_plugged
percent = str(battery.percent)
plugged = "Plugged In" if plugged else "Not Plugged In"
if percent < '18':
    easygui.msgbox("Plug-in the charger", title="simple message")
else:
    print(percent+'% | '+plugged)
    easygui.msgbox(percent+'% | '+plugged, title="simple message")
