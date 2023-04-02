//
//  ViewModel.swift
//  MVVM-HARA
//
//  Created by saint on 2023/03/31.
//

import Foundation
import Combine

// 뷰 모델로써 데이터의 상태를 가지고 있음
class WorryVM: ObservableObject{
    
    @Published var worryList: [WorryListModel] = [
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "해라 릴리즈", startDate: "23.02.01", endDate: "23.02.02"),
        WorryListModel(templateId: 2, templateTitle: "학업", title: "이번 학기 학점", startDate: "23.02.02", endDate: "23.02.04"),
        WorryListModel(templateId: 3, templateTitle: "일상", title: "집에 갈까 말까", startDate: "23.02.03", endDate: "23.02.06"),
        WorryListModel(templateId: 2, templateTitle: "학업", title: "수업 드랍할까 말까?", startDate: "23.02.04", endDate: "23.03.08"),
        WorryListModel(templateId: 4, templateTitle: "진로", title: "머 해먹고 살지,,?", startDate: "23.02.05", endDate: "23.04.10"),
        WorryListModel(templateId: 3, templateTitle: "일상", title: "저녁 뭐먹을까?", startDate: "23.03.03", endDate: "23.04.06"),
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "컴시이실 공부하기", startDate: "23.03.31", endDate: "23.04.20"),
        WorryListModel(templateId: 1, templateTitle: "할 일", title: "데이터 엔지니어링 API", startDate: "23.03.31", endDate: "23.04.20")
    ]
    
    @Published var templateList: [TemplateListModel] = [
        TemplateListModel(templateId: 0, templateTitle: "전체", templateDetail: "전체 고민을 모두 보여줍니다."),
        TemplateListModel(templateId: 1, templateTitle: "할 일", templateDetail: "할 일을 정하는 데 사용할 템플릿입니다."),
        TemplateListModel(templateId: 2, templateTitle: "학업", templateDetail: "학업에 관한 고민을 저장하기 위한 템플릿입니다."),
        TemplateListModel(templateId: 3, templateTitle: "일상", templateDetail: "일상에서의 고민을 저장하기 위한 템플릿입니다."),
        TemplateListModel(templateId: 4, templateTitle: "진로", templateDetail: "앞으로의 진로에 대한 고민을 저장하기 위한 템플릿입니다."),
        TemplateListModel(templateId: 5, templateTitle: "연애", templateDetail: "연애에 대한 고민을 저장하기 위한 템플릿입니다."),
        TemplateListModel(templateId: 6, templateTitle: "건강", templateDetail: "건강 대한 고민을 저장하기 위한 템플릿입니다.")
    ]
    
    init(){
        print("ViewModel - init()")
    }
}
