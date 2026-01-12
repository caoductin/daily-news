//
//  MigrationV1.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//


import SQLite

struct MigrationV1 {
    func run(_ db: Connection) {
        do {
            try db.run(PostTable.table.create(ifNotExists: true) { t in
                t.column(PostTable.id, primaryKey: true)
                t.column(PostTable.userId)
                t.column(PostTable.title)
                t.column(PostTable.content)
                t.column(PostTable.image)
                t.column(PostTable.category)
                t.column(PostTable.slug)
                t.column(PostTable.createdAt)
                t.column(PostTable.updatedAt)
            })
        } catch {
            print("MigrationV1 failed:", error)
        }
    }
}
