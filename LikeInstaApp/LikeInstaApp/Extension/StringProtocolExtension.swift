//
//  StringProtocolExtension.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 17.09.24.
//

import UIKit

extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue)}
}
