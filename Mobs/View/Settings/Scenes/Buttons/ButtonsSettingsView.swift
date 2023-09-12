import SwiftUI

struct ButtonsSettingsView: View {
    @ObservedObject var model: Model

    var database: Database {
        get {
            model.database
        }
    }

    func isButtonUsed(button: SettingsButton) -> Bool {
        for scene in database.scenes {
            for sceneButton in scene.buttons {
                if sceneButton.buttonId == button.id {
                    return true
                }
            }
        }
        return false
    }

    var body: some View {
        Form {
            Section {
                List {
                    ForEach(database.buttons) { button in
                        NavigationLink(destination: ButtonSettingsView(button: button, model: model)) {
                            IconAndTextView(image: button.systemImageNameOff, text: button.name)
                        }
                        .deleteDisabled(isButtonUsed(button: button))
                    }
                    .onMove(perform: { (froms, to) in
                        database.buttons.move(fromOffsets: froms, toOffset: to)
                        model.store()
                        model.sceneUpdated()
                    })
                    .onDelete(perform: { offsets in
                        database.buttons.remove(atOffsets: offsets)
                        model.store()
                        model.sceneUpdated()
                    })
                }
                CreateButtonView(action: {
                    database.buttons.append(SettingsButton(name: "My button"))
                    model.store()
                    model.sceneUpdated()
                })
            } footer: {
                Text("Only unused buttons can be deleted.")
            }
        }
        .navigationTitle("Buttons")
    }
}

