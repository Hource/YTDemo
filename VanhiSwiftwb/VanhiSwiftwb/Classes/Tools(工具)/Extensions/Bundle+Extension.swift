//
//  Bundle+Extension.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/14.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

extension Bundle {
    
    // 1.
    var nameSpace:String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    // 2.
//    var nameSpace:String {
//        get {
//            return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        }
//    }
    
}

