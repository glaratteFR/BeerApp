

// RGBiOSUtilitiesBundle

//

// Depends on RGBIOSUtilities.swift

//

// If prints for debugging must work, just add -D PRINT_FOR_DEBUGGING in Other Swift Flags

// (Cmd-1, click on project, enter Other Swift Flags in search field)

//

// Updated (headerdoc added) on 30-01-2018

//

import Foundation



//MARK: bundleReadAsString(fileName:,withExtension:) -> String



/// Read a text file that is in supposed to be in the bundle (not in a real folder in the bundle)

///

/// - Parameters:

///   - fileName: Name of a file in the bundle of this app

///   - fileExtension: Extension of this file in the bundle of this app

/// - Returns: Contents of the file as a String?, if the file does exist and can be read.

public func bundleReadAsString(fileName:String, withExtension fileExtension:String) -> String? {

  var text:String?

  //

  // If the file is not found in the bundle, the string

  // given back by this method will be nil

  //

  guard

    let temp = Bundle.main.url(forResource: fileName,

                               withExtension: fileExtension),

    !temp.hasDirectoryPath

    else { return nil }

  //

  // If we get here,there IS a file in the bundle with that name

  //

  do {

    text = try String(contentsOf: temp)

  } catch {

    text = nil

  }



  return text

} // End of bundleReadAsString()



//MARK: readAllLinesFromFile(fileName:withExtension:)

/// Emulates Files.readAllLines(). Returns an optional.

///

/// - Parameters:

///   - name: The name of the file, supposedly placed in the bundle of this app

///   - ext: extension of the file

/// - Returns: A [String]? that holds all lines from the file

public func bundleReadAllLinesFromFile(_ name:String, withExtension ext:String) -> [String]? {

  if let contents = bundleReadAsString(fileName: name, withExtension: ext) {

    return contents.components(separatedBy: "\n")

  } else {

    return nil

  }

} // End of bundleReadAllLinesFromFile(fileName:withExtension:)



//MARK: bundleReadAllLinesFromFile(_:,inFolder:withExtension:)

///

/// Emulates Files.readAllLines() for a file placed inside a folder in the bundle. Returns an optional.

///

/// - Parameters:

///   - name: Name of the file, supposed to be placed inside a real folder in the bundle

///   - folder: Name of the folder that holds the file, placed inside the bundle.

///   - ext: Extension of the file

/// - Returns: A [String]? taht holds all lines in the file.

public func bundleReadAllLinesFromFile(_ name:String,

                                       inFolder folder:String,

                                       withExtension ext:String) -> [String]? {



  if let contents = bundleReadAsStringFromFolder(folderName: folder,

                                                 fileName: name,

                                                 withExtension: ext) {

    return contents.components(separatedBy: "\n")

  } else {

    return nil

  }



} // End of bundleReadAllLinesFromFile(_:,inFolder:withExtensino)



//MARK: bundleReadAsStringFromFolder(_:,fileName:,withExtension:) -> String



/// Read a text file that is supposed to be in the bundle in a real folder, returning it as ONE optional String.

///

/// - Parameters:

///   - folderName: Name of the folder that holds the file, placed inside the bundle.

///   - fileName: Name of the file, supposed to be placed inside a real folder in the bundle

///   - fileExtension: Extension of the file

/// - Returns: One single line with the whole contents of the file placed in a folder in the bundle, as a single String?

public func bundleReadAsStringFromFolder(folderName:String,

                                         fileName:String,

                                         withExtension fileExtension:String) -> String? {

  var text:String? = nil



  if let temp = Bundle.main.url(forResource: fileName,

                                withExtension: fileExtension,

                                subdirectory: folderName) {

    do {

      text = try String(contentsOf: temp)

    } catch  {

      text = nil

    } // End of do/catch



  } // End of if/let

  return text

} // End of bundleReadAsStringFromFolder()





//MARK: shallowListingOfObjectsInBundle()

/// Gives back the names of all objects in the bundle directory (no recursive traversing), ready to be printed as text. Each name is complemented with a description that shows whether it is a file or a folder.

///

/// - Returns: An optional String with the names of all objects prepended with File: or Directory:. Each object is in one line.

public func shallowListingOfObjectsInBundle() -> String? {

  var text = ""



  //

  // MAIN ACCESS METHOD - URLs OF ITEMS IN BUNDLE

  //

  if let itemURLs = Bundle.main.urls(forResourcesWithExtension: nil,

                                     subdirectory: nil) {

    #if PRINT_FOR_DEBUGGING

      print(itemURLs)

    #endif



    itemURLs.forEach() {

      text.append( (isDirectory(url: $0) ? "Directory : " : "File      : ")

        + "\($0.lastPathComponent)"

        + "\n")

    } // End of forEach

    return text

  } // End of if let

  else {

    return nil

  }

} // End of shallowListingOfObjectsInBundle()



