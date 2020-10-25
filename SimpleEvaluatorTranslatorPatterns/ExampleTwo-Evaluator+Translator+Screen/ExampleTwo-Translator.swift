//
//  ExampleTwo-Translator.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 10/24/20.
//

import Foundation
import Combine

extension ExampleTwo {
    class Translator {
        typealias Evaluator = ExampleTwo.Evaluator
        typealias Element = Evaluator.Element
        typealias State = Evaluator.State
        
        // Display State:
        // View Models
        var textFieldModel = EvaluatingTextField.Model(placeholder: "Type Something", elementName: Element.textField)
        var optionsModel = OptionsView.Model(options: [], preference: nil)
        
        // Hideable Models
        var startButton = Hideable.Model(isShowing: true, removesContent: false, transition: nil)
        var textField = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        var typeHelloButton = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        var optionsView = Hideable.Model(isShowing: false, removesContent: false, transition: nil)
        
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

extension ExampleTwo.Translator {
    func translate(state: State) {
        switch state {
            
        case .notStarted:
            translateNotStarted()
            
        case .started(let state):
            translateStarted(state)
        }
    }
    
    func translateNotStarted() {
        startButton.isShowing = true
        textField.isShowing = false
        typeHelloButton.isShowing = false
        optionsView.isShowing = false
    }
    
    func translateStarted(_ state: Evaluator.StartedState) {
        optionsModel.options = state.options
        optionsModel.preference = state.preference
        startButton.isShowing = false
        textField.isShowing = true
        typeHelloButton.isShowing = true
        optionsView.isShowing = true
    }
}

// MARK: Imperative Translating

extension ExampleTwo.Translator {
    func typeHello() {
        textFieldModel.passableText = "Hello"
    }
}
