//
//  HotelViewController.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

class HotelViewController: UITableViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureView() {
        guard let hotel = hotel else { return }
        
        title = hotel.name
        imageViewHotel?.setImage(with: hotel.images.first ?? "")
        labelName?.text = hotel.name
        labelAddress?.text = hotel.address
        labelLowRate?.text = hotel.lowRate.currencyFormatted()
        labelHighRate?.isHidden = !hotel.hasDiscount

        if hotel.hasDiscount {
            labelHighRate?.attributedText = hotel.highRate.currencyFormatted().strikeThrough(with: .red)
        } else {
            labelHighRate?.text = ""
        }
    }
}
