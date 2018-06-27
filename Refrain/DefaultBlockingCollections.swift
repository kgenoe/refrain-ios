//
//  DefaultBlockingCollections.swift
//  Refrain
//
//  Created by Kyle on 2018-05-15.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

struct DefaultBlockingCollections {
    
    
    private let haveDefaultCollectionsBeenCreatedKey = "haveDefaultCollectionsBeenCreated"

    
    init() { }
    
    /// Creates default collections and adds them to the blocking collection store. If default collections have already been created, this does nothing.
    func createDefaultCollections() {
        
        let haveDefaultCollectionsBeenCreated = UserDefaults.standard.bool(forKey: haveDefaultCollectionsBeenCreatedKey)
        if !haveDefaultCollectionsBeenCreated {
            UserDefaults.standard.set(true, forKey: haveDefaultCollectionsBeenCreatedKey)

            
            for (collectionName, filters) in defaultCollections {
                
                // create collection
                let collection = BlockingCollection(name: collectionName, enabled: false)
                collection.isDefault = true
                
                // add rules to collection
                for filter in filters {
                    let rule = BlockingRule(urlFilter: filter, ruleDescription: "")
                    collection.rules.append(rule)
                }
                
                // save collection to collection store
                BlockingCollectionStore.shared.saveCollection(collection)
            }
        }
    }

    func restoreDefaultCollectionToDefault(collection: BlockingCollection) {
        
        // ensure that the provided collection is a default collection
        guard collection.isDefault == true else { return }
        
        // ensure that the provided colleciton exists in the default collections
        guard let filters = defaultCollections[collection.name] else { return }
        
        // reset the collection's rules
        collection.rules = []
        
        // add rules to collection
        for filter in filters {
            let rule = BlockingRule(urlFilter: filter, ruleDescription: "")
            collection.rules.append(rule)
        }
        
        // save collection to collection store
        BlockingCollectionStore.shared.saveCollection(collection)
    }
    

    let defaultCollections: [String: [String]] = [
        "Social Media" : [
            "facebook.com",
            "twitter.com",
            "reddit.com",
            "instagram.com",
            "snapchat.com",
            "pinterest.com",
            "tumblr.com",
            "flickr.com"
        ],
        "News" : [
            "cnn.com",
            "nytimes.com",
            "washingtonpost.com",
            "nbcnews.com",
            "cbsnews.com",
            "forbes.com",
            "wsj.com",
            "bloomberg.com",
            "reuters.com",
            "buzzfeed.com",
            "time.com",
            "nypost.com",
            "thehill.com",
            "theatlantic.com",
            "latimes.com",
            "abcnews.go.com",
            "foxnews.com",
            "news.google.com",
            "news.yahoo.com",
            "theguardian.com",
            "bbc.com/news",
            "news.sky.com",
            "independent.co.uk",
            "telegraph.co.uk",
            "express.co.uk",
            "indiatimes.com",
            "cbc.ca/news",
            "globalnews.ca",
            "ctvnews.ca",
            "theglobeandmail.com",
            "thestar.com",
            "huffingtonpost.ca",
            "mccleans.ca"
        ],
        "Videos" : [
            "netflix.com",
            "youtube.com",
            "hulu.com",
            "app.plex.tv",
        ],
        "Sports" : [
            "sports.yahoo.com",
            "espn.com",
            "bleacherreport.com",
            "cbssports.com",
            "si.com",
            "nbcsports.com",
            "sbnation.com",
            "foxsports.com",
            "mlb.com",
            "nba.com",
            "nfl.com",
            "ncaa.com",
            "rivals.com",
            "deadspin.com",
            "sportingnews.com",
            "goal.com",
            "skysports.com",
            "sport.bt.com",
            "bbc.com/sport",
            "espn.co.uk"
        ],
        "Technology" : [
            "techcrunch.com",
            "arstechnica.com",
            "thenextweb.com",
            "wired.com",
            "gizmodo.com",
            "mashable.com",
            "theverge.com",
            "digitaltrends.com",
            "techradar.com",
            "businessinsider.com",
            "macrumours.com",
            "9to5mac.com",
            "daringfireball.com",
            "venturebeat.com",
            "engadget.com",
            "gadgetreview.com",
            ""
        ],
        "Gaming" : [
            "twitch.tv",
            "ign.com",
            "gamespot.com",
            "kotaku.com",
            "n4g.com",
            "escapistmagazine.com",
            "pcgamer.com",
            "neoseeker.com",
            "giantbomb.com",
            "gamefront.com",
            "joystiq.com",
            "gametrailers.com",
            "gamesradar.com",
            "cheatcc.com",
            "supercheats.com"
        ],
        "Shopping" : [
            "amazon.com",
            "ebay.ca",
            "redflagdeals.com",
            "etsy.com",
            "amazon.ca",
            "overstock.com"
        ]
    ]
    
}
