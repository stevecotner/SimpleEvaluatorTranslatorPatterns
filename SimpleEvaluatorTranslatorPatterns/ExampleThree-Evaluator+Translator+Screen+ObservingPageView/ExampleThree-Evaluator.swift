//
//  ExampleThree-Evaluator.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Combine
import Foundation
import SwiftUI

struct ExampleThree {}

extension ExampleThree {
    
    class Evaluator {
        // Translator
        lazy var translator: Translator = Translator($state)
        
        // State
        @Passable var state: State?
        
        // Elements
        enum Element: EvaluatorElement {
            case textField
            case startButton
            case helloButton
        }
        
        init() {}
    }
}

// MARK: - States

extension ExampleThree.Evaluator {
    enum State: EvaluatorState {
        case notStarted
        case started(StartedState)
    }
    
    struct StartedState {
        var text: String
        var options: [String]
        var preference: String?
    }
}

extension ExampleThree.Evaluator: TextFieldEvaluating, OptionsViewEvaluating, ButtonEvaluating {
    
    func viewDidAppear() {
        if state == nil {
            state = .notStarted
        }
    }
    
    // Buttons
    
    func buttonTapped(_ elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        
        switch elementName {
        case .startButton:
            start()
            
        case .helloButton:
            typeHello()
            
        default:
            break
        }
    }
    
    func start() {
        state = .started(
            StartedState(
                text: "",
                options: ["One", "Two", "Three"],
                preference: nil
            )
        )
    }

    func typeHello() {
        translator.typeHello()
    }
    
    // Text
    
    /// We must be in the `started` state to change text in the element `.textField`.
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        
        switch elementName {
        case .textField:
            guard case var .started(startedState) = state else { return }

            startedState.text = text
            self.state = .started(startedState)
            print("text: \(text)")
            
        default:
            break
        }
    }
    
    // Options
    
    /// We must be in the `started` state to toggle an option.
    func toggleOption(_ option: String) {
        guard case var .started(startedState) = state else { return }
        
        let preference: String? = {
            if startedState.preference == option {
                return nil
            } else {
                return option
            }
        }()
        
        startedState.preference = preference
        
        self.state = .started(startedState)
    }
}
