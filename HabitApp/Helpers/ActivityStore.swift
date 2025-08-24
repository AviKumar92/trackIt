//
//  ActivityStore.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//

import Foundation

final class ActivityStore {
    static let shared = ActivityStore()

    private let queue = DispatchQueue(label: "ActivityStore.queue", qos: .utility)
    private let fileURL: URL

    static let didChange = Notification.Name("ActivityStore.didChange")

    private init() {
        let fm = FileManager.default
        let base = try! fm.url(for: .applicationSupportDirectory,
                               in: .userDomainMask,
                               appropriateFor: nil,
                               create: true)
        let dir = base.appendingPathComponent("HabitApp", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        self.fileURL = dir.appendingPathComponent("activities.json")
    }

    func load(completion: @escaping ([Activity]) -> Void) {
        queue.async {
            let data = (try? Data(contentsOf: self.fileURL)) ?? Data("[]".utf8)
            let items = (try? JSONDecoder().decode([Activity].self, from: data)) ?? []
            DispatchQueue.main.async { completion(items.sorted { $0.startDate > $1.startDate }) }
        }
    }

    func add(_ activity: Activity, completion: (() -> Void)? = nil) {
        queue.async {
            var list: [Activity] = []
            if let data = try? Data(contentsOf: self.fileURL),
               let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
                list = decoded
            }
            list.append(activity)
            if let data = try? JSONEncoder().encode(list) {
                try? data.write(to: self.fileURL, options: .atomic)
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ActivityStore.didChange, object: nil)
                completion?()
            }
        }
    }
}
