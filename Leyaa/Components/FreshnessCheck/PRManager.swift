import Foundation
import UserNotifications

@MainActor
class PRManager: ObservableObject {
    
    @Published var prArray: [PendingReminder] = []
    @Published var lastItemID: String = ""
    
    func updateArray(isDeleting: Bool) {
        prArray = []
        Task {
            let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
            
            for request in requests {
                if request.content.title == "Freshness Check" {
                    var pr = PendingReminder(id: request.identifier,
                                             body: request.content.body,
                                             subtitle: request.content.subtitle,
                                             timestamp: "")
                    
                    let givenDate = request.trigger?.value(forKey: "dateComponents")
                    if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
                       let date = gregorianCalendar.date(from: givenDate as! DateComponents) {
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        
                        let formattedDate = dateFormatter.string(from: date)
                        
                        await MainActor.run {
                            pr.timestamp = formattedDate
                            self.prArray.append(pr)
                            if !isDeleting {
                                self.lastItemID = pr.id
                            }
                        }
                    }
                }
            }
        }
    }
}
