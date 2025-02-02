import HaishinKit
import SwiftUI

struct StreamView: UIViewRepresentable {
    @EnvironmentObject var model: Model

    func makeUIView(context _: Context) -> MTHKView {
        return model.mthkView
    }

    func updateUIView(_: MTHKView, context _: Context) {}
}
