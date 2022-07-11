//
//  NotificationBanner.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import Foundation
import NotificationBannerSwift

//MARK: - Success Notification Banner
func successNB(title: String) {
    let banner = NotificationBanner(title: "\(title)", style: .success)
    banner.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                banner.dismiss()
                            }

}

//MARK: - Success Status Bar Banner

func successSB(title: String) {
    let banner = StatusBarNotificationBanner(title: "\(title)", style: .success)
    banner.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                banner.dismiss()
                            }

}

//MARK: - Ingo Status Bar Banner

func infoSB(title: String) {
    let banner = StatusBarNotificationBanner(title: "\(title)", style: .info)
    banner.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                banner.dismiss()
                            }
}



//MARK: - Forgot Password

func forgotPasswordNB() {
    let banner = NotificationBanner(title: "Link Sent", subtitle: "Check your Inbox and Spam", style: .success)
    banner.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        banner.dismiss()
    }
}
