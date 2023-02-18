//
//  Structs.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/2/21.
//

import UIKit

struct UserDefaultsKeys {
    
    static let subscriptionData = "subscriptionData"
    static let sandBoxSubscriptionData = "sandBoxSubscriptionData"
    static let subscriptionType = "subscriptionType"
    static let subscriptionExpire = "subscriptionExpire"
    
    static let counting_1Limit = "counting_1Limit"
    static let counting_1Date = "counting_1Date"
    
    static let counting_2Limit = "counting_2Limit"
    static let counting_2Date = "counting_2Date"
    
    static let compareLimit = "compareLimit"
    static let compareDate = "compareDate"

    static let scaleLimit = "scaleLimit"
    static let scaleDate = "scaleDate"
    
    static let addingFunLimit = "addingFunLimit"
    static let addingFunDate = "addingFunDate"
    
    static let subtractingLimit = "subtractingLimit"
    static let subtractingDate = "subtractingDate"
    
    static let shapes_1Limit = "shapes_1Limit"
    static let shapes_1Date = "shapes_1Date"
    
    static let shapes_2Limit = "shapes_2Limit"
    static let shapes_2Date = "shapes_2Date"
    
    static let adding_2Limit = "adding_2Limit"
    static let adding_2Date = "adding_2Date"
    
    static let subtracting_2Limit = "subtracting_2Limit"
    static let subtracting_2Date = "subtracting_2Date"
    
    static let adding_3Limit = "adding_3Limit"
    static let adding_3Date = "adding_3Date"
    
    static let subtracting_3Limit = "subtracting_3Limit"
    static let subtracting_3Date = "subtracting_3Date"
    
    static let addingSubMixLimit = "addingSubMixLimit"
    static let addingSubMixDate = "addingSubMixDate"
    
    static let multiplicationLimit = "multiplicationLimit"
    static let multiplicationDate = "multiplicationDate"
    
    static let multiplication_2Limit = "multiplication_2Limit"
    static let multiplication_2Date = "multiplication_2Date"
    
    static let divisionLimit = "divisionLimit"
    static let divisionDate = "divisionDate"
    
    static let odd_EvenLimit = "odd_EvenLimit"
    static let odd_EvenDate = "odd_EvenDate"
    
    static let shapes_3Limit = "shapes_3Limit"
    static let shapes_3Date = "shapes_3Date"
    
    static let shapes_4Limit = "shapes_4Limit"
    static let shapes_4Date = "shapes_4Date"
    
    static let findNumberLimit = "findNumberLimit"
    static let findNumberDate = "findNumberDate"
    
    static let sortingNum_1Limit = "sortingNum_1Limit"
    static let sortingNum_1Date = "sortingNum_1Date"
    
    static let sortingNum_2Limit = "sortingNum_2Limit"
    static let sortingNum_2Date = "sortingNum_2Date"
    
    static let newAddingLimit = "newAddingLimit"
    static let newAddingDate = "newAddingDate"
    
    static let newMultiplicLimit = "newMultiplicLimit"
    static let newMultiplicDate = "newMultiplicDate"
    
    static let newDivisionLimit = "newDivisionLimit"
    static let newDivisionDate = "newDivisionDate"
    
    static let newSubtractingLimit = "newSubtractingLimit"
    static let newSubtractingDate = "newSubtractingDate"
    
    static let adding_5Limit = "adding_5Limit"
    static let adding_5Date = "adding_5Date"
    
    static let subtracting_5Limit = "subtracting_5Limit"
    static let subtracting_5Date = "subtracting_5Date"
    
    static let learning_1Limit = "learning_1Limit"
    static let learning_2Limit = "learning_2Limit"
    static let learning_3Limit = "learning_3Limit"
    static let learning_4Limit = "learning_4Limit"
    static let learning_5Limit = "learning_5Limit"
    static let learning_6Limit = "learning_6Limit"
    static let learning_7Limit = "learning_7Limit"
    static let learning_8Limit = "learning_8Limit"
    static let learning_9Limit = "learning_9Limit"
    static let learning_10Limit = "learning_10Limit"

    static let learningDate = "learningDate"

