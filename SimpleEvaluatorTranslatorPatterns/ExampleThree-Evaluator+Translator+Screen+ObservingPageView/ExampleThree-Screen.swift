//
//  ExampleThree-Screen.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Foundation
import SwiftUI

extension ExampleThree {
    struct Screen: View {
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            ObservingPageView(viewMaker: ViewMaker(evaluator: evaluator), model: translator.pageModel)
            .onAppear() {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
