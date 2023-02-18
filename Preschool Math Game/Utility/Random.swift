//
//  Random.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/7/21.
//

import Foundation

class Random {
    static func getRandomIndex(in range: Range<Int>, ignore index: Int? = nil) -> Int! {
        let random = Int.random(in: range)
        if let index = index, random == index {
            return getRandomIndex(in: range, ignore: index)
        } else {
            return random
        }
    }
    
    static func getRandomIndex(in range: Range<Int>, ignoredIndexes: [Int]) -> Int! {
        let random = Int.random(in: range)
        if ignoredIndexes.contains(random) {
            return getRandomIndex(in: range, ignoredIndexes: ignoredIndexes)
        } else {
            return random
        }
    }
    
    static func getRandomNumber(in number: Int, ignoredIndexes: [Int]) -> Int! {
        let baseNum = [2, 4, 6, 8].shuffled()
        let num = baseNum[0]

        if ignoredIndexes.contains(num) {
            return getRandomNumber(in: number, ignoredIndexes: ignoredIndexes)
        } else {
            return num
        }
    }
    
    static func getTwoRandomNumbers(firstNum: Range<Int>, secondNum: Range<Int>) -> [Int] {
        let random_1 = Int.random(in: firstNum)
        let random_2 = Int.random(in: secondNum)
        
        let array = [random_1, random_2]
        
        // First Random Number
        let count_1 = "\(random_1)".digits
        let first_1 = count_1[0]
        let first_2 = count_1[1]
        
        // Second Random Number
        let count_2 = "\(random_2)".digits
        let second_1 = count_2[0]
        let second_2 = count_2[1]
        
        if first_1 + second_1 >= 10 || first_2 + second_2 >= 10 {
            return getTwoRandomNumbers(firstNum: firstNum, secondNum: secondNum)
        } else {
            return array
        }
    }

    static func generateRandomNumber(startRange: Int, endRange: Int, array: [Int]) -> Int {
        let num = Int.random(in: startRange...endRange)
        if array.contains(num) {
        return generateRandomNumber(startRange: startRange, endRange: endRange, array: array)
        } else { return num }
    }

    static func getRandomArray() -> [Int] {
        var array = [[7, 2, 3, 6, 1, 5], [2, 4, 5, 1 , 0, 10], [10, 2, 8, 4, 1, 7]].randomElement()!
            for i in (1...10).shuffled() {
                if !array.contains(i) {
                    array.append(i)
                    break
                }
            }
        return array.shuffled()
    }
}
