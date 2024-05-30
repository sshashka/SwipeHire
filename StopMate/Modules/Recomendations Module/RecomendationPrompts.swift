//
//  RecomendationPrompts.swift
//  QuitMate
//
//  Created by Саша Василенко on 20.06.2023.
//

import Foundation


class RecomendationPrompts {
    
    static func getRecomendationForMoodAdded(userData: User, currentUser: User) -> String {
        let userName = userData.name
        let userExp = userData.expirience
        let userHour = userData.hourRate
        
        let currentUserName = currentUser.name
        let currentUserDemands = currentUser.demands
        return String("Прівіт, мене звуть \(currentUserName) і я шукаю виконавця мого проєкту за наступними вимогами \(currentUserDemands) на твою думку чи буде хорошим спеціалістом \(userName) який каже що має наступний досвід: \(userExp) та хоче наступну погодинну оплату: \(userHour) долларів")
    }
}
