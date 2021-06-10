//
//  Item.swift
//  Food Ordering
//
//  Created by Edi Sunardi on 11/03/21.
//

import SwiftUI

struct Item: Identifiable {
  
  var id: String
  var item_name: String
  var item_cost: NSNumber
  var item_details: String
  var item_image: String
  var item_ratings: String //:NSNumber
  
  var isAdded: Bool = false
}
