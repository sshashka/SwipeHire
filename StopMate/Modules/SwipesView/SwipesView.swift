//
//  SwipesView.swift
//  StopMate
//
//  Created by Саша Василенко on 07.05.2024.
//

import SwiftUI
import CardStack

struct SwipesView<ViewModel>: View where ViewModel: SwipesViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedIndex = 0
    @State private var isShowingContent: Bool = false
    @Namespace var nsCard
    var body: some View {
        VStack(alignment: .center) {
            if !viewModel.data.isEmpty {
                ZStack(alignment: .center) {
//                    VStack {
                        CardStack(direction: LeftRight.direction, data: viewModel.vms, onSwipe: { card, direction in
                            print(card, direction)
                            if direction == .right {
                                viewModel.swippedLeft(on: viewModel.data[selectedIndex])
                            }
                            selectedIndex += 1
                        }, content: { card, direction, isOnTop in
                            CardView(vm: card, isShowingContent: $isShowingContent)
//                                .frame(width: 100, height: 100)
                                .transition(.scale(scale: 1))
                                .matchedGeometryEffect(id: "ID", in: nsCard, properties: .size)                           
                                .onTapGesture {
                                    isShowingContent = true
                                }
                        })
                        .opacity(isShowingContent ? 0 : 1)
//                    }
                    
                    if isShowingContent {
                        VStack {
                            CardView(vm: viewModel.vms[selectedIndex], isShowingContent: $isShowingContent)
                                .matchedGeometryEffect(id: "ID", in: nsCard)
                            Button {
                                viewModel.getRecommendation(on: selectedIndex)
                            } label: {
                                Text("Спитати в ші про виконавця")
                            }.buttonStyle(StandartButtonStyle())
                        }
                        
                    }
                }.padding(20)
            }
        }
    }
}

#Preview {
    SwipesView(viewModel: SwipesViewModel(jobCategory: .Java, storageService: FirebaseStorageService()))
}