//MARK: deepListingOfRealDirectoryInBundle(_:) -> String?

/// Gives back a String? with the recursive listing of a real directory in the bundle, needs work

// Not yet well done

public func deepListingOfRealDirectoryInBundle(_ url:URL) -> String? {



  let nameOfSubdirectory = url.lastPathComponent

  var text = "Subdirectory " + nameOfSubdirectory + "\n"

  let directoryContents = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: nameOfSubdirectory)

  directoryContents?.forEach() {

    if isDirectory(url: $0) {

      text.append("Directory: \($0)\n")

    } else {

      text.append( "File      : "

        + "\($0.lastPathComponent)"

        + "\n")

    }

  }

  return text

} // End of deepListingOfRealDirectoryInBundle







//MARK: deepListingOfBundle() -> String?

/// Gives back a String? with the recursive listing of all objects the bundle

public func deepListingOfBundle() -> String? {

  var text = ""



  //

  // MAIN ACCESS METHOD - URLs OF ALL ITEMS IN BUNDLE

  //

  if let itemURLs = Bundle.main.urls(forResourcesWithExtension: nil,

                                     subdirectory: nil) {



    itemURLs.forEach() {

      if isDirectory(url: $0) {

        text.append("Directory \($0):\n")

      } else {

        text.append( ("File      : ")

          + "\($0)"

          + "\n")

      }

    } // End of forEach



  } // End of if let



  return text





} // End of deepListingOfBundle()







//MARK: deepListingOfDirectoriesInBundle() -> String?

/// Gives back a String? with the recursive listing of all objects of type directory in the bundle

func deepListingOfDirectoriesInBundle() -> String? {

  var text = ""

  let dfm = FileManager.default

  if  let bundleResourceURL = Bundle.main.resourceURL {



    if let itemURLs =   dfm.enumerator(at:  bundleResourceURL,

                                       includingPropertiesForKeys: []) {

      itemURLs.forEach() {

        let url = $0 as! URL

        if isDirectory(url: url) {

          text.append( url.absoluteString

            + "\n\n")

        }

      }

    } // End of forEach



  } // End of if let



  return text

} // End of deepListingOfDirectoriesInBundle()







//MARK: listingOfFilesInBundle(withExtension:) -> String?





/// The recursive listing of all files with a given extension in the bundle

///

/// - Parameter fileExtension: The extension of the files to be found in the bundle

/// - Returns: A String? that holds each of the files in the bundle with the given extension. Each file is in its own line.

func listingOfFilesInBundle(withExtension fileExtension:String) -> String? {

  var text:String?

  guard

    let itemURLs =   Bundle.main.urls(forResourcesWithExtension: fileExtension,

                                      subdirectory:nil),

    !itemURLs.isEmpty

    else {

      return nil

  } // End of guard



  itemURLs.forEach() { text?.append( $0.absoluteString + "\n\n") }

  return text

} // End of listingOfFilesInBundle()





// This method gives back the list of resources with a given extension that are stored inside a folder in the bundle. Do realize that a relative path into that folder is easy to build and lets the programmer access any file of a given type inside a given folder in the bundle, even when the final parent folder is nested 3 deep into the topmost one. In other words, folder denotes folder_path within the bundle.

//

// DEEP LISTINGS NOT WORKING YET

//

//MARK: listingOfBundleFilesInRealDirectory(_:withExtension:) -> String?



/// This method gives back the list of resources with a given extension that are stored inside a folder in the bundle. Do realize that a relative path into that folder is easy to build and lets the programmer access any file of a given type inside a given folder in the bundle, even when the final parent folder is nested 3 deep into the topmost one. In other words, folder denotes folder_path within the bundle.

///

/// - Parameters:

///   - folder: The path to a folder inside the bundle. It can hold a complex path inside the folder.

///   - fileExtension: The extension of the files to be found.

/// - Returns: A [String]? that holdes, in each line, the name of a file with the given extension. All files belong to the folder whose path is given as the first argument.

func listingOfBundleFilesInRealDirectory(folder:String,

                                         withExtension fileExtension:String) -> String? {

  var text:String?

  //

  // Just write the path to the subdirectory (folder media_blue) in the second argument

  //

  guard

    let itemURLs =   Bundle.main.urls(forResourcesWithExtension: fileExtension,

                                      subdirectory: folder),

    !itemURLs.isEmpty

    else {

      return nil

  } // End of guard



  itemURLs.forEach() { text?.append( $0.absoluteString + "\n\n") }

  return text

}
