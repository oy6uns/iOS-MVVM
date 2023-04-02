//
//  WorryCVC.swift
//  MVVM-HARA
//
//  Created by saint on 2023/04/01.
//

import UIKit
import SnapKit
import Then

class WorryCVC: UICollectionViewCell {
    
    private let worryCell = UIView().then{
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    private let jewelImage = UIImageView().then{
        $0.image = UIImage(named: "jewel")
        $0.backgroundColor = .clear
    }
    
    private let worryTitle = UILabel().then{
        $0.text = "고민 제목입니당"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
    }

    private let worryDate = UILabel().then{
        $0.text = "2023.02.10~2023.04.01"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorryCVC{
    
    // MARK: - Layout
    private func setLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(worryCell)
        
        worryCell.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
//        worryCell.snp.makeConstraints{
//            $0.width.equalTo(164.adjustedW)
//            $0.height.equalTo(164)
//        }
        
        worryCell.addSubviews([jewelImage, worryTitle, worryDate])
        
        jewelImage.snp.makeConstraints{
            $0.width.height.equalTo(30.adjustedW)
            $0.leading.equalTo(12.adjustedW)
            $0.top.equalTo(12.adjustedW)
        }
        
        worryTitle.snp.makeConstraints{
            $0.leading.equalTo(14.adjustedW)
            $0.top.equalTo(jewelImage.snp.bottom).offset(64.adjustedW)
        }
        
        worryDate.snp.makeConstraints{
            $0.leading.equalTo(14.adjustedW)
            $0.top.equalTo(worryTitle.snp.bottom).offset(7.adjustedW)
        }
    }
    
    func dataBind(model: WorryListModel) {
        worryTitle.text = model.title
        worryDate.text = model.startDate + "~" + model.endDate
    }
}
