//
//  ClearCell.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

class ClearCell: UITableViewCell {
    
    var expandButtonHandler: VoidClosure?
    
    @IBAction func buttonActionExpand(_ sender: UIButton) {
        expandButtonHandler?()
    }
}
