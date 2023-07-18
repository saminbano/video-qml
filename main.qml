qml
import QtQuick 2.12
import QtMultimedia 5.12
Item {
    width: 400
    height: 300

    MediaPlayer {
        id: mediaPlayer
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        source: mediaPlayer
    }

    FileDialog {
        id: fileDialog
        title: "Select Video File"
        selectMultiple: false
        folder: shortcuts.home
        nameFilters: ["Video Files (*.mp4 *.avi *.mkv)"]
        onAccepted: {
            mediaPlayer.source = fileUrl
            mediaPlayer.play()
        }
    }

    Rectangle {
        id: controlBar
        width: parent.width
        height: 50
        color: "black"
        anchors.bottom: parent.bottom

        Button {
            id: playButton
            width: 50
            height: 50
            text: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
            onClicked: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                } else {
                    mediaPlayer.play()
                }
            }
        }

        Slider {
            id: progressSlider
            width: parent.width - playButton.width - 100
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            from: 0
            to: mediaPlayer.duration
            value: mediaPlayer.position
            onValueChanged: {
                mediaPlayer.position = value
            }
        }
    }

    MouseArea {
        id: progressMouseArea
        width: progressSlider.width
        height: progressSlider.height
        anchors.verticalCenter: progressSlider.verticalCenter
        anchors.horizontalCenter: progressSlider.horizontalCenter
        drag.target: progressSlider

        onReleased: {
            mediaPlayer.position = progressSlider.value
        }
    }

    Component.onCompleted: {
        fileDialog.open()
    }
}
