//
//  ExampleTwo-Screen.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Foundation
import SwiftUI

extension ExampleTwo {
    struct Screen: View {
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            VStack {
                Hideable(model: translator.startButton) {
                    Button("Start") {
                        evaluator.start()
                    }
                }
                
                Hideable(model: translator.textField) {
                    EvaluatingTextField(model: translator.textFieldModel, evaluator: evaluator)
                }
                
                Hideable(model: translator.typeHelloButton) {
                    Button("Type Hello") {
                        evaluator.typeHello()
                    }
                }
                
                Hideable(model: translator.optionsView) {
                    OptionsView(model: translator.optionsModel, evaluator: evaluator)
                }
            }.onAppear() {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
