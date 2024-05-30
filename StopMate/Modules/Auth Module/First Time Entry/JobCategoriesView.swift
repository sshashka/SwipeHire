//
//  JobCategoriesView.swift
//  StopMate
//
//  Created by Саша Василенко on 05.05.2024.
//

import SwiftUI

enum JobCategories: String, CaseIterable, Codable {
    case iOS = "iOS"
    case Java = "Java"
    case dotNet = ".net"
    case php = "PHP"
    case js = "Java script"
    case python = "Python"
    case android = "Android"
    case Ruby = "Ruby"
    case QA = "QA"
    case flutter = "Flutter"
    case other = "HR"
}

struct JobCategoriesView: View {
    var moods: [JobCategories] = JobCategories.allCases
    @Binding var selectedMood: JobCategories?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(moods, id: \.self) { mood in
                    Button {
                        selectedMood = mood
                    } label: {
                        HStack {
                            Text(mood.rawValue)
                            if selectedMood == mood {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(StandartButtonStyle())
                }
            }.animation(.easeIn(duration: 2), value: moods)
        }
    }
}

#Preview {
    JobCategoriesView(moods: JobCategories.allCases, selectedMood: .constant(.iOS))
}
