//
//  ItemCreateEnum.swift
//  Leyaa
//
//  Created by Yash Mishra on 7/11/22.
//

import Foundation
import Focuser


//MARK: - Item Create View
enum FormFieldsCreate {
    case name, quantity, description
}


extension FormFieldsCreate: FocusStateCompliant {

    static var last: FormFieldsCreate {
        .description
    }

    var next: FormFieldsCreate? {
        switch self {
        case .name:
            return .quantity
        case .quantity:
            return .description
        default: return nil
        }
    }
}


//MARK: - Item Edit View

enum FormFields {
    case name, quantity, description
}


extension FormFields: FocusStateCompliant {

    static var last: FormFields {
        .description
    }

    var next: FormFields? {
        switch self {
        case .name:
            return .quantity
        case .quantity:
            return .description
        default: return nil
        }
    }
}

//MARK: - Room Invite View

enum FormFieldsInvite {
    case email, message
}


extension FormFieldsInvite: FocusStateCompliant {

    static var last: FormFieldsInvite {
        .message
    }

    var next: FormFieldsInvite? {
        switch self {
        case .email:
            return .message
        default: return nil
        }
    }
}

//MARK: - Login

enum LoginFormFields {
    case email, password
}


extension LoginFormFields: FocusStateCompliant {

    static var last: LoginFormFields {
        .password
    }

    var next: LoginFormFields? {
        switch self {
        case .email:
            return .password
        default: return nil
        }
    }
}

//MARK: - Registration

enum RegistrationFormFields {
    case email, fullName, password
}


extension RegistrationFormFields: FocusStateCompliant {

    static var last: RegistrationFormFields {
        .password
    }

    var next: RegistrationFormFields? {
        switch self {
        case .email:
            return .fullName
        case .fullName:
            return .password
        default: return nil
        }
    }
}
