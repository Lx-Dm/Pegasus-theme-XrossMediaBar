import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.15
import "Lists"
import "utils.js" as Utils

FocusScope {
	id: root
	
	property var currentCollection: {if (collectionAxis.model != null) return collectionAxis.model.get(collectionAxis.currentIndex)}
	//property var currentCollectionName: {if (collectionAxis.model != null) return collectionAxis.model.get(collectionAxis.currentIndex).name}
	property alias list: collectionAxis
	property bool active
	
	signal collectionChanged

	FontLoader { id: generalFont; source: "assets/fonts/font.ttf" }
	
	
	onCurrentCollectionChanged: {
		collectionChanged();
	}

	ListModel {
    id: collectionListModel

        Component.onCompleted: {
            //clear();
            buildList();
			collectionAxis.currentIndex = 2;
        }

        function buildList() {
		    append({
                "name":         "Settings", 
                "idx":          -3,
                "icon":         "assets/icons/settings.png"//,
                //"background":   "assets/background/xmb-wave-2.jpg"
            })
			append({
                "name":         "Favorites", 
                "idx":          -2, 
                "icon":         "assets/icons/favorites.png"//,
                //"background":   "assets/background/xmb-wave-2.jpg"
            })
            append({
                "name":         "Recent Played", 
                "idx":          -1, 
                "icon":         "assets/icons/history.png"//,
                //"background":   "assets/background/xmb-wave-2.jpg"
            })
			
            for(var i=0; i<api.collections.count; i++) {
                append(createListElement(api.collections.get(i), i));
            }
        }
        
        function createListElement(element, i) {
            return {
                name:       element.name,
                idx:        i,
                icon:       "assets/icons/" + element.name + ".png",
                background: ""
            }
        }
    }

	ListView {
		id: collectionAxis
		
		//Component.onCompleted: currentIndex = -1;

		x: active ? vpx(5) : vpx(-200)
        y: vpx(5)
		
		Behavior on x { NumberAnimation { duration: 200; 
            easing.type: Easing.OutCubic;
            easing.amplitude: 2.0;
            easing.period: 1.5 
            }
        }
		
		// span from left to right, from the label's bottom to the row's bottom
		//anchors {
        //    left: parent.left
        //    right: parent.right
		//	top: parent.top; //topMargin: vpx(156)
			//bottom: parent.bottom
        //}
		height: vpx(72)
		width: parent.width

		// this one goes horizontal!
		orientation: ListView.Horizontal
				
		model: collectionListModel //api.collections
        delegate: collectionAxisDelegate
        spacing: vpx(10) // some spacing to make it look fancy
				
		snapMode: ListView.SnapOneItem
		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightMoveDuration : 200
		highlightMoveVelocity : 1000
				
		//displayMarginBeginning: vpx(50)
        //displayMarginEnd: vpx(150)
		preferredHighlightBegin: vpx(298)
		preferredHighlightEnd: preferredHighlightBegin + vpx(60) // the width of one game box
	
		clip: true
	}

	Component {
        id: collectionAxisDelegate

		Item {
			property bool selected: ListView.isCurrentItem
			//property var gameData: searchtext ? modelData : listRecent.currentGame(idx)
			opacity: selected ? 0.9 : (itemBar.focus ? 0.6 : 0.0)
			anchors {
				
				verticalCenter: parent.verticalCenter
					//horizontalCenter: parent.horizontalCenter
					//bottom: 
				//left: parent.left; leftMargin: vpx(64)
				//right: parent.right; rightMargin: vpx(64)
			}
			
			height: selected ? vpx(72) : vpx(36)
            width: selected ? height + vpx(48) :  height + vpx(88)
				
			Image {
				anchors {
					left: parent.left; leftMargin: selected ? vpx(23) : vpx(43)
					right: parent.right; rightMargin: selected ? vpx(23) : vpx(43)
					//top: parent.top
					//bottom: parent.bottom
				}
				fillMode: Image.PreserveAspectFit
				source: icon //"assets/icons/PC.png"
				sourceSize: Qt.size(parent.width, parent.height)
				smooth: true
			}
		}
    }
}
