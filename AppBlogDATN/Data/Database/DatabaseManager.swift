//
//  DatabaseManager.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//

import Foundation
import SQLite

final class DatabaseManager {
    static let shared = DatabaseManager()
    let db: Connection

    private init() {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("app.sqlite3")

        db = try! Connection(url.path)
        runMigrations()
    }

    private func runMigrations() {
        MigrationV1().run(db)
    }
}
