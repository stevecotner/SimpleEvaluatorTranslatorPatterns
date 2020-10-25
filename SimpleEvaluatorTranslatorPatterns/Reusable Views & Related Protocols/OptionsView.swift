//
//  OptionsView.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/27/20.
//

import SwiftUI

protocol OptionsViewEvaluating {
    func toggleOption(_ option: String)
}

struct OptionsView: View {
    class Model: ObservableObject {
        @Published var options: [String]
        @Published var preference: String?
        
        init(options: [String], preference: String?) {
            self.options = options
            self.preference = preference
        }
    }
    
    @ObservedObject var model: Model
    let evaluator: OptionsViewEvaluating
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(model.options, id: \.self) { option in
                VStack(alignment: .leading, spacing: 0) {
                    OptionView(option: option, preference: self.model.preference, evaluator: self.evaluator)
                    Spacer().frame(height: 16)
                }
            }
            Spacer().frame(height: 18)
        }
    }
}

struct OptionView: View {
    let option: String
    let preference: String?
    let evaluator: OptionsViewEvaluating
    
    var body: some View {
        let isSelected = self.option == self.preference
        return Button(self.option) {
            self.evaluator.toggleOption(option)
        }
        .buttonStyle(OptionButtonStyle(isSelected: isSelected))
        .padding(0)
        .foregroundColor(.primary)
    }
}

struct OptionButtonStyle: ButtonStyle {
    let isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .opacity(.leastNonzeroMagnitude)
            HStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: configuration.isPressed ? 23 : isSelected ? 25 : 24, height: configuration.isPressed ? 23 : isSelected ? 25 : 24)
                        .padding(EdgeInsets(top: configuration.isPressed ? 1 : isSelected ? 0 : 0.5, leading: configuration.isPressed ? 40 : isSelected ? 39 : 39.5, bottom: configuration.isPressed ? 1 : isSelected ? 0 : 0.5, trailing: 0))
                        .animation(.linear(duration: 0.1), value: isSelected)

                    configuration.label
                        .font(Font.headline)
                        .layoutPriority(20)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 0.5, leading: 76, bottom: 0, trailing: 76))
                }
                .foregroundColor(Color.primary.opacity(configuration.isPressed ? 0.3 : 1))
                
                Spacer()
            }
        }
    }
}
