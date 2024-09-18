//
//  UIView.swift
//  LikeInstaApp
//
//  Created by Алла alla2104 on 12.09.24.
//

import UIKit

extension UIView {
    static func configure<T: UIView>(view: T, completion: @escaping (T) -> ()) -> T {
        view.translatesAutoresizingMaskIntoConstraints = false
        completion(view)
        return view
    }
}
