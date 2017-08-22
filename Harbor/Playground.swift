import Foundation

class Playground {
  func writeFile(_ text: String) -> Bool {

    do {
      let tempURL = URL(string: "file:///tmp/holyfuckingshit.txt")
      try text.write(to: tempURL!, atomically: true, encoding: String.Encoding.utf8)
      return true
    } catch {
      print("Failed to write file")
      return false
    }
  }

  func readFromFile(_ fileName: String) throws -> String {
    //        let path = NSBundle.mainBundle().bundleURL
    //        let fileURL = path.URLByAppendingPathComponent(fileName);
    let fileURL = URL(string: fileName);
    return try String(contentsOf: fileURL!)
  }
}
