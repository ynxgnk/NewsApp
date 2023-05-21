//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nazar Kopeyka on 10.04.2023.
//

import UIKit

class NewsTableViewCellViewModel { /* 60 */
    let title: String /* 61 */
    let subtitle: String /* 61 */
    let imageURL: URL? /* 61 */
    var imageData: Data? = nil /* 61 */
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) { /* 62 */
        self.title = title /* 63 */
        self.subtitle = subtitle /* 63 */
        self.imageURL = imageURL /* 63 */
    }
}

class NewsTableViewCell: UITableViewCell { /* 49 */
    static let identifier = "NewsTableViewCell" /* 50 */
    
    private let newsTitleLabel: UILabel = { /* 64 */
        let label = UILabel() /* 65 */
        label.numberOfLines = 0 /* 109 */
        label.font = .systemFont(ofSize: 22, weight: .semibold) /* 66 */
        return label /* 67 */
    }()
    
    private let subtitleLabel: UILabel = { /* 68 */
        let label = UILabel() /* 69 */
        label.numberOfLines = 0 /* 108 */
        label.font = .systemFont(ofSize: 17, weight: .light) /* 70 */
        return label /* 71 */
    }()
    
    private let newsImageView: UIImageView = { /* 72 */
        let imageView = UIImageView() /* 73 */
        imageView.layer.cornerRadius = 6 /* 131 */
        imageView.layer.masksToBounds = true /* 132 */
        imageView.clipsToBounds = true /* 118 */
        imageView.backgroundColor = .secondarySystemBackground /* 74 */ /* 119 change systemRed */
        imageView.contentMode = .scaleAspectFill /* 75 */
        return imageView /* 76 */
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { /* 51 */
        super.init(style: style, reuseIdentifier: reuseIdentifier) /* 52 */
        contentView.addSubview(newsTitleLabel) /* 77 */
        contentView.addSubview(subtitleLabel) /* 78 */
        contentView.addSubview(newsImageView) /* 79 */
    }
    
    required init?(coder: NSCoder) { /* 53 */
        fatalError() /* 54 */
    }
    
    override func layoutSubviews() { /* 55 */
        super.layoutSubviews() /* 56 */
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        ) /* 103 */
        
        subtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        ) /* 106 */
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width-150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        ) /* 107 */
    }
    
    override func prepareForReuse() { /* 57 */
        super.prepareForReuse() /* 58 */
        newsTitleLabel.text = nil /* 120 */
        subtitleLabel.text = nil /* 121 */
        newsImageView.image = nil /* 122 */
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) { /* 59 */
        newsTitleLabel.text = viewModel.title /* 80 */
        subtitleLabel.text = viewModel.subtitle /* 81 */
        
        //Image
        if let data = viewModel.imageData { /* 82 */
            newsImageView.image = UIImage(data: data) /* 83 */
        } else if let url = viewModel.imageURL { /* 82 */
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in /* 110 */ /* 115 add weak self */
                guard let data = data, error == nil else { /* 111 */
                    return /* 112 */
                }
                viewModel.imageData = data /* 117 */
                DispatchQueue.main.async { /* 113 */
                    self?.newsImageView.image = UIImage(data: data) /* 114 */
                }
            }.resume() /* 116 */
        }
    }
}
