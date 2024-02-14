//
//  AppDatabase.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation
import GRDB

class AppDatabase {
    
    let dbWriter: DatabaseWriter
    
    convenience init() {
        do {
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            
            let databaseURL = directoryURL.appendingPathComponent("5610413841.sqlite")
            let dbQueue = try DatabaseQueue(path: databaseURL.path)
            try self.init(dbQueue)
        } catch {
            fatalError("Could not create the database \(error)")
        }
    }
    
    init(_ databaseQueue: DatabaseQueue) throws {
        self.dbWriter = databaseQueue
        try migrator.migrate(databaseQueue)
    }
}

extension AppDatabase {
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        // See <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/migrations>
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("initial") { db in
            try db.create(table: "gameDb") { t in
                t.column("id", .text)
                    .notNull()
                    .primaryKey()
                t.column("state", .text)
                    .notNull()
                t.column("roundNumber", .text)
                    .notNull()
            }
            
            try db.create(table: "playerDb") { t in
                t.column("id", .text)
                    .notNull()
                    .primaryKey()
                t.column("name", .text)
                    .notNull()
                t.column("gameId")
                    .notNull()
                t.column("score", .integer)
                    .notNull()
                t.column("bid", .integer)
                    .notNull()
                t.column("trickWons", .integer)
                    .notNull()
                t.column("bonusPoints", .integer)
                    .notNull()
            }
        }
        
        return migrator
    }
}
