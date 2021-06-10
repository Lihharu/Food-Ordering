//
//  HomeViewModel.swift
//  Food Ordering
//
//  Created by Edi Sunardi on 01/03/21.
//

import SwiftUI
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
    //:Mark Property
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    
    @Published var showMenu = false
    
    // item data
    @Published var items: [Item] = []
    @Published var filtered: [Item] = []
    
    @Published var cartItem: [Cart] = []
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("Unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
            
        }
    }//:Fungsi untuk meminta lokasi
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error ){
        print(error.localizedDescription)
    }//: Fungsi untuk Error Lokasi
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
        self.extractLocation()
        self.login()//di tambah
    }//: Fungsi untuk Update Lokasi
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            guard let safeData = res else {return}
            
            var address = ""
            
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }//: fungsi untuk menyimpan data lokasi
    
    // anonymous login untuk membaca database
    func login(){
        Auth.auth().signInAnonymously{ (res, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            self.fetchData()
        }
    }
    
    // fungsi untuk mendapatkan data dari firebase
    // fetching item data
    func fetchData(){
      
      let db = Firestore.firestore()
      
      db.collection("Items").getDocuments { (snap, err) in
        
        guard let itemData = snap else { return }
        
        self.items = itemData.documents.compactMap({ (doc) -> Item? in
          
          let id = doc.documentID
          let name = doc.get("item_name") as! String
          let cost = doc.get("item_cost") as! NSNumber
          let ratings = doc.get("item_ratings") as! String
          let image = doc.get("item_image") as! String
          let details = doc.get("item_details") as! String
          
          return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
          
          
        })
        
        self.filtered = self.items
      }
        
    }
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return
                $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
    func addToCart(item: name){
        self.items[getIndex (item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        let filterIndex = self.filtered.firstIndex{ (item1) -> Bool in
            return item.id == item1.id
            
        } ?? 0
        
        self.filtered[filteredIndex].isAdded = !item.isAdded
        
        if item.isAdded{
            self.cartItem.remove(at: getIdex())
        }
    }
    
}


