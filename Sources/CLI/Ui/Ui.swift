import Foundation

struct Ui {
  static func info(_ output: String) {
    print(output)
  }

  static func error(_ output: String) {
    info(output)
  }

  static func inline(_ output: String) {
    print(output, terminator: "")
    fflush(stdout)
  }
}
