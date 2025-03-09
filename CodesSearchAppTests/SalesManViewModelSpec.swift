//
//  SalesManViewModelSpec.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation

import Quick
import Nimble
@testable import CodesSearchApp
import SwiftUICore


class SalesManViewModelSpec: AsyncSpec {
    override class func spec() {
        describe("SalesManViewModel") {
            var sut: SalesmenViewModelImpl!
            
            beforeEach {
                sut = SalesmenViewModelImpl(repository: FakeSalesmenRepository())
            }
            
            context("on init") {
                it("should have state as Loading initially") {
                    expect(sut.state).to(equal(.Loading))
                }
                
                it("should have an empty query initially") {
                    expect(sut.query).to(beEmpty())
                }
            }
            
            context("when fetching salesmen"){
                it("should load salesmen after fetch completes"){
                    sut.push(event: .FetchSalesmen)
                    let expectedResult =  [
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"]),
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!,name: "Bernd Schmitt", areas: ["7619*"]),
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!, name: "Chris Krapp", areas: ["762*"]),
                        Salesman(id: UUID(uuidString: "E621E1F9-C36C-495A-93FC-0C247A3E6E7F")!, name: "Alex Uber", areas: ["86*"])
                    ]
                    
                    await expect(sut.state).toEventually(equal(.Loaded(salesmen: expectedResult)))
                }
            }
            
            context("when querying salesmen") {
                it("should return Artem Titarenko for exact postcode match") {
                    sut.push(event: .Search(query: "76133"))
                    await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"])
                    ])))
                }
                
                
                it("should return Bernd Schmitt for wildcard match 7619*") {
                    sut.push(event: .Search(query: "76195"))
                    await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!, name: "Bernd Schmitt", areas: ["7619*"])
                    ])))
                }
                
                it("should return Chris Krapp for wildcard match 762*") {
                    sut.push(event: .Search(query: "76250"))
                    await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                        Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!, name: "Chris Krapp", areas: ["762*"])
                    ])))
                }
                
                it("should return Alex Uber for wildcard match 86*") {
                    sut.push(event: .Search(query: "86999"))
                    await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                        Salesman(id: UUID(uuidString: "E621E1F9-C36C-495A-93FC-0C247A3E6E7F")!, name: "Alex Uber", areas: ["86*"])
                    ])))
                }
                
                it("should return multiple salesmen if multiple matches exist") {
                    sut.push(event: .Search(query: "76*"))
                      await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"]),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!, name: "Bernd Schmitt", areas: ["7619*"] ),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!, name: "Chris Krapp", areas: ["762*"])
                      ])))
                  }
                  
                  it("should return empty if no salesmen match the query") {
                      sut.push(event: .Search(query: "99999"))
                      await expect(sut.state).toEventually(equal(.Empty))
                  }
                  
                  it("should return all salesmen if query is empty") {
                      sut.push(event: .Search(query: ""))
                      let expectedResult = [
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"]),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!, name: "Bernd Schmitt", areas: ["7619*"] ),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!, name: "Chris Krapp", areas: ["762*"] ),
                          Salesman(id: UUID(uuidString: "E621E1F9-C36C-495A-93FC-0C247A3E6E7F")!, name: "Alex Uber", areas: ["86*"] )
                      ]
                      await expect(sut.state).toEventually(equal(.Loaded(salesmen: expectedResult)))
                  }
                 
                  
                  it("should return salesmen if query is a prefix of a valid postcode") {
                      sut.push(event: .Search(query: "76"))
                      await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"]),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!, name: "Bernd Schmitt", areas: ["7619*"] ),
                          Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!, name: "Chris Krapp", areas: ["762*"])
                      ])))
                  }
                  
                  it("should return empty list if query contains non-numeric characters") {
                      sut.push(event: .Search(query: "76A"))
                      await expect(sut.state).toEventually(equal(.Empty))
                  }
                  
                  it("should return correct results if query matches multiple wildcard expressions") {
                      sut.push(event: .Search(query: "86"))
                      await expect(sut.state).toEventually(equal(.Loaded(salesmen: [
                          Salesman(id: UUID(uuidString: "E621E1F9-C36C-495A-93FC-0C247A3E6E7F")!, name: "Alex Uber", areas: ["86*"])
                      ])))
                  }
                  
                  it("should handle queries with leading zeros correctly") {
                      sut.push(event: .Search(query: "076"))
                      await expect(sut.state).toEventually(equal(.Empty))
                  }
            }
        }
    }
}
