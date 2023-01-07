import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQml.Models 2.10
import QtQuick.Layouts 1.1
import "Lists"
import "utils.js" as Utils
import "qrc:/qmlutils" as PegasusUtils

FocusScope {
id: root
    
	property var currentGame
	property var collectionIdx
	
	signal exit
	
	onCurrentGameChanged: {
		detailedAxis.model = null;
		
		if (currentGame != null) {
			if (collectionIdx > -3) {
				if (currentGame.favorite) {
					detailedListModel.get(1).tile = "assets/icons/favorite.png";
					detailedListModel.get(1).description = "Mark as unfavorite";
				} else {
					detailedListModel.get(1).tile = "assets/icons/unfavorite.png";
					detailedListModel.get(1).description = "Mark as favorite";
				}
				detailedAxis.model = detailedListModel;
			} else {
				detailedAxis.model = settingsListModel;
			}
		}
		
		
	}
	
    onFocusChanged: {
		if (focus) {
			introAnim.restart();
		} else {
			introAnim.stop();
			detailed.opacity = 0;
		} 
    }
	
	ListModel {
    id: detailedListModel
		Component.onCompleted: {
        append({
            title: "Play",
			description: "Play game",
			tile: "assets/icons/run.png",
            type: "setting"
        });
        append({
            title: "Favorite",
			description: "Mark as favorite",
			tile: "assets/icons/favorite.png",
			type: "setting"
        });
    }
    }
	
	ListModel {
    id: settingsListModel
		Component.onCompleted: {
        append({
            title: "Setting 1",
			description: "Option description",
            tile: "assets/icons/setting.png"
        });
        append({
            title: "Setting 2",
			description: "Option description",
            tile: "assets/icons/setting.png"
        });
    }
    }
	
    SequentialAnimation {
    id: introAnim

        running: false
        //NumberAnimation { target: detailed; property: "opacity"; to: 0; duration: 100 }
        PauseAnimation  { duration: 100 }
        ParallelAnimation {
            NumberAnimation { target: detailed; property: "opacity"; from: 0; to: 1; duration: 400;
                easing.type: Easing.OutCubic;
                easing.amplitude: 2.0;
                easing.period: 1.5 
            }
            NumberAnimation { target: detailed; property: "y"; from: 50; to: 0; duration: 400;
                easing.type: Easing.OutCubic;
                easing.amplitude: 2.0;
                easing.period: 1.5 
            }
        }
    }
	
	
	
	Item {
		id: detailed
		//anchors.fill: parent
		opacity: 0.0
		
		height: root.height
		width: root.width
		
		ListView {
		id: detailedAxis
		//property var currentGame: model.get(currentIndex).game

		x: vpx(70) //root.focus ? vpx(325) : vpx(120)
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
		
		model: collectionIdx == -3 ? settingsListModel : detailedListModel //itemListModel //itemListModel.buildList(collectionBar.currentCollection.idx) //collectionBar.currentCollection.idx >= 0 ? api.collections.get(collectionBar.currentCollection.idx).games : (collectionBar.currentCollection.idx == -1 ? listRecent.games : (collectionBar.currentCollection.idx == -2 ? itemListModel : ""))
		
        delegate: detailedAxisDelegate
        spacing: vpx(10)
				
		snapMode: ListView.SnapOneItem
		highlightRangeMode: ListView.StrictlyEnforceRange
		highlightMoveDuration : 200
		highlightMoveVelocity : 1000
				
		preferredHighlightBegin: vpx(282)
		preferredHighlightEnd: preferredHighlightBegin + vpx(60)// + vpx(240) // the width of one game box
	
		clip: true
		focus: true
		
		
		
		Keys.onLeftPressed: { 
            event.accepted = true;
			exit();
        }
	}
	
	Component {
        id: detailedAxisDelegate

		Item {
			property bool selected: ListView.isCurrentItem

			height: selected ? vpx(72) : vpx(32)
			opacity: selected ? 1.0 : (root.focus ? 0.4 : 0.0)
					
			RowLayout{
				anchors.fill: parent
				
				
				Item {		
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignLeft
					
					Layout.leftMargin: selected ? vpx(8) : vpx(20)
					Layout.topMargin: selected ? vpx(5) : vpx(0)
					Layout.bottomMargin: selected ? vpx(5) : vpx(0)

					implicitWidth: selected ? vpx(62) : vpx(32)
					
					Image {
						asynchronous: true
						anchors.fill: parent
						source: tile //"assets/icons/setting.png" //icon //modelData.assets.tile
					}
				}
				
				ColumnLayout{
				
					//Layout.fillHeight: true
					//Layout.alignment: Qt.AlignLeft
					opacity: root.focus ? 1.0 : 0.0
					
					Layout.leftMargin: selected ? vpx(22) : vpx(40)
					//Layout.topMargin: selected ? vpx(80) : vpx(2)
					
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
					
						text: description //"Last Played: " + description//(modelData.lastPlayed == "Invalid Date" ? "Never" : modelData.lastPlayed)
						color: "white"
					
						font.family: generalFont.name
						font.pointSize: 12
						
						visible: selected ? true : false
					}
				}
			}
		}
    }	
	
		Image {
			anchors {
				//left: descriptionText.left;// leftMargin: vpx(250)
				//right: descriptionText.right;// rightMargin: vpx(50)
				//top: parent.top; topMargin: vpx(10)
				bottom: descriptionText.top; bottomMargin: vpx(5)
				horizontalCenter: descriptionText.horizontalCenter
			}			
		
			//height: vpx(96)
			width: vpx(168)
		
			fillMode: Image.PreserveAspectFit
		
			source: { if (collectionIdx > -3) return currentGame.assets.logo }
			visible: collectionIdx > -3 ? true : false
		}
	
		Text {
		id: descriptionText
			anchors {
					left: parent.left; leftMargin: vpx(350)
				right: parent.right;
				top: parent.top; topMargin: vpx(250)
				bottom: parent.bottom; bottomMargin: vpx(100)
			}			
		
			horizontalAlignment:  Text.AlignJustify
			text: currentGame != null ? currentGame.description : "" //"Last Played: " + description//(modelData.lastPlayed == "Invalid Date" ? "Never" : modelData.lastPlayed)
			color: "white"
					
			font.family: generalFont.name
			font.pointSize: 22
		
			wrapMode: Text.WordWrap
						
			visible: collectionIdx > -3 ? true : false
		}
	}
	
	Keys.onPressed: {
			
			if (api.keys.isAccept(event) && !event.isAutoRepeat){
				event.accepted = true;
				if (detailedAxis.currentIndex == 0) {
						root.currentGame.launch();
				}
				if (detailedAxis.currentIndex == 1) {
					root.currentGame.favorite = !root.currentGame.favorite;
					if (root.collectionIdx == -2) exit();
					
					if (root.currentGame.favorite) {
						detailedAxis.model.get(1).tile = "assets/icons/favorite.png"
						detailedListModel.get(1).description = "Mark as unfavorite";
					} else {
						detailedAxis.model.get(1).tile = "assets/icons/unfavorite.png"
						detailedListModel.get(1).description = "Mark as favorite";
					}
				}
			}
			if (api.keys.isCancel(event)){
				event.accepted = true;
				exit();
			}
		}
}