// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
public enum HueButton{
    public struct Back: View{
        public var action:(()->())
        
        public init(action: (@escaping () -> Void)) {
            self.action = action
        }
        public var body: some View{
            Button{
                action()
            }label: {
                Image(.back).resizable().frame(width: 48,height: 48)
            }
        }
    }
    
    public struct Close: View{
        public var action:(()->())
        
        public init(action: (@escaping () -> Void)) {
            self.action = action
        }
        public var body: some View{
            Button{
                action()
            }label: {
                Image(.delete).resizable().frame(width: 48,height: 48)
            }
        }
    }
    
    public struct Heart: View{
        @Binding var isLike:Bool
        var action:((Bool)->())?
        public init(isLike: Binding<Bool>, action: ( (Bool) -> Void)? = nil) {
            self._isLike = isLike
            self.action = action
        }
        public var body: some View{
            Button{
                isLike.toggle()
                action?(isLike)
            }label: {
                Image(isLike ? .like : .unlike ).resizable().frame(width: 48,height: 48)
            }
        }
    }
    public struct Minus:View {
        var action:(()->())
        var isActive:Bool
        public init(isActive:Bool,action: @escaping ( () -> Void)) {
            self.action = action
            self.isActive = isActive
        }
        public var body: some View {
            ActivatableButton(isActive: isActive, active: .activeMinus, inActive: .inactiveMinus, action: action)
        }
    }
    public struct Plus:View {
        var action:(()->())
        var isActive:Bool
        public init(isActive:Bool, action: @escaping () -> Void) {
            self.action = action
            self.isActive = isActive
        }
        public var body: some View {
            ActivatableButton(isActive: isActive, active: .activePlus, inActive: .inactiveplus, action: action)
        }
    }
    public struct Setting:View {
        var action:(()->())
        public init(action: @escaping () -> Void) {
            self.action = action
        }
        public var body: some View {
            Button(action: {
                action()
            }, label: {
                Image(.settings).resizable().frame(width: 48,height: 48)
            })
        }
    }
    public struct Next: View {
        var action:()->()
        public init(action: @escaping () -> Void) {
            self.action = action
        }
        public var body: some View {
            Button{
            }label: {
                HueConfirmLabel(text:"Next",activeGradient: false)
            }.hueBtnStyle {
                action()
            }
        }
    }
    public struct Start:View{
        var action:()->()
        var isActive:Bool
        var text:String
        public init(text: String = "Let's get started",isActive:Bool = false,action: @escaping () -> Void) {
            self.isActive = isActive
            self.text = text
            self.action = action
        }
        public var body: some View{
            Button(action: {
            }, label: {
                HStack{
                    Text(text)
                        .font(.montserrat(size: 20))
                        .foregroundStyle(.white.opacity(isActive ? 1 : 0.7))
                    Spacer()
                    Image(.started).resizable().frame(width: 20,height: 20)
                }
                .padding(.vertical,22)
                .padding(.leading,24)
                .padding(.trailing,16)
                .pressBorder()
                .background(.regularMaterial.opacity(isActive ? 0.2 : 0.0))
                .preferredColorScheme(.light)
                .clipShape(Capsule())
            }).hueBtnStyle{
                action()
            }
        }
    }
    public struct ConfirmBtn: View {
        var action:()->()
        var isActive:Bool
        var imageResource: ImageResource?
        var text:String
        public init(text:String,image:ImageResource? = nil,isActive:Bool = false,action: @escaping () -> Void) {
            self.text = text
            self.isActive = isActive
            self.action = action
            self.imageResource = image
        }
        public var body: some View{
            Button(action: {
            }, label: {
                HueConfirmLabel(text:text,activeGradient: isActive,imageResource: imageResource)
            }).hueBtnStyle{
                action()
            }
        }
    }
    public struct Finish:View{
        var action:()->()
        public init(action: @escaping () -> Void) {
            self.action = action
        }
        public var body: some View{
            Button{ }label: {
                HueConfirmLabel(text: "Finish", activeGradient: false)
            }.hueBtnStyle {
                action()
            }
        }
    }
    public struct Unlock:View {
        var action:(()->())?
        public init(action: (()->())? = nil) {
            self.action = action
        }
        public var body: some View {
            Button{}label:{
                HStack{
                    Text("Premium Unlock")
                        .font(.montserrat(size: 20))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(.unlock).resizable().frame(width: 24,height: 24)
                }
                .padding(.top,18)
                .padding(.bottom,20)
                .padding(.leading,22)
                .padding(.trailing,25)
                .isActiveGradient(true)
                .background(.regularMaterial.opacity(0.2))
                .preferredColorScheme(.light)
                
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }.hueBtnStyle{
                action?()
            }
        }
    }
    public struct ListCell:View{
        var action: ()->()
        var text:String
        var desc:String
        public init(text:String,desc:String,action: @escaping () -> Void) {
            self.text = text
            self.desc = desc
            self.action = action
        }
        public var body: some View{
            Button{ }label: {
                HStack{
                    VStack(alignment:.leading,spacing: 8){
                        Text(text).font(.pretendard(weight: .medium, size: 16))
                        Text(desc).font(.pretendard(weight: .medium, size: 14)).foregroundStyle(Color(hex: "#FFFFFF").opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 25))
                }.foregroundStyle(.white).frame(height: 44).padding(.vertical,26)
            }.hueBtnStyle {
                action()
            }
        }
    }
}
fileprivate struct ActivatableButton: View{
    var action:(()->())
    var isActive:Bool
    var activeResource: ImageResource
    var inActiveResource: ImageResource
    public init(isActive:Bool,active:ImageResource,inActive:ImageResource,action: @escaping ( () -> Void)) {
        self.activeResource = active
        self.inActiveResource = inActive
        self.action = action
        self.isActive = isActive
    }
    public var body: some View {
        if isActive{
            Button(action: action , label: {
                Image(activeResource).resizable().frame(width: 60,height: 60)
            })
        }else{
            Image(inActiveResource).resizable().frame(width: 60,height: 60)
        }
    }
}

public extension Button{
    public func hueBtnStyle(action:(()->())? = nil,actionDuration:Double = 0.125) -> some View{
        self.buttonStyle(HueBtnStyle(action: action,actionDuration: actionDuration))
    }
}
struct HueBtnStyle:ButtonStyle{
    var action:(()->())?
    var actionDuration:Double = 0.125
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.95 : 1).animation(.smooth(duration: actionDuration), value: configuration.isPressed).onChange(of: configuration.isPressed) { oldValue, newValue in
            if oldValue && !newValue{
                Task{
                    try await Task.sleep(for: .seconds(actionDuration))
                    await MainActor.run {
                        action?()
                    }
                }
            }
        }
    }
}
#Preview(body: {
    HueButton.ListCell(text: "Spatial Audio Setting", desc: "Position of audio on both sides can be adjusted") {
        print("Hello world")
    }.background(.blue).padding(.horizontal)
})
