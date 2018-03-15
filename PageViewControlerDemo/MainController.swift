//
//  MainController.swift
//  PageViewControlerDemo
//
//  Created by min-mac on 16/3/12.
//  Copyright © 2016年 EgeTart. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet var sliderView: UIView!
    
    var movieController: MovieController!
    var musicController: MusicController!
    var bookController: BookController!
    var controllers = [UIViewController]()
    
    var sliderImageView: UIImageView!
    
    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            //根据当前页面计算得到便宜量
            //一个微小的动画移动提示条
            let offset = self.view.frame.width / 3.0 * CGFloat(currentPage)
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: offset, y: -1)
            }
            
            //根据currentPage 和 lastPage的大小关系，控制页面的切换方向
            if currentPage > lastPage {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取到嵌入的UIPageViewController
        pageViewController = self.childViewControllers.first as! UIPageViewController
        
        //根据Storyboard ID来创建一个View Controller
        movieController = storyboard?.instantiateViewController(withIdentifier: "MovieControllerID") as! MovieController
        musicController = storyboard?.instantiateViewController(withIdentifier: "MusicControllerID") as! MusicController
        bookController = storyboard?.instantiateViewController(withIdentifier: "BookControllerID") as! BookController
        
        //设置pageViewController的数据源代理为当前Controller
        pageViewController.dataSource = self
        
        //手动为pageViewController提供提一个页面
        pageViewController.setViewControllers([movieController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        //添加提示条到页面中
        sliderImageView = UIImageView(frame: CGRect(x: 0, y: -1, width: self.view.frame.width / 3.0, height: 3.0))
        sliderImageView.image = UIImage(named: "slider")
        sliderView.addSubview(sliderImageView)
        
        //把页面添加到数组中
        controllers.append(movieController)
        controllers.append(musicController)
        controllers.append(bookController)
        
        //接收页面改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(MainController.currentPageChanged(notification:)), name: Notification.Name(rawValue: "currentPageChanged"), object: nil)
    }
    
    @IBAction func changeCurrentPage(_ sender: UIButton) {
        //button的tag分别为100，101，102，减去100之后就对应页面的索引
        currentPage = sender.tag - 100
    }
    
    
    //通知响应方法
    @objc func currentPageChanged(notification: Notification) {
        currentPage = notification.object as! Int
    }
}

extension MainController: UIPageViewControllerDataSource {
    
    //返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: MovieController.self) {
            return musicController
        }
        else if viewController.isKind(of: MusicController.self) {
            return bookController
        }
        return nil
    }
    
    //返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: MusicController.self) {
            return movieController
        }
        else if viewController.isKind(of: BookController.self) {
            return musicController
        }
        return nil
    }
}

