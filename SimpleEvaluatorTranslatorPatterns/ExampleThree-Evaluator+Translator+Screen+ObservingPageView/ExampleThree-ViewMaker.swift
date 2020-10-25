//
//  ExampleThree-ViewMaker.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 10/24/20.
//

import Foundation
import SwiftUI

extension ExampleThree {
    struct ViewMaker: ObservingPageView_ViewMaker {
        
        enum Section: ObservingPageViewSection {
            case startButton(buttonElementName: EvaluatorElement)
            case textFieldAndHelloButton(textFieldModel: EvaluatingTextField.Model, buttonElementName: EvaluatorElement)
            case options(model: OptionsView.Model)
            
            var id: String {
                switch self {
                case .startButton:              return "startButton"
                case .textFieldAndHelloButton:  return "textFieldAndHelloButton"
                case .options:                  return "options"
                }
            }
        }
        
        let evaluator: TextFieldEvaluating & OptionsViewEvaluating & ButtonEvaluating
        
        func view(for section: Section) -> AnyView {
            switch section {
            
            case .startButton(let elementName):
                return AnyView(
                    Button("Start") {
                        evaluator.buttonTapped(elementName)
                    }
                )
                
            case .textFieldAndHelloButton(let model, let elementName):
                return AnyView(
                    VStack {
                        EvaluatingTextField(model: model, evaluator: evaluator)
                        Button("Type Hello") {
                            evaluator.buttonTapped(elementName)
                        }
                    }
                )
                
            case .options(let model):
                return AnyView(
                    OptionsView(model: model, evaluator: evaluator)
                )
            }
        }
    }
}
