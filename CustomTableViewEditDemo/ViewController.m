//
//  ViewController.m
//  CustomEditTableViewDemo
//
//  Created by jamalping on 15/5/14.
//  Copyright (c) 2015年 jamal. All rights reserved.
//

#import "ViewController.h"
#import "CollectViewController.h"
#import "SystemEditViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pushAction:(id)sender {
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    UINavigationController *navig = [[UINavigationController alloc] initWithRootViewController:collectVC];
    [self presentViewController:navig animated:YES completion:nil];
    
}

//- (IBAction)presentSystemAction:(id)sender {
//    SystemEditViewController *systemEditVc = [[SystemEditViewController alloc] init];
//    UINavigationController *navig = [[UINavigationController alloc] initWithRootViewController:systemEditVc];
//    [self presentViewController:navig animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //    [segue initWithIdentifier:@"PresentSystem" source:<#(UIViewController *)#> destination:<#(UIViewController *)#>]
    
}

@end
