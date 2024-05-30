//
//  RegistrationUserView.swift
//  QuitMate
//
//  Created by Саша Василенко on 12.06.2023.
//

import SwiftUI

struct FirstTimeEntryView<ViewModel>: View where ViewModel: FirstTimeEntryViewModelProtocol {
    enum Field: Hashable {
        case name, age, expirience, hourRate, category, demands
    }
    @StateObject var viewModel: ViewModel
    @State private var isShowingCurrencyPicker: Bool = false
    @State private var selectedField: Field = .name
    @State private var demandsText = ""
    @FocusState private var focusedField: Field?
    var body: some View {
        VStack {
            TabView(selection: $selectedField) {
                TextFieldWithUnderlineViewAndHeader(headerText: Localizables.FirstTimeEntryStrings.namePromt, text: $viewModel.name, placeHolderText: Localizables.FirstTimeEntryStrings.name)
                    .focused($focusedField, equals: .name)
                    .tag(Field.name)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            focusedField = selectedField
                        }
                    }
                
                TextFieldWithUnderlineViewAndHeader(headerText: Localizables.FirstTimeEntryStrings
                    .agePromt, text: $viewModel.age ,placeHolderText: Localizables.FirstTimeEntryStrings.age)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .age)
                    .tag(Field.age)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            focusedField = selectedField
                        }
                    }
                
                VStack {
                    FirstTimeEntryHeaderView(text: "Оберіть власний домен")
                    JobCategoriesView(selectedMood: $viewModel.selectedCategory)
//                        .focused($focusedField, equals: .category)
                }
                .tag(Field.category)
                .padding(20)
                
                TextFieldWithUnderlineViewAndHeader(headerText: "Розкажіть про свій досвід", text: $viewModel.expirience, placeHolderText: "Ваш досвiд")
                    .focused($focusedField, equals: .expirience)
                    .tag(Field.expirience)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            focusedField = selectedField
                        }
                    }
                
                
                
                TextFieldWithUnderlineViewAndHeader(headerText: "Опишіть ваші вимоги до кандидата", text: $viewModel.demands, placeHolderText: "Вимоги")
                    .focused($focusedField, equals: .demands)
                    .tag(Field.demands)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            focusedField = selectedField
                        }
                    }
                
                TextFieldWithUnderlineViewAndHeader(headerText: "Яка ваша бажана зп за годину", text: $viewModel.hourRate, placeHolderText: "Зарплатня")
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .hourRate)
                    .tag(Field.hourRate)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            focusedField = selectedField
                        }
                    }
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.4), value: selectedField)
            Button {
                switch selectedField {
                case .name:
                    selectedField = .age
                case .age:
                    selectedField = .category
                case .category:
                    if viewModel.selectedCategory == .other {
                        selectedField = .demands
                        demandsText = "Опишіть ваші вимоги до кандидата"
                    } else {
                        selectedField = .expirience
                        demandsText = "Опишіть ваші вимоги до рекрутера"
                    }
                case .expirience:
                    selectedField = .demands
                case .hourRate:
                    selectedField = .hourRate
                case .demands:
                    viewModel.didTapOnFinish()
                }
            } label: {
                Text(selectedField == .demands ? Localizables.Shared.finish : Localizables.Shared.next)
            }
            .buttonStyle(StandartButtonStyle())
            .padding(Spacings.spacing30)
        }
    }
}

struct RegistrationUserView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeEntryView(viewModel: FirstTimeEntryViewModel(storageService: FirebaseStorageService()))
    }
}
