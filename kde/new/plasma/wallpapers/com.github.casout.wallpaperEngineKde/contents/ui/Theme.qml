pragma Singleton
import QtQuick 2.0
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: root_item

    // Реактивные привязки к Kirigami.Theme для автоматического обновления при смене темы
    property color textColor: Kirigami.Theme.textColor
    property color highlightColor: Kirigami.Theme.highlightColor
    property color highlightedTextColor: Kirigami.Theme.highlightedTextColor
    property color backgroundColor: Kirigami.Theme.backgroundColor
    property color activeBackgroundColor: Kirigami.Theme.activeBackgroundColor
    property color alternateBackgroundColor: Kirigami.Theme.alternateBackgroundColor
    property color linkColor: Kirigami.Theme.linkColor
    property color visitedLinkColor: Kirigami.Theme.visitedLinkColor
    property color positiveTextColor: Kirigami.Theme.positiveTextColor
    property color positiveBackgroundColor: Kirigami.Theme.positiveBackgroundColor
    property color neutralTextColor: Kirigami.Theme.neutralTextColor
    property color negativeTextColor: Kirigami.Theme.negativeTextColor
    property color disabledTextColor: Kirigami.Theme.disabledTextColor

    readonly property alias view: theme_view

    Item {
        id: theme_view
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false

        // Реактивные привязки для View colorSet
        property color textColor: Kirigami.Theme.textColor
        property color highlightColor: Kirigami.Theme.highlightColor
        property color highlightedTextColor: Kirigami.Theme.highlightedTextColor
        property color backgroundColor: Kirigami.Theme.backgroundColor
        property color activeBackgroundColor: Kirigami.Theme.activeBackgroundColor
        property color alternateBackgroundColor: Kirigami.Theme.alternateBackgroundColor
        property color linkColor: Kirigami.Theme.linkColor
        property color visitedLinkColor: Kirigami.Theme.visitedLinkColor
        property color positiveTextColor: Kirigami.Theme.positiveTextColor
        property color positiveBackgroundColor: Kirigami.Theme.positiveBackgroundColor
        property color neutralTextColor: Kirigami.Theme.neutralTextColor
        property color negativeTextColor: Kirigami.Theme.negativeTextColor
        property color disabledTextColor: Kirigami.Theme.disabledTextColor
    }
}
