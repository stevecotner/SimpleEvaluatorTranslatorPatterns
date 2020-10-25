//
//  ExampleTwo-Evaluator.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Combine
import Foundation
import SwiftUI

struct ExampleTwo {}

extension ExampleTwo {
    
    class Evaluator {
        // Translator
        lazy var translator: Translator = Translator($state)
        
        // State
        @Passable var state: State?
        
        // Elements
        enum Element: EvaluatorElement {
            case textField
        }
        
        init() {}
    }
}

// MARK: - States

extension ExampleTwo.Evaluator {
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

extension ExampleTwo.Evaluator: TextFieldEvaluating, OptionsViewEvaluating {
    
    func viewDidAppear() {
        if state == nil {
            state = .notStarted
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
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        guard let elementName = elementName as? Element else { return }
        
        switch elementName {
        case .textField:
            guard case var .started(startedState) = state else { return }

            startedState.text = text
            self.state = .started(startedState)
            print("text: \(text)")
        }
    }
    
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
