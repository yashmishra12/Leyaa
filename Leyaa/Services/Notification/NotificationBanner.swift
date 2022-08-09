//
//  NotificationBanner.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import Foundation
import NotificationBannerSwift




//MARK: - Success Status Bar Banner

func successSB(title: String) {
    let banner = StatusBarNotificationBanner(title: "\(title)", style: .success)
    banner.dismiss()
    banner.show()
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                banner.dismiss()
                            }

}

func errorBanner(title: String, subtitle: String) {
    let banner = GrowingNotificationBanner(title: "\(title)", subtitle: "\(subtitle)", style: .danger)
    
    banner.dismiss()
    banner.show()
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                banner.dismiss()
                            }

}


func successSBItemAdded(title: String) {
    let banner = StatusBarNotificationBanner(title: "\(title)", style: .success)

    banner.dismiss()
    banner.show()
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                banner.dismiss()
                            }

}

//MARK: - Info Status Bar Banner

func infoSB(title: String) {
    let banner = StatusBarNotificationBanner(title: "\(title)", style: .info)
    banner.dismiss()
    banner.show()
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                banner.dismiss()
                            }
}



//MARK: - Forgot Password

func forgotPasswordNB() {
    let banner = NotificationBanner(title: "Link Sent", subtitle: "Check your Inbox and Spam", style: .success)
    banner.dismiss()
    banner.show()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        banner.dismiss()
    }
}

func messageChatInfo() {
    let banner = GrowingNotificationBanner(title: "Message wall", subtitle: "1. Long press on your avatar to delete message.\n\n2 Tap on avatars to get post's timestamp.\n\n3. Hit the 'Notify All' Button if you want to send notifications to everyone. Wall Messages is meant for important posts and not conversation.", style: .info)
    banner.dismiss()
    banner.show()
    banner.haptic = .medium
    banner.autoDismiss = false
    
    banner.dismissOnTap = true
    banner.dismissOnSwipeUp = true

    
    DispatchQueue.main.asyncAfter(deadline: .now()+15) {
        banner.dismiss()
    }
}
