//
//  Double+Extension.swift
//  RunHub
//
//  Created by Licardo on 2021/3/23.
//

import Foundation

extension Double {
    func toKMString() -> String {
        String(format: "%.1f", self)
    }
}
