//
//  FcrAppUIColorGroup.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/7.
//  Copyright © 2023 Agora. All rights reserved.
//

import UIKit

struct FcrAppUIColorGroup {
    //
    static var fcr_black: UIColor {
        return .black
    }
    
    static var fcr_white: UIColor {
        return .white
    }
    
    //
    static var fcr_v2_brand6: UIColor {
        return UIColor.fcr_hex_string("#4262FF")
    }
    
    static var fcr_v2_brand5: UIColor {
        return UIColor.fcr_hex_string("#4262FF",
                                      transparency: 0.8)
    }
    
    static var fcr_v2_red6: UIColor {
        return UIColor.fcr_hex_string("#F5655C")
    }
    
    static var fcr_v2_main_purple6: UIColor {
        return UIColor.fcr_hex_string("#5765FF")
    }
    
    // Text color
    static var fcr_v2_light_text1: UIColor {
        return .black
    }
    
    static var fcr_v2_light_text2: UIColor {
        return UIColor.fcr_hex_string("#757575")
    }
    
    static var fcr_v2_light_text3: UIColor {
        return UIColor.fcr_hex_string("#BBBBBB")
    }
    
    static var fcr_v2_light_input_background: UIColor {
        return UIColor.fcr_hex_string("#F9F9FC")
    }
    
    // TODO: UI
    static var fcr_v2_light1: UIColor {
        return UIColor.fcr_hex_string("#F2F2FA")
    }
    
    // TODO: UI
    static var fcr_v2_green: UIColor {
        return UIColor.fcr_hex_string("#16D1A4")
    }
    
    static var fcr_v2_line: UIColor {
        return UIColor.fcr_hex_string("#EFEFEF")
    }
}
