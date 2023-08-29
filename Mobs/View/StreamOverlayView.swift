import Combine
import Foundation
import SwiftUI

struct IconAndText: View {
    var image: String
    var text: String

    var body: some View {
        HStack {
            Image(systemName: image)
                .frame(width: 12, height: 12)
                .font(.system(size: 13))
            TextView(text: text)
                .font(.system(size: 13))
        }
    }
}

struct TextView: View {
    var text: String

    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.white)
        }
        .padding(2)
        .background(.black)
        .cornerRadius(5)
    }
}

struct Variable: View {
    var name: String
    @State var value: String

    var body: some View {
        VStack(spacing: 0) {
            Text(name)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .padding([.top, .trailing, .leading], 5)
            TextField(
                "   ",
                text: $value
            )
            .onSubmit {
                print(value)
            }
            .font(.system(size: 20))
            .fixedSize()
            .padding([.bottom, .trailing, .leading], 5)
        }
        .background(.black)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary)
        )
    }
}

struct LeadingOverlayView: View {
    @ObservedObject var model: Model

    var database: Database {
        get {
            model.settings.database
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if database.viewers {
                IconAndText(image: "person.2.fill", text: model.numberOfViewers)
            }
            if database.uptime {
                IconAndText(image: "deskclock.fill", text: model.uptime)
            }
            Spacer()
            if database.chat {
                Image(systemName: "message.fill")
                    .frame(width: 12, height: 12)
                    .font(.system(size: 13))
                ChatView(posts: model.twitchChatPosts)
            }
        }
    }
}

struct TrailingOverlayView: View {
    @ObservedObject var model: Model

    var database: Database {
        get {
            model.settings.database
        }
    }

    var body: some View {
        VStack(alignment: .trailing) {
            TextView(text: model.fps)
                .font(.system(size: 13))
            Spacer()
            Variable(name: "Earnings", value: "10.32")
            Picker("", selection: Binding(get: {
                model.selectedScene
            }, set: { (scene) in
                model.selectedScene = scene
            })) {
                ForEach(database.scenes.filter({scene in scene.enabled}).map({scene in scene.name}), id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: CGFloat(50 * database.scenes.filter({scene in scene.enabled}).count))
            .colorInvert()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.secondary)
            )
        }
    }
}

struct StreamOverlayView: View {
    @ObservedObject var model: Model

    var body: some View {
        HStack {
            LeadingOverlayView(model: model)
            Spacer()
            TrailingOverlayView(model: model)
        }.padding([.trailing, .top])
    }
}

struct StreamOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        StreamOverlayView(model: Model())
    }
}