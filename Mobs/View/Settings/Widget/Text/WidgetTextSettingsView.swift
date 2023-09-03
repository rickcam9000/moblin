//
//  WidgetTextSettingsView.swift
//  Mobs
//
//  Created by Erik Moqvist on 2023-09-02.
//

import SwiftUI

struct WidgetTextSettingsView: View {
    @ObservedObject var model: Model
    var widget: SettingsWidget
    
    func submitFormatString(value: String) {
        widget.text.formatString = value
        model.store()
    }
    
    var body: some View {
        Section(widget.type) {
            NavigationLink(destination: TextEditView(title: "Format string", value: widget.text.formatString, onSubmit: submitFormatString)) {
                TextItemView(name: "Format string", value: widget.text.formatString)
            }
        }
    }
}

struct WidgetTextSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTextSettingsView(model: Model(), widget: SettingsWidget(name: ""))
    }
}
