//
//  Extensions.swift
//  FilterTableView
//
//  Created by MyGlamm on 8/16/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

extension String{
    
    var hexColor : UIColor{
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int = UInt32()
        
        Scanner(string: hex).scanHexInt32(&int)
        
        let a,r,g,b : UInt32
        
        switch hex.count{
        case 3: //RGB (12 Bit)
            (a,r,g,b) = (255, (int >> 8) * 17,(int >> 4 & 0xF) * 17 , (int & 0xF) * 17)
        case 6: //RGB (24 Bit)
            (a,r,g,b) = (255, (int >> 16),(int >> 8 & 0xFF) , (int & 0xFF) )
        case 8 : //RGB (32-bit)
            (a,r,g,b) = (int >> 24,(int >> 16 & 0xFF) ,(int >> 8 & 0xFF),(int & 0xFF))
        default:
            return .clear
        }
        
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
        
        
        
    }
}


