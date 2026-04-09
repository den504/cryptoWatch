//
//  WatchList.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 08/04/2026.
//

import SwiftData
import Foundation

@Model

class WatchList {
    var coinId : String
    
    init(coinId: String){
        self.coinId = coinId
    }
    
   
}
