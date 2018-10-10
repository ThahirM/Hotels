//
//  HotelAnnotation.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import MapKit

class HotelAnnotation: MKPointAnnotation {
    var hotel: Hotel? {
        didSet {
            configureView()
        }
    }
    
    static func annotation(for hotel: Hotel) -> HotelAnnotation {
        let annotation = HotelAnnotation()
        annotation.hotel = hotel
        return annotation
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    func configureView() {
        guard let hotel = hotel, let location = hotel.location else { return }
        
        title = hotel.name
        subtitle = hotel.lowRate.currencyFormatted()
        coordinate = location.coordinate
    }
}
