//
//  OnboardVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class OnboardVC: BaseVC<OnboardVM, OnboardView> {
    
    private var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var pages = OnboardPages.allCases
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageController()
    }
    
    private func setupPageController() {
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.pageController.view.backgroundColor = .clear
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.view.edgesToSuperview()
        let initialVC = OnboardPageVC(with: pages[0])
        self.pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController.didMove(toParent: self)
    }
}

extension OnboardVC: OnboardVMOutputProtocol {
    
}

extension OnboardVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnboardPageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc = OnboardPageVC(with: pages[index])
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnboardPageVC else {
            return nil
        }
        
        var index = currentVC.page.index
        
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc = OnboardPageVC(with: pages[index])
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
