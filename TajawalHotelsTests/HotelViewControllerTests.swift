//
//  HotelViewControllerTests.swift
//  TajawalHotelsTests
//
//  Created by Thahir Maheen on 10/7/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import XCTest
@testable import TajawalHotels

class HotelViewControllerTests: XCTestCase {
    
    let id = 4020979
    let hotelName = "Coral Oriental Dubai"
    let address = "Burj Nahar Roundabout, Naif Road"
    let image = "https://az712897.vo.msecnd.net/images/full/A1EE945E-166C-4AC0-BB73-00B1D8F5DEF0.jpeg"
    let latitude = 25.275914
    let longitude = 55.313262
    let highRate = 6386.04
    let lowRate = 4958.58
    
    var controllerUnderTest: HotelViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controllerUnderTest = storyboard.instantiateViewController(withIdentifier: HotelViewController.identifier) as? HotelViewController
        
        let images = [["url": image]]
        let location: [String: Any] = ["address": address, "latitude": latitude, "longitude": longitude]
        let summary: [String: Any] = ["highRate": highRate, "hotelName": hotelName, "lowRate": lowRate]
        
        let json: [String: Any] = ["hotelId": id, "image": images, "location": location, "summary": summary]
        
        controllerUnderTest.hotel = Hotel(with: json)
        controllerUnderTest.loadViewIfNeeded()
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testTitle() {
        XCTAssertEqual(controllerUnderTest.title, hotelName, "Failed to set title")
    }
    
    func testPopulateLabels() {
        XCTAssertEqual(controllerUnderTest.labelName?.text, hotelName, "Failed to set name")
        XCTAssertEqual(controllerUnderTest.labelAddress?.text, address, "Failed to set address")
        XCTAssertEqual(controllerUnderTest.labelLowRate?.text, lowRate.currencyFormatted(), "Failed to set low rate")
        XCTAssertEqual(controllerUnderTest.labelHighRate?.attributedText, highRate.currencyFormatted().strikeThrough(with: .red), "Failed to set high rate")
        XCTAssertFalse(controllerUnderTest.labelHighRate!.isHidden, "Is hiding high rate when low < high")
        
        controllerUnderTest.hotel?.lowRate = controllerUnderTest.hotel!.highRate
        controllerUnderTest.hotel = controllerUnderTest.hotel
        XCTAssertEqual(controllerUnderTest.labelHighRate?.text, "", "Failed to clear high rate when low == high")
        XCTAssertTrue(controllerUnderTest.labelHighRate!.isHidden, "Failed to hide high rate when low == high")
        
        controllerUnderTest.hotel?.lowRate = controllerUnderTest.hotel!.highRate + 10.0
        controllerUnderTest.hotel = controllerUnderTest.hotel
        XCTAssertEqual(controllerUnderTest.labelHighRate?.text, "", "Failed to clear high rate when low > high")
        XCTAssertTrue(controllerUnderTest.labelHighRate!.isHidden, "Failed to hide high rate when low > high")
    }
}
