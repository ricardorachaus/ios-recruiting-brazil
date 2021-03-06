//
//  FiltersViewController.swift
//  Movs
//
//  Created by Ricardo Rachaus on 02/11/18.
//  Copyright © 2018 Ricardo Rachaus. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, FiltersDisplayLogic {
    
    /// Apply the filter to the movies.
    var filterApply: (([Movie]) -> ())?
    /// Send the active filters.
    var activeFilters: ((Filters.Option.Selected?,
                         Filters.Option.Selected?) -> ())?
    
    var interactor: FiltersBussinessLogic!
    var router: FiltersRoutingLogic!
    
    var dateFilter: Filters.Option.Selected?
    var genreFilter: Filters.Option.Selected?
    
    lazy var tableView: FiltersTableView = {
        let view = FiltersTableView(frame: .zero, style: .plain)
        view.register(FiltersTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    lazy var button: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Apply", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.Movs.lightYellow
        view.addTarget(self, action: #selector(pressedApply), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup Methods
    
    /**
     Setup the entire scene.
     */
    private func setup() {
        let viewController = self
        let interactor = FiltersInteractor()
        let presenter = FiltersPresenter()
        let router = FiltersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        setupViewController()
    }
    
    /**
     Setup view controller data.
     */
    private func setupViewController() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        title = "Filter"
        setupView()
    }
    
    // MARK: - ViewController Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.date.filter.text = dateFilter?.filterName
        tableView.genre.filter.text = genreFilter?.filterName
    }
    
    // MARK: - Filters Methods
    
    /**
     Filter a movie by selected filters.
     
     - parameters:
         - selected: Filter selected.
     */
    func filter(selected: Filters.Option.Selected) {
        if selected.type == .date {
            dateFilter = selected
            tableView.date.filter.text = selected.filterName
        } else {
            genreFilter = selected
            tableView.genre.filter.text = selected.filterName
        }
        tableView.reloadData()
    }
    
    /**
     When button is pressed apply filters.
     
     - parameters:
         - sender: Button pressed.
     */
    @objc func pressedApply(sender: UIButton) {
        let request = Filters.Request.Filters(dateFilter: dateFilter?.filterPredicate,
                                              genreFilter: genreFilter?.filterPredicate)
        interactor.applyFilters(request: request)
    }
    
    func applyFilter(viewModel: Filters.ViewModel) {
        filterApply?(viewModel.movies)
        activeFilters?(dateFilter, genreFilter)
        navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    }
    
    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
