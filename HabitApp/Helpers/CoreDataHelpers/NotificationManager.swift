

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    
    private let center = UNUserNotificationCenter.current()
    
    
    func requestAuthorization() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("Notification permission error: \(error.localizedDescription)")
               }
               print("Notification granted: \(granted)")
           }
       }
    
    // Check status and redirect to Settings if denied
        func checkPermissionAndRedirect(from vc: UIViewController) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .denied {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Enable Notifications",
                            message: "Notifications are turned off. Please enable them in Settings to get reminders.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        })
                        vc.present(alert, animated: true)
                    }
                }
            }
        }
    
    
    func scheduleNotifications(for habit: Habits) {
        guard habit.isReminderOn else { return }
        // Ensure we have an id
        let uuid = habit.id?.uuidString
        
        
        // Cancel existing ones for this habit id first
        removeNotifications(for: habit)
        
        
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: habit.time ?? Date())
        let hour = comps.hour ?? 9
        let minute = comps.minute ?? 0
        
        
        switch habit.frequencyData {
        case .daily:
            let identifier = "habit-\(uuid)-daily"
            let content = makeContent(title: habit.name ?? "", body: habit.notes)
            var dc = DateComponents(); dc.hour = hour; dc.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            let req = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(req) { if let e = $0 { print("add notif error:", e) } }
            
            
        case .weekly:
            guard let weekdays = habit.weeklyDays, !weekdays.isEmpty else { return }
            for wd in weekdays {
                let identifier = "habit-\(uuid)-weekly-\(wd)"
                let content = makeContent(title: habit.name ?? "", body: habit.notes)
                var dc = DateComponents(); dc.weekday = wd; dc.hour = hour; dc.minute = minute
                let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
                let req = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(req) { if let e = $0 { print("add notif error:", e) } }
            }
            
            
        case .monthly:
            guard let days = habit.monthlyDates, !days.isEmpty else { return }
            /*
             for d in days {
             let identifier = "habit-\(uuid)-monthly-\(d)"
             let content = makeContent(title: habit.name ?? "", body: habit.notes)
             var dc = DateComponents(); dc.day = d; dc.hour = hour; dc.minute = minute
             let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
             let req = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
             center.add(req) { if let e = $0 { print("add notif error:", e) } }
             }*/
        }
    }
    
    
    func removeNotifications(for habit: Habits) {
        let uuid = habit.id?.uuidString
        var ids: [String] = []
        
        
        // daily id
        ids.append("habit-\(uuid)-daily")
        
        
        if let wd = habit.weeklyDays {
            ids.append(contentsOf: wd.map { "habit-\(uuid)-weekly-\($0)" })
        }
        if let md = habit.monthlyDates {
            ids.append(contentsOf: md.map { "habit-\(uuid)-monthly-\($0)" })
        }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    
    private func makeContent(title: String, body: String?) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        if let b = body, !b.isEmpty { content.body = b }
        content.sound = .default
        return content
    }
}
