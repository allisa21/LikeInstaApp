import UIKit

func restoreNumbs(input: String) -> [Int] {
    var resultSet = Set<Int>()
    let parts = input.split(separator: ",")
    
    for part in parts {
        if part.contains("-") {
            let bounds = part.split(separator: "-").compactMap { Int($0) }
            if bounds.count == 2 {
                let range = bounds[0]...bounds[1]
                resultSet.formUnion(range)
            }
        } else if let number = Int(part) {
            resultSet.insert(number)
        }
    }
    return resultSet.sorted()
}

// Пример использования
let inputString = "1-6,8-9,11"
let result = restoreNumbs(input: inputString)
print(result.map { String($0) }.joined(separator: " "))

let a = inputString.split(separator: ",")
print(a)
