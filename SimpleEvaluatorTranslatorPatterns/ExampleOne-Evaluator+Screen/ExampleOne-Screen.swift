//
//  ExampleOne-Screen.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Foundation
import SwiftUI

extension ExampleOne {
    struct Screen: View {
        typealias Element = Evaluator.Element
        
        let evaluator: Evaluator
        
        init() {
            evaluator = Evaluator()
        }
        
        var body: some View {
            VStack {
                Hideable(model: evaluator.startButton) {
                    Button("Start") {
                        evaluator.start()
                    }
                }
                Hideable(model: evaluator.textField) {
                    EvaluatingTextField(model: evaluator.textFieldModel, evaluator: evaluator)
                }
                Hideable(model: evaluator.typeHelloButton) {
                    Button("Type Hello") {
                        evaluator.typeHello()
                    }
                }
                Hideable(model: evaluator.optionsView) {
                    OptionsView(model: evaluator.optionsModel, evaluator: evaluator)
                }
            }.onAppear() {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
