//
//  CurrencyCalculatorTests.swift
//  CurrencyCalculatorTests
//
//  Created by Cem Sezeroglu on 11.06.2021.
//

import XCTest

@testable import CurrencyCalculator

class CurrencyCalculatorTests: XCTestCase {

    var sut:DCAService! //SUT means system under test. we test dcaservices. because our logic inside this file.
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DCAService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    //Test Function name format ;
    
    //What
    //Given
    //Expectations
    
    //In function write code from this path
    //given
    //when
    //then
    

    func testDCAResult_givenDCAIsUsed_expectedResult(){
        
    }
    
    func testDCAResult_givenDCAIsNotUsed_expectedResult(){
        
    }
    
    func testInvestmentAmount_whenDCAIsUsed_expectedResult(){
        //Given
        let initialInvestmentAmount:Double = 500
        let MonthlyDolarCoastAverageAmount:Double = 100
        let initialDayOfInvestmentIndex = 4 //5months ago
        
        //When
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, MonthlyDolarCoastAverageAmount: MonthlyDolarCoastAverageAmount, initialDayOfInvestmentIndex: initialDayOfInvestmentIndex)
        
        //Then
        XCTAssertEqual(investmentAmount, 900)
        
        //Initial Amount = $500
        //DCA 4 x $100 = $400
        //Total : $500 + $400 = $900
        
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectedResult(){
        //Given
        let initialInvestmentAmount:Double = 500
        let MonthlyDolarCoastAverageAmount:Double = 0
        let initialDayOfInvestmentIndex = 4 //5months ago
        
        //When
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, MonthlyDolarCoastAverageAmount: MonthlyDolarCoastAverageAmount, initialDayOfInvestmentIndex: initialDayOfInvestmentIndex)
        
        //Then
        XCTAssertEqual(investmentAmount, 500)
        
        //Initial Amount = $500
        //DCA 4 x $0 = 0
        //Total : 0+ $500 = $500
        
    }
}
