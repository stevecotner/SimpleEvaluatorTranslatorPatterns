//
//  ObservingPageView.swift
//  RetailDemo
//
//  Created by Stephen E. Cotner on 6/28/20.
//

import SwiftUI
import Combine

protocol ObservingPageViewSection {
    var id: String { get }
}

protocol ObservingPageView_ViewMaker {
    associatedtype Section: ObservingPageViewSection
    func view(for: Section) -> AnyView
}

struct ObservingPageView<V: ObservingPageView_ViewMaker> : View {
    class Model: ObservableObject {
        @Published var sections: [V.Section]
        var scrollFocus: Passable<ScrollConfiguration> = Passable(wrappedValue: ScrollConfiguration(id: "", animation: .none, anchor: .top))
        var margin: CGFloat = 0
        
        init(_ sections: [V.Section] = []) {
            self.sections = sections
        }
    }
    
    @ObservedObject var model: ObservingPageView.Model
    var viewMaker: V
    
    init(viewMaker: V, model: ObservingPageView.Model) {
        self.viewMaker = viewMaker
        self.model = model
    }
    
    var body: some View {
        if model.sections.isEmpty {
            return AnyView(EmptyView())
        } else {
            return AnyView(
                VStack(spacing: 0) {
                    ScrollViewReader { scrollProxy in
                        ScrollView(showsIndicators: false) {
                            ForEach(model.sections, id: \.id) { section in
                                VStack(spacing: 0) {
                                    self.viewMaker.view(for: section)
                                    
                                    // Bottom Inset
                                    if (self.model.sections.firstIndex(where: {
                                        $0.id == section.id
                                    })) == self.model.sections.count - 1 {
                                        Spacer().frame(height:CGFloat(45))
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: self.model.margin, bottom: 0, trailing: self.model.margin))
                            }
                            .padding(.zero)
                        }
                        .padding(0)
                        .onReceive(model.scrollFocus.subject) { value in
                            if let scrollConfiguration = value {
                                withAnimation(scrollConfiguration.animation) {
                                    scrollProxy.scrollTo(
                                        scrollConfiguration.id,
                                        anchor: scrollConfiguration.anchor
                                    )
                                }
                            }
                        }
                    }
                    Spacer()
                }
            )
        }
    }
}

struct ScrollConfiguration {
    var id: String
    var animation: Animation?
    var anchor: UnitPoint
    
    enum ScrollAnchor {
        case top
        case center
        case bottom
    }
}
