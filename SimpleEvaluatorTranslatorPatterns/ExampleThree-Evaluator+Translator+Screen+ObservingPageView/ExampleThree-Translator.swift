//
//  ExampleThree-Translator.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 10/24/20.
//

import Foundation
import Combine

extension ExampleThree {
    class Translator {
        typealias Evaluator = ExampleThree.Evaluator
        typealias Element = Evaluator.Element
        typealias State = Evaluator.State
        
        // Display State
        var pageModel = ObservingPageView<ExampleThree.ViewMaker>.Model()
        var textFieldModel = EvaluatingTextField.Model(placeholder: "Type Something", elementName: Element.textField)
        var optionsModel = OptionsView.Model(options: [], preference: nil)
        
        // State Sink
        var stateSink: AnyCancellable?
        
        init(_ state: Passable<State>) {
            debugPrint("init Retail Translator")
            
            stateSink = state.subject.sink { [weak self] value in
                if let value = value {
                    self?.translate(state: value)
                }
            }
        }
        
        deinit {
            debugPrint("deinit Retail Translator")
        }
    }
}

// MARK: Translating Business State to Display State

extension ExampleThree.Translator {
    func translate(state: State) {
        switch state {
            
        case .notStarted:
            translateNotStarted()
            
        case .started(let state):
            translateStarted(state)
        }
    }
    
    func translateNotStarted() {
        pageModel.sections = [
            .startButton(buttonElementName: Element.startButton)
        ]
    }
    
    func translateStarted(_ state: Evaluator.StartedState) {
        optionsModel.options = state.options
        optionsModel.preference = state.preference
        
        pageModel.sections = [
            .textFieldAndHelloButton(textFieldModel: textFieldModel, buttonElementName: Element.helloButton),
            .options(model: optionsModel)
        ]
    }
}

// MARK: Imperative Translating

extension ExampleThree.Translator {
    func typeHello() {
        textFieldModel.passableText = "Hello"
    }
}
