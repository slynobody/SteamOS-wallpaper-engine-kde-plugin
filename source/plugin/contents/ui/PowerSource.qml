import QtQuick 2.1
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

Item {
	id: root
	readonly property alias pm_data: pm_source.data

	// Safe accessors with fallback values for when data is not yet available
	readonly property var batteryData: pm_data['Battery'] || {}
	readonly property bool   st_battery_has: batteryData['Has Battery'] || false
	readonly property string st_battery_state: batteryData['State'] || ""
	readonly property int    st_battery_percent: batteryData['Percent'] || 0

	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/powermanagement/powermanagementengine.h
	// https://github.com/KDE/plasma-workspace/blob/master/dataengines/powermanagement/powermanagementengine.cpp
	Plasma5Support.DataSource {
		id: pm_source
		engine: 'powermanagement'
		connectedSources: ['Battery'] // basicSourceNames == ["Battery", "AC Adapter", "Sleep States", "PowerDevil", "Inhibitions"]
		function log() {
			for (var i = 0; i < pm_source.sources.length; i++) {
				var sourceName = pm_source.sources[i]
				var source = pm_source.data[sourceName]
				for (var key in source) {
					console.error('pm_source.data["'+sourceName+'"]["'+key+'"] =', source[key])
				}
			}
		}
	}
	// Component.onCompleted: pm_source.log()
}
