//
//  HotelCell.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

class HotelCell: UITableViewCell {
    
    var hotel: Hotel? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var imageViewHotel: UIImageView?
    @IBOutlet weak var labelName: UILabel?
    @IBOutlet weak var labelAddress: UILabel?
    @IBOutlet weak var labelHighRate: UILabel?
    @IBOutlet weak var labelLowRate: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        configureView()
    }

    private func configureView() {
        guard let hotel = hotel else { return }
        
        labelName?.text = hotel.name
        labelAddress?.text = hotel.address
        labelLowRate?.text = hotel.lowRate.currencyFormatted()
        imageViewHotel?.setImage(with: hotel.images.first ?? "")
        
        labelHighRate?.isHidden = !hotel.hasDiscount
        labelHighRate?.attributedText = hotel.highRate.currencyFormatted().strikeThrough(with: .red)
    }
}
