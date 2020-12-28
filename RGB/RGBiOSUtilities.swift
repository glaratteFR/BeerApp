// RGBiOSUtilities

//

// Use at your own risk, no guarantees..

//

// Updated (headerdoc added) on 30-01-2018

//

import Foundation

import UIKit

//MARK: notifyUser(_:,alertTitle: alertMessage:ok:)



/// Shows an alert for the given controller. Requires a title and an alert message; only shows an OK button (no Cancel or other buttons)

///

/// - Parameters:

///   - controller: the ViewController inside which this alert is to be shown

///   - title: The title of the alert, at the top of the dialog

///   - alertMessage: The message to be shown in the alert, right below the title in a smaller script

///   - runOnOK: The function or closure to be called once the dialog ends (because the user taps OK)

public func notifyUser(_ controller:UIViewController,

                       alertTitle title:String,

                       alertMessage:String,

                       runOnOK:@escaping (UIAlertAction) -> Void) {

  

  let alertViewController = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)

  

  let okAction = UIAlertAction(title: "OK", style: .default, handler: runOnOK)

  

  alertViewController.addAction(okAction)

  

    
  controller.present(alertViewController, animated: true, completion: nil)

}



//public func doSomethingOnOK(alert:UIAlertAction) {

//    // Put this function in the class that calls notifyUser()

//    // Do whatever is needed

//}



//MARK: userConfirmsAction(_:,alertTitle:, alertMessage:, runOnConfirm:)



/// Shows an user-confirmed alert for this app

/// Shows an alert for the given controller. Requires a title and an alert message; the dialog shows both an OK button and a Cancel button. When one of these is tapped, the dialog closes and ither the runOnConfirm: or the runOnCancel: functions or closures are executed. Both may be { _ in }, that is, do nothing.

///

/// - Parameters:

///   - controller: The ViewController inside which this alert is to be shown

///   - title: The main title of the alert, shown in bold lettering at the top of the dialog

///   - alertMessage: The information shown in the alert, right below the main title

///   - runOnConfirm: A function or closure to be run when the user taps OK. It can be empty, { _ in }

///   - runOnCancel: A function or closure to be run when the user taps Cancel.It can be empt, { _ in }

public func userConfirmsAction(_ controller:UIViewController,

                               alertTitle title:String,

                               alertMessage:String,

                               runOnConfirm: @escaping (UIAlertAction) -> (),

                               runOnCancel: @escaping (UIAlertAction) -> ()) {

  

  let alertViewController = UIAlertController(title:title,

                                              message: alertMessage,

                                              preferredStyle: UIAlertController.Style.alert)

  

  alertViewController.addAction(UIAlertAction(title: "Confirm",

                                              style: .destructive,

                                              handler: runOnConfirm ))

  

  alertViewController.addAction(UIAlertAction(title: "CANCEL",

                                              style: .cancel,

                                              handler: runOnCancel))

  

  controller.present(alertViewController, animated: true, completion: nil)

  

}



//func doSomethingOnConfirm(alert:UIAlertAction) {

//    // Put this function in the class that calls userConfirmsAction()

//    // Do whatever is needed on confirm

//}



//public func doSomethingOnCancel(alert:UIAlertAction) {

//    // Put this function in the class that calls userConfirmsAction()

//    // Do whatever is needed on cancel

//}



/// Address of the tmp folder as an URL for this app

///

/// - Returns: An URL that points to the tmp directory for this app (inside its sandbox). We are working in iOS.

public func tmpURL() -> URL {

  if #available(iOS 10.0, *) {

    let dfm = FileManager.default

    return dfm.temporaryDirectory

  } else {

    // Fallback on earlier versions

    return URL(string: NSTemporaryDirectory())!

  }

}



/// Address of the tmp directory for this app. We are working in iOS.

///

/// - Returns: A String that points to the tmp directory for this app (inside its sandbox) We are working in iOS.

public func tmpPath() -> String{

  return tmpURL().path

}



/// Address of the Documents folder as an URL for this app

///

/// - Returns: An URL that points to the Documents folder for this app (inside its sandbox). We are working in iOS.

public func documentsURL() -> URL {

  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

  let documentsDirectory = paths[0]

  return documentsDirectory

}



/// Address of the Documents path as a String for this app for sandboxing

///

/// - Returns: A String that points to the Documents folder for this app (inside its sandbox). We are working in iOS.

public func documentsPath() -> String {

  return documentsURL().path

}



/// Address of the Library folder for this app as an URL

///

/// - Returns: An URL that points to the Library folder for this app (inside its sandbox). We are working in iOS.

public func libraryURL() -> URL {

  let dfm = FileManager.default

  return dfm.urls(for: FileManager.SearchPathDirectory.libraryDirectory,

                  in: FileManager.SearchPathDomainMask.userDomainMask).first!

  

}



/// Address of the Library folder for this app as a String

///

/// - Returns: A String that points to the Library folder for this app (inside its sandbox). We are working in iOS.

public func libraryPath() -> String {

  return libraryURL().path

}



/// Returns the name and extension of a given filename

///

/// - Parameter total: The given filename, in the form "name.extension"

/// - Returns: A [String] whose first element is the file name and whose second element is the extension as given in the input parameter.

public func splitIntoNameAndExtension(total:String) -> [String]? {

  

  let parts = total.components(separatedBy: ".")

  

  guard

    parts.count == 2,

    let name = parts.first,

    !name.isEmpty,

    let ext = parts.last,

    !ext.isEmpty

    else

  { return nil }

  

  return [name, ext]

}



/// Is object at the given path a directory?

///

/// - Parameter path: A String path to some object

/// - Returns: True if the object is a directory, false otherwise

public func isDirectory(path: String) -> Bool {

  let dfm = FileManager.default

  var isDir: ObjCBool = false;

  dfm.fileExists(atPath: path, isDirectory: &isDir)

  return isDir.boolValue;

}



/// Is the object at the given URL a directory?

///

/// - Parameter url: The URL of some object

/// - Returns: True if the object is a directory, false otherwise

public func isDirectory(url: URL) -> Bool {

  let dfm = FileManager.default

  var isDir: ObjCBool = false;

  dfm.fileExists(atPath: url.path, isDirectory: &isDir)

  return isDir.boolValue;

}



/// Is the object with the given URL a directory? Does it exist?

///

/// - Parameter url: The URL to some object

/// - Returns: A tuple whose first value is true if the object exists, or false otherwise, and whose second element is true if the object is a directory, or false otherwise.

public func existsDirAt(url: URL) -> (fileExists:Bool, fileIsDirectory:Bool) {

  let dfm = FileManager.default

  var isDir: ObjCBool = false;

  let exists = dfm.fileExists(atPath: url.path, isDirectory: &isDir)

  return (exists, isDir.boolValue);

  

}



//MARK: isItHidden?

/// Returns whether the given URL belongs to a hidden object (file or directory)

///

/// - Parameter url: The URL to some object

/// - Returns: true if the object is hidden, false otherwise

public func isHidden(url : URL) -> Bool {

  return url.lastPathComponent.hasPrefix(".")

}
