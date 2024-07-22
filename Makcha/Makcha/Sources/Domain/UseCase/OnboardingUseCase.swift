//
//  OnboardingUseCase.swift
//  Makcha
//
//  Created by yuncoffee on 7/22/24.
//

import Foundation

final class OnboardingUseCase {
    private let transPathRepository: TransPathRepositoryProtocol
    private let endPointRepository: EndPointRepositoryProtocol
    
    init(_ transPathRepository: TransPathRepositoryProtocol, _ endPointRepository: EndPointRepositoryProtocol) {
        self.transPathRepository = transPathRepository
        self.endPointRepository = endPointRepository
    }
}
