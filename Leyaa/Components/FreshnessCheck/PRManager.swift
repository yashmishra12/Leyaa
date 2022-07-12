//
//  PRManager.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/12/22.
//

import Foundation
import UserNotifications

class PRManager: ObservableObject {
        
    @Published private(set) var prArray: [PendingReminder] = []
    @Published var roomName: String = ""
    
    init(name: String? = nil) {
        if let name = name {
            roomName = name
        } else {
            roomName = ""
        }
    }
    
    func updateArray() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    if request.content.title == "Freshness Check." && request.content.subtitle == self.roomName {
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
                            
                            pr.timestamp = formattedDate
                            
                            self.prArray.append(pr)
                        }
                        
                    }
                    
                }
            }
        }
    }
    

}