    static let learning_1Date = "learning_1Date"
    static let learning_2Date = "learning_2Date"
    static let learning_3Date = "learning_3Date"
    static let learning_4Date = "learning_4Date"
    static let learning_5Date = "learning_5Date"
    static let learning_6Date = "learning_6Date"
    static let learning_7Date = "learning_7Date"
    static let learning_8Date = "learning_8Date"
    static let learning_9Date = "learning_9Date"
    static let learning_10Date = "learning_10Date"

    static let scaleRightAnswers = "scaleRightAnswers"
    static let scaleWrongAnswers = "scaleWrongAnswers"
    
    static let paymentKey = "paymentKey"
    
    static let unlockOrLock = "unlockOrLock"
    
    static let backgroundSoundIsOn = "soundIsOn"
    
    static let ischangeBackgroundSoundStatus = "ischangeSoundStatus"
    
    static let isClickedBackgroundSoundBtn = "isClickedBackgroundSoundBtn"
    
    static let efectsSoundIsOn = "efectsSoundIsOn"
    
    static let ischangeEfectsSoundStatus = "ischangeEfectsSoundStatus"
    
    static let isClickedEfectsSoundBtn = "isClickedEfectsSoundBtn"
    
    static let isLockLearning = "isLockLearning"

    static let isLockLearning_1 = "isLockLearning_1"
    static let isLockLearning_2 = "isLockLearning_2"
    static let isLockLearning_3 = "isLockLearning_3"
    static let isLockLearning_4 = "isLockLearning_4"
    static let isLockLearning_5 = "isLockLearning_5"
    static let isLockLearning_6 = "isLockLearning_6"
    static let isLockLearning_7 = "isLockLearning_7"
    static let isLockLearning_8 = "isLockLearning_8"
    static let isLockLearning_9 = "isLockLearning_9"
    static let isLockLearning_10 = "isLockLearning_10"

    static let isShowHunt = "isShowHunt"
    
    static let isChangedShowHunt = "isChangedShowHunt"
    
    static let languageKey = "languageKey"
    
    static let languageIndexPath = "languageIndexPath"
    
    static let isOpenSecondTime = "isOpenFirstTime"

    //    static let counting_1PrizCount = "counting_1PrizCount"
    //
    //    static let counting_2PrizCount = "counting_2PrizCount"
    //
    //    static let comparePrizCount = "comparePrizCount"
    //
    //    static let addingPrizCount = "addingPrizCount"
    //
    //    static let subtractingPrizCount = "subtractingPrizCount"

    //    static let shapes_1PrizCount = "shapes_1PrizCount"
    //
    //    static let shapes_2PrizCount = "shapes_2PrizCount"
    //
    //    static let adding_2PrizCount = "adding_2PrizCount"
    //
    //    static let subtracting_2PrizCount = "subtracting_2PrizCount"

    //    static let adding_3PrizCount = "adding_3PrizCount"
    //
    //    static let subtracting_3PrizCount = "subtracting_3PrizCount"
    //
    //    static let addingSubMixPrizCount = "addingSubMixPrizCount"

    //    static let multiplicationPrizCount = "multiplicationPrizCount"
    //
    //    static let multiplication_2PrizCount = "multiplication_2PrizCount"
    //
    //    static let divisionPrizCount = "divisionPrizCount"
    //
    //    static let odd_EvenPrizCount = "odd_EvenPrizCount"
    //
    //    static let shapes_3PrizCount = "shapes_3PrizCount"
    //
    //    static let shapes_4PrizCount = "shapes_4PrizCount"
    //
    //    static let findNumberPrizCount = "findNumberPrizCount"

    //    static let sortingNum_1PrizCount = "sortingNum_1PrizCount"
    //
    //    static let sortingNum_2PrizCount = "sortingNum_2PrizCount"
    //
    //    static let newAddingPrizCount = "newAddingPrizCount"
    //
    //    static let newMultiplicPrizCount = "newMultiplicPrizCount"
    //
    //    static let newDivisionPrizCount = "newDivisionPrizCount"
    //
    //    static let newSubtractingPrizCount = "newSubtractingPrizCount"
    //
    //    static let learningPrizCount = "learningPrizCount"
    //
    //    static let adding_5PrizCount = "adding_5PrizCount"
    //
    //    static let subtracting_5PrizCount = "subtracting_5PrizCount"
}

struct GamesLimit {

