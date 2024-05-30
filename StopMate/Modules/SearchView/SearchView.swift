//
//  SearchView.swift
//  StopMate
//
//  Created by Саша Василенко on 07.05.2024.
//

import SwiftUI

struct SearchView<ViewModel>: View where ViewModel: SearchViewModelProtocol {
    @StateObject var viewModel: ViewModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    var body: some View {
        VStack {
            Text("Оберіть домен виконавця")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: columns,
                    spacing: Spacings.spacing10) {
                        ForEach(viewModel.jobCategories, id: \.self) { mood in
                            Button {
                                viewModel.selectedCategory = mood
                            } label: {
                                Text(mood.rawValue)
                                
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .padding(Spacings.spacing10)
                            .frame(height: 100)
                            .foregroundStyle(Color.black)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: Spacings.spacing25)
                                .fill(
                                    mood == viewModel.selectedCategory ? Color.buttonsPurpleColor : Color.red)
                            )
                            //                                .applyStroke(color: .mainBlue)
                            //                                .animation(.easeInOut(duration: 0.5), value: viewModel.selectedMood)
                        }
                    }.padding(Spacings.spacing5)
            }
            
            Button(action: {
                viewModel.didTapOnDone()
            }, label: {
                Text(Localizables.Shared.done)
            })
            .buttonStyle(StandartButtonStyle())
        }.padding(20)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
