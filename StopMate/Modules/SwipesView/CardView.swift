//
//  CardView.swift
//  StopMate
//
//  Created by Саша Василенко on 07.05.2024.
//

import SwiftUI
import Combine

struct CardView<ViewModel>: View where ViewModel: CardViewVMProtocol {
    
    @ObservedObject var vm: ViewModel
//    private var pic: Data?
    @Binding var isShowingContent: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading) {
//                    NukeUIImageView(path: store.movie?.posterPath, contentMode: .fill, cornerRadius: .zero)
//                        .clipShape(.rect(topLeadingRadius: CGFloat.constant25, bottomLeadingRadius: .zero, bottomTrailingRadius: .zero, topTrailingRadius: CGFloat.constant25))
                    
                    
                    CardImagePic(data: vm.data)
                        .frame(width: 350, height: 450)
                    
                    VStack(alignment: .leading) {
                        Text(vm.user.hourRate + "$/год")
                            .font(.headline)
                            .fontWeight(.light)
                            
                        
                        Text(vm.user.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(isShowingContent ? nil : 1)
                            .padding(.bottom)
                        
                        if isShowingContent {
                            Text(vm.user.expirience)
                                .font(.title2)
                                .transition(.move(edge: .bottom))
                        }
                    }.padding([.horizontal, .bottom], Spacings.spacing20)
                }
                .background(.thinMaterial)
                .cornerRadius(Spacings.spacing25)
            }.environment(\.isScrollEnabled, isShowingContent)
            
            
            if isShowingContent {
                Button {
                    withAnimation(.easeInOut) {
                        self.isShowingContent = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color.white)
                        .opacity(0.7)
                }
                .padding([.top, .leading])
            }
        }
    }
    
//    private mutating func getPic() {
//        let storage = FirebaseStorageService()
////        var pic: Data?
//        storage.getUserPicForUser(id: data.id) { result in
//            pic = result
//            
//        }
//    }
//    
//    private func setPic() -> CardImagePic {
//        getPic()
//        CardImagePic(data: pic)
//
//    }
}

//#Preview {
//    CardView(vm: .init(name: "Sasha", age: "24", id: "afsdlkfaldsfjls", expirience: "dslfakjldksjjfdfjlkfafhdljfhdsakjfhdkjfhdaskfjhfalkjfhdsalkfj haskjdfhlskjfhdslkfjhasfklj alfkjadshf kjhakjf hjkalfhdskfljfhdljf hadskfajkfhadslfjdshfj hlfi h;eifhsdjfkhads flka fhjas hfldsjkfh dskjfhdsakjfhlask fjalfhsfh ew i fweirutrwoigretio;faidkac.vcxmn jf djkfsdj fasdjf dcxjdjfhds fdlifha;f ie ;ofiew ioreusadjkfhfkjhasdkjfhdslkgfhsf;fgirstwroeriuse;f oidsuflkds;cffj;nweiofcns;foadscia;csdanflka dsjfask", hourRate: "dfjsajkdshfajkf", jobCaterory: .iOS), isShowingContent: .constant(true))
//}
