//
//  MovieDetailViewController.swift
//  Movs
//
//  Created by Ricardo Rachaus on 28/10/18.
//  Copyright © 2018 Ricardo Rachaus. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailDisplayLogic {
    
    var movie: Movie?
    
    var interactor: MovieDetailBussinessLogic!
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    lazy var tableView: MovieDetailTableView = {
        let view = MovieDetailTableView(frame: .zero, style: .grouped)
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.text = "sahudhsaudhaudh.auhsaudhasudhauhduahdaudhasu"
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        setupViewController()
    }
    
    private func setupViewController() {
        let view = UIView(frame: .zero)
        self.view = view
        title = "Movie"
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMovie()
    }
    
    func fetchMovie() {
        if let movie = movie {
            let request = MovieDetail.Request(movie: movie)
            interactor.fetchMovie(request: request)
        }
    }
    
    func display(viewModel: MovieDetail.ViewModel) {
        
    }
    
}

extension MovieDetailViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.addSubview(textView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(85)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
}