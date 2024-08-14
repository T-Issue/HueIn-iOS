//
//  File.swift
//  
//
//  Created by Greem on 7/27/24.
//

import SwiftUI

public struct HueSlider<T,U:View>: View {
    @Binding var items:[T]
    let spacing:CGFloat
    let itemWidth:CGFloat
    let sliderHeight:CGFloat
    let paddingLeading:CGFloat
    @ViewBuilder var mainView: (T,Int) -> U
    public init(items: Binding<[T]>, spacing: CGFloat, itemWidth: CGFloat, sliderHeight: CGFloat, paddingLeading: CGFloat, mainView: @escaping (T,Int) -> U) {
        self._items = items
        self.spacing = spacing
        self.itemWidth = itemWidth
        self.sliderHeight = sliderHeight
        self.paddingLeading = paddingLeading
        self.mainView = mainView
    }
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing:spacing,content: {
                ForEach(items.indices, id:\.self){ idx in
                    mainView(items[idx],idx)
                }
            }).padding(.bottom,30)
            .scrollTargetLayout()
            .overlay(alignment:.bottom) {
                PagingIndicator(spacing: spacing,itemWidth: itemWidth,itemCnt: items.count
                                ,paddingLeading: paddingLeading)
            }.padding(.horizontal,paddingLeading)
        }.frame(height: sliderHeight + 30).scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.leading,paddingLeading)
    }
}
struct PagingIndicator:View {
    var activeTint:Color = .white
    var inActiveTint:Material = Material.thinMaterial
    var spacing:CGFloat = 14
    var itemWidth:CGFloat = 230
    var itemCnt = 5
    var paddingLeading:CGFloat = 0
    var body: some View {
        GeometryReader(content: {
            let width = $0.size.width
            if let scrollViewWidth = $0.bounds(of: .scrollView(axis: .horizontal))?.width,
               scrollViewWidth > 0{
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                let totalPages = itemCnt
                
                // 현재까지 이동한 스크롤 뷰 너비(화면에 안보이는 왼쪽 너비) / 전체 스크롤 뷰 너비
                let freeProgress = min(-(minX - paddingLeading) / (itemWidth + spacing),width)
                // 배경을 잘랐으면 최대-최소 지정 Progress, 아니면 그냥 Progress
                let progress = freeProgress
                
                /// Indexed
                let activeIndex = Int(-minX + scrollViewWidth > width ? CGFloat(totalPages - 1) : progress)
                let nextIndex = Int(progress.rounded(.awayFromZero)) // 소수점이 0.0보다 크면 무조건 올림
                let indicatorProgress = progress - CGFloat(activeIndex)
                
                let currentPageWidth = max(0,18 - (indicatorProgress * 18))
                let nextPageWidth = max(0,indicatorProgress * (5+5+8)) // HStack의 spacing을 10으로 설정함
                VStack{
                    HStack(spacing:10,content: {
                        ForEach(0..<totalPages,id:\.self){ index in
                            
                            Circle()
                                .fill(inActiveTint)
                                .frame(width: 8 + (activeIndex == index ? currentPageWidth : nextIndex == index ? nextPageWidth : 0),height: 8)
                                .overlay {
                                    ZStack {
                                        Capsule().fill(inActiveTint)
                                        Capsule().fill(activeTint)
                                            .opacity(activeIndex == index ? 1 - indicatorProgress : nextIndex == index ? indicatorProgress : 0)
                                    }
                                }
                        }
                    })
                    .frame(width: scrollViewWidth,height:8)
                }
                .offset(x:-minX)
            }
        }).frame(height: 15)
    }
}
