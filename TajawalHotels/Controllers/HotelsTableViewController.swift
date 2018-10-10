//
//  HotelsTableViewController.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

class HotelsTableViewController: UITableViewController {
    
    // hotels which will be displayed by the tableview
    var hotels = [Hotel]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // parent hotels view controller which hold the map view
    weak var hotelsViewController: HotelsViewController?
    
    // flag to determine if we are loading for the first time
    // we will show placeholder cell for initial load
    var isInitialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRefreshControl()
    }

    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        hotelsViewController?.loadHotels { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
}

extension HotelsTableViewController {
    
    // we have 2 sections
    // first section will be a clear one to show the underlying mapview
    // second section shows the actual list of hotels
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else { return 1 }
        return isInitialLoad ? 4 : hotels.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != 0 else { return nil }
        return isInitialLoad ? "Getting better prices and availability" : "All prices include taxes and fees"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let clearCell = tableView.dequeueReusableCell(withIdentifier: ClearCell.identifier) as? ClearCell else { return UITableViewCell() }
            
            // open map on clicking expand button
            clearCell.expandButtonHandler = { [weak self] in
                self?.hotelsViewController?.mapState = .open
            }
            
            return clearCell
        }
        
        guard !isInitialLoad else {
            return tableView.dequeueReusableCell(withIdentifier: HotelPlaceholderCell.identifier) ?? UITableViewCell()
        }
        
        guard let hotelCell = tableView.dequeueReusableCell(withIdentifier: HotelCell.identifier) as? HotelCell else { return UITableViewCell() }
        hotelCell.hotel = hotels[indexPath.row]
        return hotelCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // abort if user clicked a cell other than hotel cell
        guard let cell = tableView.cellForRow(at: indexPath) as? HotelCell else { return }
        
        // show detail screen
        hotelsViewController?.performSegue(withIdentifier: HotelViewController.identifier, sender: cell.hotel)
    }
}

extension HotelsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This doesn't seem to go well with refresh control 🙃
//        if scrollView.contentOffset.y < -230 && hotelsViewController?.mapState != .open {
//            hotelsViewController?.mapState = .open
//        }
        
        // a clear map under table isn't desirable
        if scrollView.contentOffset.y < 100 {
            hotelsViewController?.constraintBackgroundTop?.constant = 220 + (scrollView.contentOffset.y * -1)
        }
    }
}
