//
//  DebugTool.swift
//  ClashX
//
//  Created by CYC on 2018/12/29.
//  Copyright © 2018 west2online. All rights reserved.
//

import Foundation

func d_print(_ items: Any... ,separator: String = " ", terminator: String = "\n") {
    debugOnly {
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("[MTSeineKit]"+output)
    }
}

func debugOnly(_ body: () -> Void) {
    assert({ body(); return true }())
}

func isDebug() -> Bool {
    var isDebug = false
    assert({ isDebug = true; return true }())
    return isDebug
}
