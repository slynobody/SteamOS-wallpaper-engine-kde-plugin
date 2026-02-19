import QtQuick 2.6
import QtQuick.Controls 2.3
import QtQuick.Controls 2.3 as QQC
import QtQuick.Window 2.0 // for Screen
import QtQuick.Dialogs
import QtQuick.Layouts 1.5

import ".."
import "../components"

import "../js/utils.mjs" as Utils
import "../js/bbcode.mjs" as BBCode

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
// for kcm gridview
import org.kde.kcmutils as KCM
import org.kde.kirigami 2.6 as Kirigami
import org.kde.kquickcontrolsaddons 2.0

RowLayout {
    Layout.fillWidth: true

    // Наследуем тему от родителя
    Kirigami.Theme.inherit: true

    function saveConfig() {
        right_opts.save_changes();
    }
    
    Control {
        id: left_content
        Layout.fillWidth: true
        Layout.fillHeight: true
        topPadding: 8
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0

        contentItem: ColumnLayout {
            id: wpselsect
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                id: infoRow
                Layout.alignment: Qt.AlignHCenter
                spacing: 5

                Label {
                    visible: cfg_WallpaperWorkShopId
                    text: `Shopid: ${cfg_WallpaperWorkShopId}  Type: ${Common.unpackWallpaperSource(cfg_WallpaperSource).type}`
                    //${cfg_WallpaperType}
                }

                Kirigami.ActionToolBar {
                    Layout.fillWidth: true
                    alignment: Qt.AlignRight
                    flat: false

                    ActionGroup {
                        id: group_sort
                        exclusive: true
                    }
                    Component {
                        id: comp_action_filter
                        Kirigami.Action {
                            property int act_index;

                            checkable: false
                            checked: action_cb_filter.modelValues[act_index]
                            onTriggered: {
                                if(!checkable) return;
                                const modelValues = action_cb_filter.modelValues;
                                modelValues[act_index] = Number(!modelValues[act_index]);
                                cfg_FilterStr = Utils.intArrayToStr(modelValues);
                            }

                            Component.onCompleted: comp_action_sort.Component.destruction.connect(this.destroy)
                        }
                    }
                    Component {
                        id: comp_action_sort
                        Kirigami.Action {
                            ActionGroup.group: group_sort

                            property int act_value;
                            checkable: true
                            checked: {
                                checked = cfg_SortMode == act_value;
                            }
                            onTriggered: cfg_SortMode = act_value

                            Component.onCompleted: comp_action_sort.Component.destruction.connect(this.destroy)
                        }
                    }

                    actions: [
                        Kirigami.Action {
                            icon.name: "folder-symbolic"
                            text: 'Library'
                            tooltip: cfg_SteamLibraryPath ? cfg_SteamLibraryPath : 'Select steam library dir'
                            onTriggered: wpDialog.open()
                        },
                        Kirigami.Action {
                            id: action_cb_filter
                            text: 'Filter'
                            icon.name: "view-filter"
                            property int currentIndex
                            readonly property var model: Common.filterModel
                            readonly property var modelValues: Common.filterModel.getValueArray(cfg_FilterStr)

                            children: model.map((el, index) => comp_action_filter.createObject(null, {
                                text: el.text, 
                                act_index: index,
                                checkable: el.type !== '_nocheck'
                            }))
                        },
                        Kirigami.Action {
                            id: action_cb_sort
                            text: model[currentIndex].short
                            icon.name: "view-sort-descending-symbolic"
                            property int currentIndex: Common.modelIndexOfValue(model, cfg_SortMode)
                            readonly property var model: [
                                {
                                    text: "Sort By Workshop Id",
                                    short: "Id",
                                    value: Common.SortMode.Id
                                },
                                {
                                    text: "Sort Alphabetically By Name",
                                    short: "Alphabetical",
                                    value: Common.SortMode.Name
                                },
                                {
                                    text: "Show Newest Modified First",
                                    short: "Modified",
                                    value: Common.SortMode.Modified
                                }
                            ]
                            children: model.map((el, index) => comp_action_sort.createObject(null, {text: el.text, act_value: el.value}))
                        },
                        Kirigami.Action {
                            icon.name: "view-refresh-symbolic"
                            text: 'Refresh'
                            onTriggered: wpListModel.refresh()
                        }
                    ]
                }
            }

            Loader {
                id: picViewLoader
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // over wite the implicitWidth to 0
                Layout.preferredHeight: 0

                asynchronous: false
                sourceComponent: picViewCom
                visible: status == Loader.Ready

                Component.onCompleted: {
                    const refreshIndex = () => {
                        this.item.view.model = wpListModel.model; 
                        if(this.status == Loader.Ready) {
                            this.item.setCurIndex(wpListModel.model);
                        }
                    }
                    wpListModel.modelStartSync.connect(this.item.backtoBegin);
                    wpListModel.modelRefreshed.connect(refreshIndex.bind(this));
                }

                Kirigami.Heading {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    visible: picViewLoader.item && picViewLoader.item.view.count === 0
                    level: 2
                    text: { 
                        if(!(libcheck.qtwebsockets && pyext))
                            return `Please make sure qtwebsockets(qml module) installed, and open this again`
                        if(!pyext.ok) {
                            return `Python helper run failed: ${pyext.log}`;
                        }
                        if(!cfg_SteamLibraryPath)
                            return "Select your steam library through the folder selecting button above";
                        if(wpListModel.countNoFilter > 0)
                            return `Found ${wpListModel.countNoFilter} wallpapers, but none of them matched filters`;
                        return `There are no wallpapers in steam library`;
                    }
                    opacity: 0.5
                }
            }
            Component { 
                id: picViewCom
                KCM.GridView {
                    id: picViewGrid
                    anchors.fill: parent

                    readonly property var currentModel: view.model.get(view.currentIndex)
                    readonly property var defaultModel: ListModel {}
                    visible: view.count > 0

                    // from org.kde.image
                    view.implicitCellWidth: Screen.width / 10 + Kirigami.Units.smallSpacing * 2
                    view.implicitCellHeight: Screen.height / 10 + Kirigami.Units.smallSpacing * 2 + Kirigami.Units.gridUnit * 3
                    view.model: defaultModel
                    view.delegate: KCM.GridDelegate {
                        // path is file://, safe to concat with '/'
                        text: title
                        hoverEnabled: true
                        actions: [
                            Kirigami.Action {
                                icon.name: favor?"user-bookmarks-symbolic":"bookmark-add-symbolic"
                                tooltip: favor?"Remove from favorites":"Add to favorites"
                                onTriggered: picViewLoader.item.toggleFavor(model, index)
                            },
                            Kirigami.Action {
                                icon.name: "folder-remote-symbolic"
                                tooltip: "Open Workshop Link"
                                enabled: workshopid.match(Common.regex_workshop_online)
                                onTriggered: Qt.openUrlExternally(Common.getWorkshopUrl(workshopid))
                            }
                        ]
                        thumbnail: Rectangle {
                            anchors.fill: parent
                            Kirigami.Icon {
                                anchors.centerIn: parent
                                width: root.iconSizes.large
                                height: width
                                source: "view-preview"
                                visible: !imgPre.visible
                            }
                            Image {
                                id: imgPre
                                anchors.fill: parent
                                source: Common.getWpModelPreviewSource(model);
                                sourceSize.width: parent.width
                                sourceSize.height: parent.height
                                fillMode: Image.PreserveAspectCrop//Image.Stretch
                                cache: false
                                asynchronous: true
                                smooth: true
                                visible: Boolean(preview)
                            }
                        }
                        onClicked: {
                            cfg_WallpaperSource = Common.packWallpaperSource(model);
                            cfg_WallpaperWorkShopId = workshopid;
                            view.currentIndex = index;
                        }
                    }

     
                    function backtoBegin() {
                        view.model = defaultModel
                        //view.positionViewAtBeginning();
                    }

                    function setCurIndex(model) {
                        // model, ListModel
                        new Promise((reoslve, reject) => {
                            for(let i=0;i < model.count;i++) {
                                if(model.get(i).workshopid === cfg_WallpaperWorkShopId) {
                                    view.currentIndex = i;
                                    break;
                                }
                            }
                            if(view.currentIndex == -1 && model.count != 0)
                                view.currentIndex = 0;

                            if(!cfg_WallpaperSource)
                                if(view.currentIndex != -1)
                                    view.currentItem.onClicked();

                            resolve();
                        });
                    }
                    function toggleFavor(model, index) {
                        if(!index) index = view.currentIndex;

                        if(model.favor) {
                            root.customConf.favor.delete(model.workshopid);
                        } else {
                            root.customConf.favor.add(model.workshopid);
                        }
                        this.view.model.assignModel(index, {favor: !model.favor});
                        root.saveCustomConf();

                        if(index == view.currentIndex) this.view.currentIndexChanged();
                    }

                }
            }

            FolderDialog {
                id: wpDialog
                title: "Select steamlibrary folder"
                onAccepted: {
                    const path = Utils.trimCharR(wpDialog.selectedFolder.toString(), '/');
                    cfg_SteamLibraryPath = path;
                    return wpListModel.refresh();
                }
            }
        }
    }

    Control {
        id: right_content
        Layout.preferredWidth: parent.width / 3
        Layout.fillHeight: true

        readonly property int image_size: 300
        readonly property int content_margin: 16
        property var wpmodel: { 
            return picViewLoader.item.currentModel
            ? Common.wpitemFromQtObject(picViewLoader.item.currentModel)
            : Common.wpitem_template;
        }

        visible: Layout.preferredWidth > image_size + content_margin*2 + right_content_scrollbar.width

        topPadding: 0
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0

        background: Rectangle {
            color: Kirigami.Theme.backgroundColor
        }

        contentItem: Flickable {
            anchors.fill: parent

            ScrollBar.vertical: ScrollBar { id: right_content_scrollbar }

            contentWidth: width - (right_content_scrollbar.visible ? right_content_scrollbar.width : 0)
            contentHeight: flick_content.implicitHeight

            clip: true
            boundsBehavior: Flickable.OvershootBounds

            ColumnLayout {
                id: flick_content
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: right_content.content_margin
                anchors.rightMargin: anchors.leftMargin
                spacing: 8

                AnimatedImage { 
                    id: animated_image; 
                    Layout.topMargin: right_content.content_margin
                    Layout.preferredWidth: right_content.image_size
                    Layout.preferredHeight: Layout.preferredWidth
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    source: Common.getWpModelPreviewSource(right_content.wpmodel)
                    fillMode: Image.PreserveAspectFit
                    cache: true
                    asynchronous: true
                    onStatusChanged: playing = (status == AnimatedImage.Ready)
                }

                Text {
                    Layout.alignment: Qt.AlignTop
                    Layout.minimumWidth: 0
                    Layout.fillWidth: true
                    Layout.minimumHeight: implicitHeight

                    text: right_content.wpmodel.title
                    color: Kirigami.Theme.textColor
                    font.bold: true
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    spacing: 8

                    Control {
                        leftPadding: 8
                        topPadding: 4

                        rightPadding: leftPadding
                        bottomPadding: topPadding

                        background: Rectangle {
                            color: Kirigami.Theme.positiveBackgroundColor
                            radius: 8
                        }
                        contentItem: Text {
                            color: Kirigami.Theme.textColor
                            font.capitalization: Font.Capitalize
                            text: right_content.wpmodel.type
                        }
                    }

                    Control {
                        id: control_dir_size
                        leftPadding: 8
                        topPadding: 4

                        rightPadding: leftPadding
                        bottomPadding: topPadding
                        visible: false

                        background: Rectangle {
                            color: Kirigami.Theme.positiveBackgroundColor
                            radius: 8
                        }
                        contentItem: Text {
                            color: Kirigami.Theme.textColor
                            font.capitalization: Font.Capitalize
                            readonly property bool _set_text: {
                                const dir = right_content.wpmodel.path;
                                if(!dir.match(Common.regex_path_check)) {
                                    control_dir_size.visible = false;
                                    return false;
                                }
                                pyext.get_dir_size(Common.urlNative(dir)).then(res => {
                                    this.text = Utils.prettyBytes(res);
                                    control_dir_size.visible = true;
                                }).catch(reason => console.error(reason));
                                return true;
                            }
                        }
                    }

                    Kirigami.ActionToolBar {
                        Layout.fillWidth: false
                        Layout.preferredWidth: implicitWidth
                        flat: true

                        actions: [
                            Kirigami.Action {
                                id: right_act_favor
                                
                                icon.name: right_content.wpmodel.favor 
                                    ? "bookmarks-symbolic"
                                    : "bookmark-add-symbolic"
                                tooltip: right_content.wpmodel.favor
                                    ? 'Remove from favorites'
                                    : 'Add to favorites'
                                onTriggered: picViewLoader.item.toggleFavor(right_content.wpmodel)
                            },
                            Kirigami.Action {
                                icon.name: "emblem-symbolic-link"
                                tooltip: "Open Workshop Link"
                                enabled: right_content.wpmodel.workshopid.match(Common.regex_workshop_online)
                                onTriggered: Qt.openUrlExternally(Common.getWorkshopUrl(right_content.wpmodel.workshopid))
                            },
                            Kirigami.Action {
                                icon.name: "folder-symbolic"
                                tooltip: "Open Containing Folder"
                                onTriggered: Qt.openUrlExternally(right_content.wpmodel.path) 
                            }
                        ]
                    }
                }

                ListView {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    implicitWidth: contentItem.childrenRect.width
                    implicitHeight: contentItem.childrenRect.height

                    orientation: ListView.Horizontal
                    model: ListModel {}
                    readonly property bool _set_model: {
                        const wpmodel = right_content.wpmodel;
                        const tags = right_content.wpmodel.tags;
                        const playlists = right_content.wpmodel.playlists;
                        const _model = this.model;
                        _model.clear();
                        for(const i of Array(tags.length).keys())
                            _model.append(tags.get(i));
                        for(const i of Array(playlists.length).keys()){
                            var playlist = playlists.get(i);
                            if(playlist != null) { _model.append(playlists.get(i)); }
                        }
                        _model.append({key: wpmodel.contentrating});
                        return true;
                    }
                    clip: false
                    spacing: 8

                    delegate: Control {
                        leftPadding: 8
                        topPadding: 4
                        rightPadding: leftPadding
                        bottomPadding: topPadding

                        background: Rectangle {
                            color: Kirigami.Theme.activeBackgroundColor
                            radius: 8
                        }
                        contentItem: Text {
                            color: Kirigami.Theme.textColor
                            text: model.key
                        }
                    }
                }

                Component {
                    id: right_opt_combox
                    ComboBox {
                        property var def_val

                        textRole: "text"
                        onActivated: {}

                        property var res_val: currentIndex >= 0 ? Common.cbCurrentValue(this) : def_val
                        function finish() {
                            currentIndex = Common.cbIndexOfValue(this, def_val);
                        }
                    }
                }
                Component {
                    id: right_opt_switch
                    Switch {
                        property bool def_val
                        property bool res_val: checked
                        function finish() {
                            checked = def_val;
                        }
                    }
                }
                Component {
                    id: right_opt_spinbox
                    SpinBox {
                        property int def_val
                        property int res_val: value
                        function finish() {
                            value = def_val;
                        }
                    }
                }
                Component {
                    id: right_opt_dspinbox
                    DoubleSpinBox {
                        property real def_val
                        property real res_val: dValue
                        function finish() {
                            dValue = def_val;
                        }
                    }
                }

                OptionGroup {
                    id: right_opts
                    Layout.fillWidth: true

                    readonly property string workshopid: right_content.wpmodel.workshopid

                    property var config_resets: new Set()
                    property var config_changes: ({})
                    property var config: ({})

                    onWorkshopidChanged: {
                        if (workshopid) {
                            pyext.read_wallpaper_config(workshopid).then(res => {
                                config = res;
                            });
                        } else {
                            config = {};
                        }
                    }
                    Component.onCompleted: {
                        if (workshopid) {
                            pyext.read_wallpaper_config(workshopid).then(res => {
                                config = res;
                            });
                        }
                    }
                    function save_changes() {
                        console.log("save_changes called, config_changes:", JSON.stringify(config_changes));
                        config_resets.forEach((wid) => {
                            pyext.reset_wallpaper_config(wid).then(res => {});
                        });
                        Object.entries(config_changes).forEach(([wid, cfg]) => {
                            console.log("saving config for wid:", wid, "cfg:", JSON.stringify(cfg));
                            pyext.write_wallpaper_config(wid, cfg);
                        });
                        // Clear after saving
                        config_changes = {};
                        config_resets.clear();
                    }
                    function set_config(key, val) {
                        console.log("set_config called, key:", key, "val:", val, "workshopid:", workshopid);
                        if(!key || !workshopid) return;

                        if (!config_changes[workshopid])
                            config_changes[workshopid] = {}
                        config_changes[workshopid][key] = val;

                        this.config_changesChanged();
                        console.log("set_config: cfg_PerOptChanged before:", cfg_PerOptChanged);
                        cfg_PerOptChanged++;
                        console.log("set_config: cfg_PerOptChanged after:", cfg_PerOptChanged);
                    }
                    function reset_config() {
                        config_resets.add(workshopid);
                        delete config_changes[workshopid];
                        config = {}
                        cfg_PerOptChanged++;
                    }
                    function in_config_changes(key) {
                        return config_changes.hasOwnProperty(workshopid) && config_changes[workshopid].hasOwnProperty(key);
                    }

                    function get_config_val(key) {
                        if (in_config_changes(key))
                            return config_changes[workshopid][key];
                        if (config.hasOwnProperty(key))
                            return config[key];
                        return null;
                    }
                    function has_change(key) {
                        return config.hasOwnProperty(key) || in_config_changes(key);
                    }

                    header.text: 'Option'
                    header.text_color: Kirigami.Theme.textColor
                    header.icon: '../../images/cheveron-down.svg'
                    header.color: Kirigami.Theme.activeBackgroundColor

                    header.actor: Kirigami.ActionToolBar {
                        Layout.fillWidth: true
                        alignment: Qt.AlignRight
                        flat: true
                        actions: [
                            Kirigami.Action {
                                text: 'Reset'
                                onTriggered: {
                                    right_opts.reset_config();
                                }
                            }
                        ]
                    }
                    Repeater {
                        property bool markModel: false;
                        model: [
                            {
                                mark_: markModel,
                                text: 'Display',
                                config_key: 'display_mode',
                                comp: right_opt_combox,
                                props: {
                                    model: [
                                        {
                                            text: "Keep Aspect Ratio",
                                            value: Common.DisplayMode.Aspect
                                        },
                                        {
                                            text: "Scale and Crop",
                                            value: Common.DisplayMode.Crop
                                        },
                                        {
                                            text: "Scale to Fill",
                                            value: Common.DisplayMode.Scale
                                        },
                                    ],
                                    def_val: cfg_DisplayMode,
                                }
                            },
                            {
                                text: 'Mute Audio',
                                config_key: 'mute_audio',
                                comp: right_opt_switch,
                                props: {
                                    def_val: cfg_MuteAudio
                                },
                            },
                            {
                                text: 'Volume',
                                config_key: 'volume', 
                                comp: right_opt_spinbox,
                                props: {
                                    def_val: cfg_Volume,
                                    from: 1,
                                    to: 100,
                                    stepSize: 1,
                                },
                            },
                            {
                                text: 'Speed',
                                config_key: 'speed', 
                                comp: right_opt_dspinbox,
                                props: {
                                    def_val: cfg_Speed,
                                    dFrom: 0.1,
                                    dTo: 16,
                                    dStepSize: 0.1,
                                },
                            },

                        ]
                        OptionItem {
                            text: modelData.text
                            text_color: Kirigami.Theme.textColor

                            property bool is_changed: right_opts.config && 
                                right_opts.config_changes && 
                                right_opts.has_change(modelData.config_key)

                            icon: is_changed ? Qt.resolvedUrl('../../images/edit-pencil.svg') : ''
                            actor: Loader {
                                sourceComponent: modelData.comp
                                onLoaded: {
                                    Object.entries(modelData.props).forEach(([key, value]) => {
                                        this.item[key] = value;
                                    });
                                    const changed_val = right_opts.get_config_val(modelData.config_key);
                                    if(changed_val !== null) {
                                        this.item['def_val'] = changed_val;
                                    }

                                    this.item.finish();
                                    this.item.onRes_valChanged.connect(() => {
                                        right_opts.set_config(modelData.config_key, this.item.res_val);
                                    });
                                }
                            }
                        }
                        Component.onCompleted: {
                            right_opts.onConfigChanged.connect(() => {
                                markModel = !markModel;
                            });
                        }
                    }
                }
                // User Properties from project.json
                Component {
                    id: user_prop_color
                    ColorButton { }
                }

                OptionGroup {
                    id: user_props_group
                    Layout.fillWidth: true
                    visible: user_props_repeater.model.length > 0

                    readonly property string workshopid: right_content.wpmodel.workshopid
                    onWorkshopidChanged: {
                        // Reset state when switching wallpapers
                        userProperties = [];
                        propConfig = {};
                        propChanges = {};
                    }

                    property var userProperties: []
                    property var propConfig: ({})
                    property var propChanges: ({})

                    property bool _loadProps: {
                        // Force re-evaluation when workshopid changes
                        const wid = workshopid;
                        const wpPath = right_content.wpmodel.path;
                        const projectPath = Common.getWpModelProjectPath(right_content.wpmodel);
                        if (wid && wpPath && wpPath.match(Common.regex_path_check)) {
                            pyext.readfile(Common.urlNative(projectPath)).then(value => {
                                const project = Utils.parseJson(value);
                                if (project && project.general && project.general.properties) {
                                    const props = project.general.properties;
                                    const arr = [];
                                    // Helper to convert localization keys to readable text
                                    function formatLabel(text, key) {
                                        if (!text) return key;
                                        // Convert "ui_browse_properties_XXX" to "Xxx Yyy"
                                        if (text.startsWith('ui_browse_properties_')) {
                                            const suffix = text.replace('ui_browse_properties_', '');
                                            // Split by underscore, capitalize each word
                                            return suffix.split('_').map(w =>
                                                w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
                                            ).join(' ');
                                        }
                                        return text;
                                    }
                                    for (const key in props) {
                                        const prop = props[key];
                                        if (prop.type) {
                                            arr.push({
                                                key: key,
                                                text: formatLabel(prop.text, key),
                                                type: prop.type,
                                                value: prop.value,
                                                min: prop.min,
                                                max: prop.max,
                                                options: prop.options
                                            });
                                        }
                                    }
                                    userProperties = arr;
                                } else {
                                    userProperties = [];
                                }
                            }).catch(reason => {
                                console.error(`read project.json error: ${reason}`);
                                userProperties = [];
                            });
                        } else {
                            userProperties = [];
                        }
                        return true;
                    }

                    property bool _loadConfig: {
                        if (workshopid) {
                            pyext.read_wallpaper_config(workshopid).then(res => {
                                propConfig = res || {};
                            });
                        }
                        return true;
                    }

                    function savePropChange(key, val) {
                        if (!workshopid) return;

                        // Create new object to trigger QML binding update
                        const newChanges = Object.assign({}, propChanges);
                        newChanges[key] = val;
                        propChanges = newChanges;

                        // Build config to save: merge with existing under 'user_props' key
                        const userPropsConfig = {};
                        userPropsConfig['user_props'] = Object.assign({}, propConfig['user_props'] || {}, propChanges);
                        pyext.write_wallpaper_config(workshopid, userPropsConfig);

                        // Signal main.qml to reload config
                        cfg_PerOptChanged++;
                    }

                    function getPropValue(key, defaultVal) {
                        if (propChanges.hasOwnProperty(key)) return propChanges[key];
                        if (propConfig['user_props'] && propConfig['user_props'].hasOwnProperty(key))
                            return propConfig['user_props'][key];
                        return defaultVal;
                    }

                    function resetUserProps() {
                        propChanges = {};
                        const resetConfig = { 'user_props': {} };
                        pyext.write_wallpaper_config(workshopid, resetConfig);
                        propConfig = {};

                        // Signal main.qml to reload config
                        cfg_PerOptChanged++;
                    }

                    header.text: 'User Properties'
                    header.text_color: Kirigami.Theme.textColor
                    header.icon: '../../images/cheveron-down.svg'
                    header.color: Kirigami.Theme.activeBackgroundColor

                    header.actor: Kirigami.ActionToolBar {
                        Layout.fillWidth: true
                        alignment: Qt.AlignRight
                        flat: true
                        actions: [
                            Kirigami.Action {
                                text: 'Reset'
                                onTriggered: user_props_group.resetUserProps()
                            }
                        ]
                    }

                    Repeater {
                        id: user_props_repeater
                        model: user_props_group.userProperties

                        OptionItem {
                            text: modelData.text
                            text_color: Kirigami.Theme.textColor

                            property bool is_changed: user_props_group.propChanges.hasOwnProperty(modelData.key)
                            icon: is_changed ? Qt.resolvedUrl('../../images/edit-pencil.svg') : ''

                            actor: Loader {
                                sourceComponent: {
                                    switch(modelData.type) {
                                        case 'bool':
                                            return right_opt_switch;
                                        case 'slider':
                                            // Use int spinbox if min/max are integers
                                            const hasDecimals = (modelData.min && modelData.min % 1 !== 0) ||
                                                               (modelData.max && modelData.max % 1 !== 0) ||
                                                               (modelData.value && modelData.value % 1 !== 0);
                                            return hasDecimals ? right_opt_dspinbox : right_opt_spinbox;
                                        case 'color':
                                            return user_prop_color;
                                        case 'combo':
                                            return right_opt_combox;
                                        default:
                                            return null;
                                    }
                                }

                                onLoaded: {
                                    const savedVal = user_props_group.getPropValue(modelData.key, null);
                                    const defVal = savedVal !== null ? savedVal : modelData.value;

                                    switch(modelData.type) {
                                        case 'bool':
                                            this.item.def_val = Boolean(defVal);
                                            break;
                                        case 'slider':
                                            const hasDecimals = (modelData.min && modelData.min % 1 !== 0) ||
                                                               (modelData.max && modelData.max % 1 !== 0) ||
                                                               (modelData.value && modelData.value % 1 !== 0);
                                            if (hasDecimals) {
                                                this.item.dFrom = modelData.min || 0;
                                                this.item.dTo = modelData.max || 100;
                                                this.item.dStepSize = (modelData.max - modelData.min) / 100 || 0.01;
                                                this.item.def_val = defVal || 0;
                                            } else {
                                                this.item.from = Math.floor(modelData.min || 0);
                                                this.item.to = Math.floor(modelData.max || 100);
                                                this.item.stepSize = 1;
                                                this.item.def_val = Math.floor(defVal || 0);
                                            }
                                            break;
                                        case 'color':
                                            // Color can be string "0.1 0.2 0.3" or object {r,g,b}
                                            let colorVal = "#ffffff";
                                            if (typeof defVal === 'string' && defVal.includes(' ')) {
                                                const parts = defVal.split(' ').map(Number);
                                                if (parts.length >= 3) {
                                                    colorVal = Qt.rgba(parts[0], parts[1], parts[2], 1.0);
                                                }
                                            } else if (defVal && typeof defVal === 'string') {
                                                colorVal = defVal;
                                            }
                                            this.item.def_val = colorVal;
                                            this.item.colorValue = colorVal;
                                            break;
                                        case 'combo':
                                            // Build model from options
                                            if (modelData.options) {
                                                const comboModel = [];
                                                for (const opt of modelData.options) {
                                                    let label = opt.label || opt.value;
                                                    // Convert localization keys to readable text
                                                    if (label && label.startsWith('ui_browse_properties_')) {
                                                        const suffix = label.replace('ui_browse_properties_', '');
                                                        label = suffix.split('_').map(w =>
                                                            w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
                                                        ).join(' ');
                                                    }
                                                    comboModel.push({
                                                        text: label,
                                                        value: opt.value
                                                    });
                                                }
                                                this.item.model = comboModel;
                                                this.item.def_val = defVal || 0;
                                            }
                                            break;
                                    }

                                    this.item.finish();
                                    this.item.onRes_valChanged.connect(() => {
                                        user_props_group.savePropChange(modelData.key, this.item.res_val);
                                    });
                                }
                            }
                        }
                    }
                }

                PlasmaComponents.TextArea {
                    id: descriptionTextArea
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    Layout.minimumHeight: implicitHeight

                    visible: false
                    text: ''
                    color: Kirigami.Theme.textColor

                    function loadDescription() {
                        const path = Common.getWpModelProjectPath(right_content.wpmodel);
                        if (path) {
                            pyext.readfile(Common.urlNative(path)).then(value => {
                                const project = Utils.parseJson(value);
                                const desc = project && project.description ? project.description : '';
                                descriptionTextArea.visible = Boolean(desc);
                                if (descriptionTextArea.visible) {
                                    descriptionTextArea.text = BBCode.parser.parse(desc);
                                }
                            }).catch(reason => console.error(`read '${path}' error\n`, reason));
                        } else {
                            descriptionTextArea.visible = false;
                        }
                    }

                    Connections {
                        target: right_content
                        function onWpmodelChanged() {
                            descriptionTextArea.loadDescription();
                        }
                    }
                    Component.onCompleted: loadDescription()

                    font.bold: false
 
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignLeft
                    readOnly: true

                    onLinkActivated: Qt.openUrlExternally(link)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                        acceptedButtons: Qt.NoButton
                    }
                }
            }
        }
    }
}
