//
//  HomeTabBar.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import Foundation

import UIKit
class HomeTabBar : UITabBarController
{
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        let viewController1 = UINavigationController(rootViewController: DashBoardViewController())
        let viewController2 =  UINavigationController(rootViewController:HealthDataViewController())
        let viewController3 = UINavigationController(rootViewController: ActivityTrackerViewController())
        let viewController4 =  UINavigationController(rootViewController:UserProfileViewController())
        self.viewControllers = [viewController1, viewController2, viewController3, viewController4]
        
        viewController1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "TabitemDiscover_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "TabitemDiscover_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        viewController2.tabBarItem = UITabBarItem(title: "Health", image: UIImage(named: "TabitemPlaylist_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "TabitemPlaylist_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        viewController3.tabBarItem = UITabBarItem(title: "Activity Tracker", image: UIImage(named: "TabitemPlaylist_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "TabitemPlaylist_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        viewController4.tabBarItem = UITabBarItem(title: "Pofile", image: UIImage(named: "TabitemLibrary_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "TabitemLibrary_Unselected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        
        
    }
    //    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    //        print("Tab item tapped again: \(item.title ?? "")")
    //        if(item.title  == "Artist"){
    //            SongOrderFlowManager.selectedFlow = .ArtistAlreadySelected
    //        }
    //
    //    }
    
}
