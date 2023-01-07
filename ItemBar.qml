import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.15
import "Lists"
import "utils.js" as Utils

FocusScope {
	id: root
	
	property var currentItem: { if (gameAxis.model != null) {
									if (collectionIdx == -2) {
										return listFavorites.currentGame(gameAxis.currentIndex)
									} else if (collectionIdx == -1) {
										return listRecent.currentGame(gameAxis.currentIndex)
									} else if (collectionIdx >= 0 || collectionIdx == -3) {
										return gameAxis.model.get(gameAxis.currentIndex)
									} else {
										return null
									}
								}}	
	property var collectionIdx
	
	//signal settings
	
	FontLoader { id: generalFont; source: "assets/fonts/font.ttf" }
	ListLastPlayed  { id: listRecent; max: 10 }
	ListFavorites { id: listFavorites; max: 10 }
	
	function update(l) {
		gameAxis.model = null;

		if (l == -3) {
			gameAxis.model = itemListModel;
		}
		if (l == -2) {
			gameAxis.model = listFavorites.games;
		}
		if (l == -1) {
			gameAxis.model = listRecent.games;
		}
		if (l >= 0) {
			gameAxis.model= api.collections.get(l).games;
		}
	}
	
	//onIdxCollectionChanged: {
	//	gameAxis.model = null;
	//	itemListModel.buildList(idxCollection);
	//	gameAxis.model = itemListModel;
	//}

	ListModel {
    id: itemListModel
		Component.onCompleted: {
        append({
            title: "Image 1",
			description: "Option description",
            assets: { tile: "assets/icons/setting.png", background: "assets/background/xmb-wave-2.jpg" }
        });
        append({
            title: "Image 2",
			description: "Option description",
            assets: { tile: "assets/icons/setting.png", background: "assets/background/xmb-wave-2.jpg" }
        });
        append({
            title: "Image 3",
			description: "Option description",
            assets: { tile: "assets/icons/setting.png", background: "assets/background/xmb-wave-2.jpg" }
        });
    }
    }

	ListView {
		id: gameAxis
		//property var currentGame: model.get(currentIndex)

		x: root.focus ? vpx(325) : vpx(120)
        y: vpx(5)
		
		Behavior on x { NumberAnimation { duration: 200; 
            easing.type: Easing.OutCubic;
            easing.amplitude: 2.0;
            easing.period: 1.5 
            }
        }
		
		height: parent.height
		width: vpx(512)

		orientation: ListView.Vertical
		
		model: itemListModel //itemListModel.buildList(collectionBar.currentCollection.idx) //collectionBar.currentCollection.idx >= 0 ? api.collections.get(collectionBar.currentCollection.idx).games : (collectionBar.currentCollection.idx == -1 ? listRecent.games : (collectionBar.currentCollection.idx == -2 ? itemListModel : ""))
		
        delegate: gameAxisDelegate
        spacing: vpx(10)
				
		snapMode: ListView.SnapOneItem
		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightMoveDuration : 200
		highlightMoveVelocity : 1000
				
		preferredHighlightBegin: vpx(132)
		preferredHighlightEnd: preferredHighlightBegin + vpx(60)// + vpx(240) // the width of one game box
	
		clip: true
		focus: true
		
		Keys.onRightPressed: { 
            event.accepted = true;
			collectionBar.list.incrementCurrentIndex()
        }
		Keys.onLeftPressed: { 
            event.accepted = true;
			collectionBar.list.decrementCurrentIndex() //moveElement(-1)
        }
		
	}
	
	Component {
        id: gameAxisDelegate

		Item {
			property bool selected: ListView.isCurrentItem

			height: selected ? vpx(290) : vpx(32)
			opacity: selected ? 1.0 : (root.focus ? 0.4 : 0.0)
			
			RowLayout{
				anchors.fill: parent
				
				Item {		
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignLeft
					
					Layout.leftMargin: selected ? vpx(8) : vpx(20)
					Layout.topMargin: selected ? vpx(156) : vpx(0)
					Layout.bottomMargin: selected ? vpx(74) : vpx(0)

					implicitWidth: selected ? vpx(62) : vpx(32)
	
					Image {
						asynchronous: true
						anchors.fill: parent
						fillMode: Image.PreserveAspectFit
						source: assets.tile
					}
				}
				
				ColumnLayout{
				
					//Layout.fillHeight: true
					//Layout.alignment: Qt.AlignLeft
					opacity: root.focus ? 1.0 : 0.0
					
					Layout.leftMargin: selected ? vpx(22) : vpx(40)
					Layout.topMargin: selected ? vpx(80) : vpx(2)
					
					Text {

						text: title
						color: "white"
					
						font.family: generalFont.name
						font.pointSize: 22
					}
					
					Text {
						//Layout.fillHeight: true
						//Layout.alignment: Qt.AlignLeft
					
						//Layout.leftMargin: selected ? vpx(18) : vpx(40)
						//Layout.topMargin: selected ? vpx(180) : vpx(2)
					
						text: collectionIdx > -3 ? ("Last Played: " + (lastPlayed == "Invalid Date" ? "Never" : Qt.formatDateTime(lastPlayed, "d/MM/yyyy hh:mm"))) : description
						color: "white"
					
						font.family: generalFont.name
						font.pointSize: 12
						
						visible: selected ? true : false
					}
				}
			}
		}
    }
	
	Keys.onPressed: {
			
			if (api.keys.isAccept(event) && !event.isAutoRepeat){
				event.accepted = true;
				if ( collectionIdx == -3 ) {
					//gameDetails.focus = true;
					//settings();
					root.focus = false
				} else {
					root.currentItem.launch();
				}
			}
		}
}
