//
//  ExampleZero-Screen.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Foundation
import SwiftUI

struct ExampleZero {}

extension ExampleZero {
    struct Screen: View {
        
        // Elements
        enum Element: EvaluatorElement {
            case textField
        }
        
        // Display State
        var textFieldModel: EvaluatingTextField.Model = EvaluatingTextField.Model(placeholder: "Type Something", elementName: Element.textField)
        var optionsModel: OptionsView.Model = OptionsView.Model(options: [], preference: nil)
        
        // Hideables
        var startButton = Hideable.Model(isShowing: true, removesContent: false, transition: nil)
        var textField = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        var typeHelloButton = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        var optionsView = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        
        init() {}
        
        var body: some View {
            VStack {
                Hideable(model: startButton) {
                    Button("Start") {
                        start()
                    }
                }
                Hideable(model: textField) {
                    EvaluatingTextField(model: textFieldModel, evaluator: self)
                }
                Hideable(model: typeHelloButton) {
                    Button("Type Hello") {
                        typeHello()
                    }
                }
                Hideable(model: optionsView) {
                    OptionsView(model: optionsModel, evaluator: self)
                }
            }.onAppear() {
                viewDidAppear()
            }
        }
        
        func viewDidAppear() {
            textFieldModel.passableText = ""
            startButton.isShowing = true
            textField.isShowing = false
            typeHelloButton.isShowing = false
            optionsView.isShowing = false
        }
        
        func start() {
            optionsModel.options = ["A", "B", "C"]
            startButton.isShowing = false
            textField.isShowing = true
            typeHelloButton.isShowing = true
            optionsView.isShowing = true
        }

        func typeHello() {
            textFieldModel.passableText = "Hello"
        }
    }
}

extension ExampleZero.Screen: TextFieldEvaluating, OptionsViewEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        switch elementName {
        case .textField:
            print("text: \(text)")
        }
    }
    
    func toggleOption(_ option: String) {
        let preference: String? = {
            if optionsModel.preference == option {
                return nil
            } else {
                return option
            }
        }()
        
        optionsModel.preference = preference
    }
}
