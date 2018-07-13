//
//  ViewController.m
//  KossPP
//
//  Created by 梅 on 2018/7/13.
//  Copyright © 2018年 mei. All rights reserved.
//

#import "ViewController.h"
#import "PPPersonModel.h"
@interface ViewController ()

@property (nonatomic, strong)NSMutableArray *address_Arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
        _address_Arr = [NSMutableArray arrayWithArray:addressBookArray];
        for (PPPersonModel *model in addressBookArray) {
            NSLog(@"%@-%@",model.name,model.mobileArray);
        }
    } authorizationFailure:^{
        NSLog(@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录");
    }];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}





@end
