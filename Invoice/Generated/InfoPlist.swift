// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length number_separator type_body_length
enum InfoPlist {
  static let nsCameraUsageDescription: String = "Used to take invoice or receipt photos"
  enum ActivityType: String {
    case editInvoice = "sk.calfavladimir.visma.Invoice.activity.editInvoice"
    case takePhoto = "sk.calfavladimir.visma.Invoice.activity.takePhoto"
  }
  static let uiApplicationSceneManifest: [String: Any] = ["UIApplicationSupportsMultipleScenes": false, "UISceneConfigurations": ["UIWindowSceneSessionRoleApplication": [["UISceneConfigurationName": "Default Configuration", "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"]]]]
}

extension  NSUserActivity {
  convenience init(activity: InfoPlist.ActivityType) {
    self.init(activityType: activity.rawValue)
  }
  var registredActivityType: InfoPlist.ActivityType? {
      InfoPlist.ActivityType(rawValue: activityType)
  }
}
// swiftlint:enable identifier_name line_length number_separator type_body_length
