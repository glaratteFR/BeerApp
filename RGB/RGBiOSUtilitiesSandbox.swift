// RGBiOSUtilitiesSandbox

//

// Depends on RGBIOSUtilities.swift

//

// Updated (headerdoc added) on 30-01-2018

//

import Foundation



//

// Given the URL of a directory and an extension, this function produces a list

// of URLs with that extension.

//

// Case is not meaningful for extensions

//

//MARK:    List files with a given extension (or all with *, for easier coding)



/// List of URLs for all files in a given directory with a given extension, in the Sandbox of the app. If the extension is "*" then all files in the folder will be shown. Now working.

///

/// - Parameters:

///   - directory: Path or name of a folder inside the Sandbox of this app

///   - ext: Extension of the files to be found in the folder given as first parameter

/// - Returns: An [URL] that holds the URls of all files with the given extension found in the given folder in the Sandbos.

public  func listOfSandboxFilesIn(directory: URL, withExtension ext : String) -> [URL] {

  let dfm = FileManager.default

  

  do {

    let contents = try dfm.contentsOfDirectory(at: directory,

                                               includingPropertiesForKeys: nil ,

                                               options: .skipsSubdirectoryDescendants)

    // The following list contains just files, not directories

    let justFilesNoDirs =  contents.filter() { !isDirectory(url: $0) }

    // If we want all files, return them. Otherwise keep only the files with the given extension

    return ext == "*" ? justFilesNoDirs : justFilesNoDirs.filter() { $0.pathExtension == ext }

  } catch {



    print("\nCould not list files in " + directory.path)

    print("\(error)")

    return [URL]()

  }

}

//

// Given the URL of a directory and an extension, this function produces a list

// of URLs with that extension.

//

// Case is not meaningful for extensions

//

//MARK:    List directories in a given one, non-recursive



/// Non-recursive listing of directories found in a given directory in the Sandbox of this app

///

/// - Parameter directory: Path (URL) of a directory in the sandbox

/// - Returns: An [URL] that holds all directories found in the given path (non-recursive).

public  func listOfSandboxDirectoriesIn(directory: URL) -> [URL] {

  let dfm = FileManager.default

  

  do {

    let contents = try dfm.contentsOfDirectory(at: directory,

                                               includingPropertiesForKeys: nil ,

                                               options: .skipsSubdirectoryDescendants)

    return contents.filter() { isDirectory(url: $0) }

  } catch {

    print("\nCould not list directories in " + directory.path)

    print("\(error)")

    return [URL]()

  }

}



//

// Given a list of URLs, this funcion shows a prettyprinted list of any items in the list

//

//MARK: Show objects in a directory as a text

///

/// Prints the characteristics of the objects pointed to by the given list of URLs

///

/// - Parameter list: An [URL] that holds the paths to a list of objects.

public func showContentsOf(list : [URL]) -> Void {

  let dfm = FileManager.default

  

  for item in list where dfm.fileExists(atPath: item.path) {

    print(item.path.padding(toLength: 120,

                            withPad: " ",

                            startingAt: 0)

      + " is a"

      + (isHidden(url: item) ? " hidden" : "")

      + (isDirectory(url: item) ? " directory" : " file"))

  }

} // End of showContentsOf:



// MARK: Give back objects in a directory as a String



/// A prettyprinted String that contains existing items in the list qualified with "hidden" if necessary and then "directory" or "file".

///

/// - Parameter list: An [URL] that holds the paths to various objects.

/// - Returns: A single instance of String that holds the description of an object in each line. The String is ready to be printed on the console.

public func stringWithPrettyPrintedURLsIn(list : [URL]) -> String {

  let dfm = FileManager.default

  

  var result : String = ""

  for item in list where dfm.fileExists(atPath: item.path) {

    result += item.path.padding(toLength: 120,

                                withPad: " ",

                                startingAt: 0)

      + " is a"

      + (isHidden(url: item) ? " hidden" : "")

      + (isDirectory(url: item) ? " directory" : " file")

      + "\n"

    

  }

  return result

} // End of prettyPrintURLsIn
