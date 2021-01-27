//
//  FootballService.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 19/1/21.
//

import Foundation
import EasyStash

class FootballService: ObservableObject {
    
    @Published var lastMatches: [String:PastMatchData] = [:]
    @Published var upcomingMatches: [String:UpcomingMatchData] = [:]
    @Published var teamsData: [String:TeamData] = [:]
    
    private static let MAX_LAST_MATCHES = 2
    private static let MAX_UPCOMING_MATCHES = 2
    
    public enum Teams: Int {
        case BOCA = 135156
        case BARCELONA = 133739
    }
    
    public static let instance = FootballService()
    
    private init(){
        fetchInfo(forTeamId: Teams.BOCA.rawValue)
        fetchInfo(forTeamId: Teams.BARCELONA.rawValue)
    }
    
    private func fetchInfo(forTeamId teamId: Int) {
        self.fetchLastMatches(for: teamId)
        self.fetchUpcomingMatches(for: teamId)
    }
    
    public func fetchLastMatches(for team: Int) {
        let url = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=\(team)"
        guard let serviceUrl = URL(string: url) else { return }
        HttpUtils.makePostRequest(url: serviceUrl) { (data, response, error) in
            if let data = data {
                let results: [String:[PastMatchData]] = try! JSONDecoder().decode([String:[PastMatchData]].self, from: data)
                DispatchQueue.main.async {
                    self.addLastMatches(matches: results["results"]!)
                }
            }
        }
    }
    
    public func fetchUpcomingMatches(for team: Int) {
        let url = "https://www.thesportsdb.com/api/v1/json/1/eventsnext.php?id=\(team)"
        guard let serviceUrl = URL(string: url) else { return }
        HttpUtils.makePostRequest(url: serviceUrl) { (data, response, error) in
            if let data = data {
                if let results: [String:[UpcomingMatchData]] = try? JSONDecoder().decode([String:[UpcomingMatchData]].self, from: data) {
                    DispatchQueue.main.async {
                        self.addUpcomingMatches(matches: results["events"]!)
                    }
                } else {
                    print("No upcoming events for team \(team)")
                }
            }
        }
    }
    
    private func addLastMatches(matches: [PastMatchData]) {
        for m in matches {
            print("add past match with eventId \(m.idEvent)")
            self.lastMatches[m.idEvent] = m
            self.fetchTeam(byId: m.idHomeTeam)
            self.fetchTeam(byId: m.idAwayTeam)
        }
        if self.lastMatches.count > Self.MAX_LAST_MATCHES {
            let sortedLastNMatches = self.lastMatches.values.sorted(by: {(m1, m2) in m1.dateEvent > m2.dateEvent})[0..<Self.MAX_LAST_MATCHES]
            self.lastMatches =  Dictionary(uniqueKeysWithValues: sortedLastNMatches.map({($0.idEvent, $0)}))
        }
        deDupMatches()
    }
    
    private func addUpcomingMatches(matches: [UpcomingMatchData]) {
        for m in matches {
            print("add upcoming match with eventId \(m.idEvent)")
            self.upcomingMatches[m.idEvent] = m
            self.fetchTeam(byId: m.idHomeTeam)
            self.fetchTeam(byId: m.idAwayTeam)
        }
        if self.upcomingMatches.count > Self.MAX_UPCOMING_MATCHES {
            let sortedUpcomingNMatches = self.upcomingMatches.values.sorted(by: {(m1, m2) in m1.strTimestamp < m2.strTimestamp})[0..<Self.MAX_UPCOMING_MATCHES]
            self.upcomingMatches =  Dictionary(uniqueKeysWithValues: sortedUpcomingNMatches.map({($0.idEvent, $0)}))
        }
        deDupMatches()
    }
    
    private func deDupMatches() {
        for pm in self.lastMatches.keys {
            self.upcomingMatches.removeValue(forKey: pm)
        }
    }
    
    private func fetchTeam(byId id: String) {
        if teamsData[id] != nil {
            return
        }
        let url = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=\(id)"
        guard let serviceUrl = URL(string: url) else { return }
        HttpUtils.makePostRequest(url: serviceUrl) { (data, response, error) in
            if let data = data {
                
                let results: [String:[TeamData]] = try! JSONDecoder().decode([String:[TeamData]].self, from: data)
                let teamData = results["teams"]![0]
                DispatchQueue.main.async {
                    self.addTeam(teamData: teamData)
                }
                self.fetchBadge(team: teamData)
            }
        }
    }
    
    private func fetchBadge(team: TeamData) {
        let url = team.strTeamBadge + "/preview"
        guard let serviceUrl = URL(string: url) else { return }
        
        let key = "badge-\(team.idTeam)"
        
        var options = Options()
        options.folder = "Images"
        let storage = try! Storage(options: options)
        
        if storage.exists(forKey: key) {
            return
        }
        HttpUtils.makeDownloadRequest(url: serviceUrl) { (location, response, error) in
            if let location = location {
                do {
                    let data = try! Data(contentsOf: location)
                    try storage.save(object: data, forKey: key)
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                    print("badge fetched")
                } catch {}
            }
        }
    }
    
    public func getBadge(forTeam teamId: String) -> Data? {
        let key = "badge-\(teamId)"
        
        var options = Options()
        options.folder = "Images"
        let storage = try! Storage(options: options)
        
        if storage.exists(forKey: key) {
            return try! storage.load(forKey: key) as Data
        }
        
        return nil
    }
    
    private func addTeam(teamData: TeamData) {
        self.teamsData[teamData.idTeam] = teamData
    }
    
}

struct PastMatchData: Decodable {
    let idEvent: String
    let dateEvent: String
    let strTimestamp: String
    let intHomeScore: String
    let intAwayScore: String
    let strLeague: String
    let idAwayTeam: String
    let idHomeTeam: String
}

struct UpcomingMatchData: Decodable {
    let idEvent: String
    let strTimestamp: String
    let strLeague: String
    let idAwayTeam: String
    let idHomeTeam: String
}

struct TeamData: Decodable {
    let idTeam: String
    let strTeamBadge: String
    let strTeam: String
}