    static var isShowHunt = true

    
    static var counting_1Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.counting_1Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.counting_1Limit)
    }
    }

    static var counting_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.counting_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.counting_2Limit)
    }
    }

    static var compareLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.compareLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.compareLimit)
    }
    }

    static var scaleLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.scaleLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.scaleLimit)
    }
    }

    static var addingFunLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.addingFunLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.addingFunLimit)
    }
    }

    static var subtractingLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.subtractingLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.subtractingLimit)
    }
    }

    static var shapes_1Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_1Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.shapes_1Limit)
    }
    }

    static var shapes_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.shapes_2Limit)
    }
    }

    static var adding_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.adding_2Limit)
    }
    }

    static var subtracting_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.subtracting_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.subtracting_2Limit)
    }
    }

    static var adding_3Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_3Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.adding_3Limit)
    }
    }

    static var subtracting_3Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.subtracting_3Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.subtracting_3Limit)
    }
    }

    static var addingSubMixLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.addingSubMixLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.addingSubMixLimit)
    }
    }

    static var multiplicationLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.multiplicationLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.multiplicationLimit)
    }
    }

    static var multiplication_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.multiplication_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.multiplication_2Limit)
    }
    }

    static var divisionLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.divisionLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.divisionLimit)
    }
    }

    static var odd_EvenLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.odd_EvenLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.odd_EvenLimit)
    }
    }

    static var shapes_3Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_3Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.shapes_3Limit)
    }
    }

    static var shapes_4Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_4Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.shapes_4Limit)
    }
    }

    static var findNumberLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.findNumberLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.findNumberLimit)
    }
    }

    static var sortingNum_1Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.sortingNum_1Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.sortingNum_1Limit)
    }
    }

    static var sortingNum_2Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.sortingNum_2Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.sortingNum_2Limit)
    }
    }

    static var adding_5Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_5Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.adding_5Limit)
    }
    }

    static var subtracting_5Limit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.subtracting_5Limit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.subtracting_5Limit)
    }
    }

    static var newAddingLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.newAddingLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.newAddingLimit)
    }
    }

    static var newMultiplicLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.newMultiplicLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.newMultiplicLimit)
    }
    }

    static var newDivisionLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.newDivisionLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.newDivisionLimit)
    }
    }

    static var newSubtractingLimit: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.newSubtractingLimit) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.newSubtractingLimit)
    }
    }

    static var learning_1Limit = 0
    static var learning_2Limit = 0
    static var learning_3Limit = 0
    static var learning_4Limit = 0
    static var learning_5Limit = 0
    static var learning_6Limit = 0
    static var learning_7Limit = 0
    static var learning_8Limit = 0
    static var learning_9Limit = 0
    static var learning_10Limit = 0
    static var learningLimitEnded = false

//    static var counting_1PrizCount = 0
//    static var counting_2PrizCount = 0
//    static var comparePrizCount = 0
//    static var addingPrizCount = 0
//    static var subtractingFunPrizCount = 0
//    static var shapes_1PrizCount = 0
//    static var shapes_2PrizCount = 0
//    static var adding_2PrizCount = 0
//    static var subtractingFun_2PrizCount = 0
//    static var adding_3PrizCount = 0
//    static var subtractingFun_3PrizCount = 0
//    static var addingSubMixPrizCount = 0
//    static var multiplicationPrizCount = 0
//    static var multiplication_2PrizCount = 0
//    static var divisionPrizCount = 0
//    static var odd_EvenPrizCount = 0
//    static var shapes_3PrizCount = 0
//    static var shapes_4PrizCount = 0
//    static var findNumberPrizCount = 0
//    static var sortingNum_1PrizCount = 0
//    static var sortingNum_2PrizCount = 0
//    static var newAddingPrizCount = 0
//    static var newMultiplicPrizCount = 0
//    static var newDivisionPrizCount = 0
//    static var newSubtractingPrizCount = 0
//    static var learningPrizCount = 0
//    static var adding_5PrizCount = 0
//    static var subtracting_5PrizCount = 0
}

struct RightWrongAnswers {
    static var scaleRight: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.scaleRightAnswers) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.scaleRightAnswers)
    }
    }

    static var scaleWrong: Int { get {
        UserDefaults.standard.value(forKey: UserDefaultsKeys.scaleWrongAnswers) as? Int ?? 0
    } set {
        return UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.scaleWrongAnswers)
    }
    }
}
