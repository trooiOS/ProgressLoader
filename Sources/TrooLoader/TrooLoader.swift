import SwiftUI

@available(iOS 13.0, *)
public struct TrooLoader<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var message: String = "Loading..."
    var content: () -> Content
    var font: SwiftUI.Font?
    var forgroundColor: Color
    
    public init(isShowing: Binding<Bool>? = nil, message: String = "Loading...", font: SwiftUI.Font = .largeTitle, forgroundColor: Color = .black, @ViewBuilder _ content: @escaping () -> Content) {
        if isShowing != nil {
            self._isShowing = isShowing!
        } else {
            self._isShowing = .constant(false)
        }
        self.content = content
        self.message = message
        self.font = font
        self.forgroundColor = forgroundColor
    }
    
    public var body: some View {
        ZStack(alignment: .center) {

            self.content()
                .disabled(self.isShowing)
                .blur(radius: self.isShowing ? 3 : 0)

            VStack {
                Text(LocalizedStringKey(message))
                    .font(font)
                    .foregroundColor(forgroundColor)
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
            .frame(width: 120,height: 120)
            .background(Color.secondary.colorInvert())
            .foregroundColor(Color.primary)
            .cornerRadius(20)
            .opacity(self.isShowing ? 1 : 0)
            .colorScheme(.light)

        }
    }
}

@available(iOS 13.0, *)
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
