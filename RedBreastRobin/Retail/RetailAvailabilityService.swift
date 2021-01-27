//
//  RetailAvailabilityService.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 23/1/21.
//

import Foundation
import SwiftSoup

class RetailAvailabilityService: ObservableObject {
    @Published public var ps5ProvidersWithStock: [Provider] = []
    @Published public var ps5DEProvidersWithStock: [Provider] = []
    @Published public var lgc1Available: Bool = false
    
    public static let instance = RetailAvailabilityService()
    
    private init() {
        queryAvailability()
    }
    
    private static let providersBlackList: [String] = ["ebay", "stockx"]
    
    private func queryAvailability() {
        queryPS5Availability()
        queryLGC1Availability()
    }
    
    private func queryPS5Availability() {
        if let url = URL(string: "https://www.stockinformer.co.uk/checker-ps5-playstation-5-console") {
            do {
                let contents = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(contents)
                if let ps5Root = try doc.getElementById("UpdatePanelProduct1") {
                    let ps5Header: Element? = try ps5Root.getElementsByTag("td").first()!
                    if try ps5Header?.html() != nil {
                        let providers = try ps5Root.getElementsByClass("table-row").array().filter({
                            do {
                                let alt: String = try $0.getAllElements().attr("alt")
                                return Self.providersBlackList.allSatisfy({ blacklistedProvider in !alt.lowercased().contains(blacklistedProvider) })
                            } catch {
                                return false
                            }
                        })
                        
                        let providersWithStock = providers.filter({
                            do {
                                return try !$0.getElementsByClass("alert-success").isEmpty()
                            } catch {
                                return false
                            }
                        })
                        self.ps5ProvidersWithStock = providersWithStock.map({
                            do {
                                let alt: String = try $0.getAllElements().attr("alt")
                                let href: String = try $0.getElementsByTag("a").last()!.attr("href")
                                print("provider: \(alt) \(href)")
                                return Provider(name: alt, link: "https://www.stockinformer.co.uk/\(href)")
                            } catch {
                                return Provider(name: "Error", link: "Error")
                            }
                        })
                    }
                }
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("the URL was bad!")
        }
    }
    
    
    private func queryLGC1Availability() {
        if let url = URL(string: "https://www.lg.com/us/tvs/lg-oled55c1pub-oled-4k-tv") {
            do {
                let contents = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(contents)
                self.lgc1Available = try doc.getElementsByTag("span").array().allSatisfy({
                    do {
                        return try $0.html() != "COMING SOON"
                    } catch {
                        return true
                    }
                })
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("the URL was bad!")
        }
    }
}

struct Provider {
    let name: String
    let link: String
}
