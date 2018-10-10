//
//  HotelsViewController.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import MapKit

class HotelsViewController: UIViewController {
    
    // full list of hotels
    var hotels = [Hotel]() {
        didSet {
            filteredHotels = hotels.filter(for: navigationItem.searchController?.searchBar.text)
        }
    }
    
    // filtered list of hotels. this will be used to populate map and tableview
    var filteredHotels = [Hotel]() {
        didSet {
            reload()
        }
    }
    
    // embedded hotelsTableViewController
    var hotelsTableViewController: HotelsTableViewController?
    
    // current map state
    var mapState = MapState.close {
        didSet {
            toggleMapView(to: mapState)
        }
    }
    
    // flag to determine if we are loading for the first time
    private var isInitialLoad = true {
        didSet {
            hotelsTableViewController?.isInitialLoad = isInitialLoad
        }
    }
    
    // decides whether to show no data view
    private var shouldShowNoDataView: Bool {
        return !isInitialLoad && filteredHotels.count <= 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return mapState == .open && navigationItem.searchController?.isActive == false
    }
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var buttonCloseMap: UIButton?
    @IBOutlet weak var viewNoData: UIView?
    @IBOutlet weak var constraintContainerTop: NSLayoutConstraint?
    @IBOutlet weak var constraintBackgroundTop: NSLayoutConstraint?
    @IBOutlet weak var constraintBackgroundBottom: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // map is closed initially
        mapState = .close
        
        configureSearchController()
        loadHotels()
        
        // refresh data when app is foregrounded
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadHotels(completionHandler: VoidClosure? = nil) {
        Hotel.list { [weak self] (hotels, error) in
            DispatchQueue.main.async {
                
                // handle errors
                guard error == nil else {
                    UIAlertController.ok(message: error!.localizedDescription)
                    return
                }
                
                self?.isInitialLoad = false
                
                // save hotels
                self?.hotels = hotels
                
                // fire completion handler
                completionHandler?()
            }
        }
    }
    
    @objc func applicationWillEnterForeground() {
        loadHotels()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.isActive = false
        navigationItem.searchController = searchController
    }
    
    private func reload() {
        
        // show no data view if needed
        viewNoData?.isHidden = !shouldShowNoDataView
        
        // reload map
        reloadMapView()

        // reload tableview
        hotelsTableViewController?.hotels = filteredHotels
    }
    
    private func reloadMapView() {
        
        // abort if we cant get the mapview reference
        guard let mapView = mapView else { return }
        
        // remove current annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // create annotations with filtered hotels
        let annotations = filteredHotels.map { HotelAnnotation.annotation(for: $0) }

        // abort if we dont have any annotations
        guard let first = annotations.first else { return }
        
        // add annotation and select the first one
        mapView.addAnnotations(annotations)
        mapView.selectAnnotation(first, animated: false)
        
        // set region to see the first annotation
        let coordinateRegion = MKCoordinateRegion.init(center: first.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func toggleMapView(to state: MapState) {
        if state == .open {
            buttonCloseMap?.isHidden = false
            navigationController?.setNavigationBarHidden(true, animated: true)
            constraintContainerTop?.priority = .defaultLow
            constraintBackgroundBottom?.priority = .defaultHigh
        }
        else {
            buttonCloseMap?.isHidden = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            constraintContainerTop?.priority = .defaultHigh
            constraintBackgroundBottom?.priority = .defaultLow
        }
        
        // animate constraints
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
            self?.view.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // save instance of HotelsTableViewController from embedded segue
        if segue.identifier == HotelsTableViewController.identifier, let hotelsTableViewController = segue.destination as? HotelsTableViewController {
            hotelsTableViewController.hotels = filteredHotels
            hotelsTableViewController.hotelsViewController = self
            self.hotelsTableViewController = hotelsTableViewController
        }
        else if segue.identifier == HotelViewController.identifier, let hotelViewController = segue.destination as? HotelViewController {
            hotelViewController.hotel = sender as? Hotel
        }
    }
    
    @IBAction func buttonActionCloseMap(_ sender: UIButton) {
        mapState = .close
    }
}

extension HotelsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredHotels = hotels.filter(for: searchController.searchBar.text)
    }
}

extension HotelsViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        hotelsTableViewController?.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        mapState = .close
        filteredHotels = hotels
        hotelsTableViewController?.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension HotelsViewController {
    enum MapState {
        case open
        case close
    }
}

