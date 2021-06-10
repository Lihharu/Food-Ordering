//
//  Cart.swift
//  Food Ordering
//
//  Created by Edi Sunardi on 11/03/21.
//

import SwiftUI

struct Cart: Identifiable {
  
  var id = UUID().uuidString
  var item: Item
  var quantity: Int
}
