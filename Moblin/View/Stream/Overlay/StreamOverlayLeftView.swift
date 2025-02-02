import SwiftUI
import WebKit

struct LeftOverlayView: View {
    @EnvironmentObject var model: Model

    var database: Database {
        model.settings.database
    }

    var stream: SettingsStream {
        model.stream
    }

    func streamText() -> String {
        var proto: String
        if stream.getProtocol() == .srt && stream.isSrtla() {
            proto = "SRTLA"
        } else if stream.getProtocol() == .rtmp && stream.isRtmps() {
            proto = "RTMPS"
        } else {
            proto = stream.getProtocol().rawValue
        }
        let resolution = stream.resolution.rawValue
        let codec = stream.codec.rawValue
        var bitrate = formatBytesPerSecond(speed: Int64(stream.bitrate))
        if stream.getProtocol() == .srt && stream.adaptiveBitrate {
            bitrate = "<\(bitrate)"
        }
        return "\(stream.name) (\(resolution), \(stream.fps), \(codec), \(proto), \(bitrate))"
    }

    func viewersText() -> String {
        if !model.isViewersConfigured() {
            return "Not configured"
        } else if model.isTwitchPubSubConnected() {
            return model.numberOfViewers
        } else {
            return ""
        }
    }

    func viewersColor() -> Color {
        if model.stream.twitchChannelId == "" {
            return .white
        } else if model.isTwitchPubSubConnected() {
            return .white
        } else {
            return .red
        }
    }

    func messageText() -> String {
        if !model.isChatConfigured() {
            return "Not configured"
        } else if model.isChatConnected() {
            return String(
                format: "%@ (%@ total)",
                model.chatPostsRate,
                countFormatter.format(model.chatPostsTotal)
            )
        } else {
            return ""
        }
    }

    func messageColor() -> Color {
        if !model.isChatConfigured() {
            return .white
        } else if model.isChatConnected() && model.hasChatEmotes() {
            return .white
        } else {
            return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            if database.show.stream {
                StreamOverlayIconAndTextView(
                    icon: "dot.radiowaves.left.and.right",
                    text: streamText()
                )
            }
            if database.show.microphone {
                StreamOverlayIconAndTextView(
                    icon: "music.mic",
                    text: model.mic.name
                )
            }
            if database.show.zoom {
                StreamOverlayIconAndTextView(
                    icon: "magnifyingglass",
                    text: String(format: "%.1f", model.zoomX())
                )
            }
            if model.database.show.chat {
                StreamOverlayIconAndTextView(
                    icon: "message",
                    text: messageText(),
                    color: messageColor()
                )
            }
            if database.show.viewers {
                StreamOverlayIconAndTextView(
                    icon: "eye",
                    text: viewersText(),
                    color: viewersColor()
                )
            }
            Spacer()
        }
    }
}
