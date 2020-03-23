import SwiftUI

struct ContentView: View {
  var fontSize: CGFloat = 150

  var body: some View {
    VStack {
      Group {
        Text("A")
          .underline()
        +
        Text("Stack*")
      }
      .font(Font.system(size: self.fontSize, weight: .heavy, design: .default))

      Group {
        Text("*The Missing ")
        +
        Text("A")
          .underline()
        +
        Text("daptive and ")
        +
        Text("A")
        .underline()
        +
        Text("ccessible SwiftUI Stacks Library.")
      }
      .font(.headline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewLayout(.fixed(width: 700, height: 250))
  }
}
