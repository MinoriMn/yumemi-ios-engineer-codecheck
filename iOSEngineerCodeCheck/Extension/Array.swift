//
//  Utils.swift
//  iOSEngineerCodeCheck
//
//  Created by 松田尚也 on 2022/01/12.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Index?) -> Element? {
        guard let index = index,
              indices.contains(index) else { return nil }
        return self[index]
    }
}
