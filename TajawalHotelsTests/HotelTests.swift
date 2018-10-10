//
//  HotelTests.swift
//  TajawalHotelsTests
//
//  Created by Thahir Maheen on 10/7/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TajawalHotels

class HotelTests: XCTestCase {
    
    let id = 4020979
    let hotelName = "Coral Oriental Dubai"
    let address = "Burj Nahar Roundabout, Naif Road"
    let image = "https://az712897.vo.msecnd.net/images/full/A1EE945E-166C-4AC0-BB73-00B1D8F5DEF0.jpeg"
    let latitude = 25.275914
    let longitude = 55.313262
    let highRate = 6386.04
    let lowRate = 4958.58

    var hotelUnderTest: Hotel!
    
    override func setUp() {
        super.setUp()
        
        let images = [["url": image]]
        let location: [String: Any] = ["address": address, "latitude": latitude, "longitude": longitude]
        let summary: [String: Any] = ["highRate": highRate, "hotelName": hotelName, "lowRate": lowRate]
        
        let json: [String: Any] = ["hotelId": id, "image": images, "location": location, "summary": summary]
        
        hotelUnderTest = Hotel(with: json)
    }
    
    override func tearDown() {
        hotelUnderTest = nil
        super.tearDown()
    }
    
    func testHotelInitializesFromJson() {
        XCTAssertEqual(hotelUnderTest.id, id, "Failed to initialize id")
        XCTAssertEqual(hotelUnderTest.name, hotelName, "Failed to initialize name")
        XCTAssertEqual(hotelUnderTest.address, address, "Failed to initialize address")
        XCTAssertEqual(hotelUnderTest.images, [image], "Failed to initialize images")
        XCTAssertEqual(hotelUnderTest.location?.coordinate.latitude, latitude, "Failed to initialize location.latitude")
        XCTAssertEqual(hotelUnderTest.location?.coordinate.longitude, longitude, "Failed to initialize location.longitude")
        XCTAssertEqual(hotelUnderTest.highRate, highRate, "Failed to initialize highRate")
        XCTAssertEqual(hotelUnderTest.lowRate, lowRate, "Failed to initialize lowRate")
    }
    
    func testHotelHasDiscount() {
        XCTAssertTrue(hotelUnderTest.hasDiscount, "Failed to determine discount when high > low")
        
        hotelUnderTest.lowRate = hotelUnderTest.highRate
        XCTAssertFalse(hotelUnderTest.hasDiscount, "Failed to determine discount when high == low")

        hotelUnderTest.lowRate = hotelUnderTest.highRate + 10.0
        XCTAssertFalse(hotelUnderTest.hasDiscount, "Failed to determine discount when high < low")
    }
    
    func testHotelPassesSearch() {
        XCTAssertTrue(hotelUnderTest.passesSearch(searchKey: "Coral"), "Failed to pass search with valid key")
        XCTAssertFalse(hotelUnderTest.passesSearch(searchKey: "asdasd"), "Passed search for invalid key")
        XCTAssertTrue(hotelUnderTest.passesSearch(searchKey: "Coral", ignoreEmptyKey: false), "Failed to pass search with valid key when not ignoring empty key")
        XCTAssertFalse(hotelUnderTest.passesSearch(searchKey: "asdasd", ignoreEmptyKey: false), "Passed search for invalid key when not ignoring empty key")
        XCTAssertTrue(hotelUnderTest.passesSearch(searchKey: ""), "Failed to pass search with empty key")
        XCTAssertTrue(hotelUnderTest.passesSearch(searchKey: nil), "Failed to pass search with nil key")
        XCTAssertFalse(hotelUnderTest.passesSearch(searchKey: "", ignoreEmptyKey: false), "Passed search for empty key when not ignoring empty key")
        XCTAssertFalse(hotelUnderTest.passesSearch(searchKey: nil, ignoreEmptyKey: false), "Passed search for nil key when not ignoring empty key")
    }
    
    func testHotelListService() {
        let promise = expectation(description: "Hotel list loaded")
        Hotel.list { (hotels, error) in
            XCTAssertNotNil(hotels, "Failed to retrieve hotel list")
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
