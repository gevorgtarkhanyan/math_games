//
//  CheckTime.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 11.10.21.
//

import UIKit

class TimesCheking {
    
    static var shared = TimesCheking()
    
    var dateNow = Date()
    
    var game: GameType!
    
    func checking() {
        let oldDate = UserDefaults.standard.value(forKey: "dateNow") as? Date
        
        if !Calendar.current.isDateInToday(oldDate ?? Date()) {

//            //MARK: - Lock

            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_1)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_2)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_3)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_4)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_5)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_6)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_7)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_8)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_9)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_10)
            
            //MARK: - Limit
            //counting
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.counting_1Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.counting_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.findNumberLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.odd_EvenLimit)
            
            //adding
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newAddingLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.adding_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.adding_3Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.adding_5Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.addingFunLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.addingSubMixLimit)
            
            //multiplication
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.multiplicationLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.multiplication_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newMultiplicLimit)
            
            //division
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newDivisionLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.divisionLimit)
            
            //shapes
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.shapes_1Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.shapes_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.shapes_3Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.shapes_4Limit)
            
            //sorting
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sortingNum_1Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sortingNum_2Limit)
            
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_1Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_3Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_4Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_5Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_6Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_7Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_8Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_9Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_10Limit)
            
            //compare
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.compareLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.scaleLimit)

            //substracting
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subtractingLimit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subtracting_2Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subtracting_3Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subtracting_5Limit)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newSubtractingLimit)


            //MARK: - Right/Wrong Aswers

            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.scaleRightAnswers)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.scaleWrongAnswers)
            
            GameCenter.allGames.forEach { $0.isLocked = false }
        }
        UserDefaults.standard.setValue(dateNow, forKey: "dateNow")
    }
}
