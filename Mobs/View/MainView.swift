import SwiftUI
import WebKit

struct MainView: View {
    @ObservedObject var model: Model
    @State private var showingSettings = false
    @State private var wideSettings = false
    private var streamView: StreamView

    init(model: Model) {
        self.model = model
        streamView = StreamView(model: model)
    }

    private func hideSettings() {
        showingSettings = false
        // AppDelegate.orientationLock = .landscapeRight
    }

    private func showSettings() {
        showingSettings = true
        // AppDelegate.orientationLock = .all
    }

    private func splitImage() -> Image {
        if wideSettings {
            return Image(systemName: "rectangle.split.2x1")
        } else {
            return Image(systemName: "rectangle")
        }
    }

    private func settingsWidth() -> Double {
        if wideSettings {
            return 1.0
        } else {
            return 0.53
        }
    }

    var body: some View {
        ZStack {
            if showingSettings {
                GeometryReader { metrics in
                    HStack {
                        if !wideSettings {
                            ZStack {
                                streamView
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("Preview")
                                            .bold()
                                            .padding([.top], 5)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        }
                        ZStack {
                            NavigationStack {
                                SettingsView(model: model, hideSettings: hideSettings)
                            }
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        wideSettings.toggle()
                                    }, label: {
                                        splitImage()
                                    })
                                    Button(action: {
                                        hideSettings()
                                    }, label: {
                                        Text("Close")
                                    })
                                }
                                Spacer()
                            }
                            .padding([.top], 5)
                        }
                        .frame(width: metrics.size.width * settingsWidth())
                    }
                }
            } else {
                HStack(spacing: 0) {
                    ZStack {
                        GeometryReader { metrics in
                            streamView
                                .ignoresSafeArea()
                                .onTapGesture(count: 1) { location in
                                    guard model.database.tapToFocus! else {
                                        return
                                    }
                                    let x = (location.x / metrics.size.width)
                                        .clamped(to: 0 ... 1)
                                    let y = (location.y / metrics.size.height)
                                        .clamped(to: 0 ... 1)
                                    model.setFocusPointOfInterest(focusPoint: CGPoint(
                                        x: x,
                                        y: y
                                    ))
                                }
                                .onLongPressGesture(perform: {
                                    guard model.database.tapToFocus! else {
                                        return
                                    }
                                    model.setAutoFocus()
                                })
                        }
                        StreamOverlayView(model: model)
                    }
                    .gesture(
                        MagnificationGesture()
                            .onChanged { amount in
                                model.changeZoomLevel(amount: amount)
                            }
                            .onEnded { amount in
                                model.commitZoomLevel(amount: amount)
                            }
                    )
                    ControlBarView(model: model, showSettings: showSettings)
                }
            }
            if model.showingBitrate {
                GeometryReader { metrics in
                    HStack {
                        Spacer()
                        StreamVideoBitrateSettingsButtonView(model: model, done: {
                            model.showingBitrate = false
                        })
                        .frame(width: metrics.size.width * 0.5)
                    }
                }
            }
            if model.showingMic {
                GeometryReader { metrics in
                    HStack {
                        Spacer()
                        MicButtonView(model: model, done: {
                            model.showingMic = false
                        })
                        .frame(width: metrics.size.width * 0.5)
                    }
                }
            }
        }
        .toast(isPresenting: $model.showingToast, duration: 5) {
            model.toast
        }
    }
}
