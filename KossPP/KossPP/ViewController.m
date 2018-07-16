//
//  ViewController.m
//  KossPP
//
//  Created by 梅 on 2018/7/13.
//  Copyright © 2018年 mei. All rights reserved.
//

#import "ViewController.h"
#import "PPPersonModel.h"
#import "CAEmitter.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray <PPPersonModel *>*address_Arr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray <PPPersonModel *>*results_Arr;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor grayColor];
    _address_Arr = [NSMutableArray array];
    
    [self getContact];///获取通讯录权限
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    //检测通讯录权限
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
    }
    if(status == CNAuthorizationStatusDenied)//没有授权??
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"还不去打开通讯录权限!?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)getContact
{
    // 获取通讯录权限
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Authorized");
            [self openContact];
        }else{
            NSLog(@"Denied or Restricted");
        }
    }];
}
- (void)openContact
{
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
        [_address_Arr addObjectsFromArray:addressBookArray];///人员数据
        NSLog(@"通讯录总人数 = %ld",(unsigned long)_address_Arr.count);
        [self addTableView];///
    } authorizationFailure:^{
        NSLog(@"请在iPhone的“设置-隐私-通讯录”选项中，允许PP访问您的通讯录");
    }];
}
- (void)addTableView
{
    //动画背景
    CAEmitter *animaView = [[CAEmitter alloc]initWithFrame:self.view.bounds];
    animaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:animaView];
    
    
    //_searchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;//取消蒙版
    _results_Arr = [NSMutableArray arrayWithCapacity:0];//创建一个长度为零的可变数组
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, self.view.bounds.size.width, 40)];
    [searchView addSubview:_searchController.searchBar];//直接放在self.view顶部
//    [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"雪花"] forState:UIControlStateNormal];
//    [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"雪花"]];

    
    
    
    
    
    _searchController.searchBar.bounds = searchView.bounds;
    [self.view addSubview:searchView];
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 22+40, self.view.bounds.size.width, self.view.bounds.size.height-22-40) style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AddressCell"];
//    _tableView.tableHeaderView = _searchController.searchBar;
    _tableView.sectionHeaderHeight = 40;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_searchController.active)
    {
        return (unsigned long)_results_Arr.count;
    }else{
        return (unsigned long)_address_Arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddressCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击效果
    cell.backgroundColor = [UIColor clearColor];
    NSString *firstPhone;
    NSUInteger phoneAccount;
    if(_searchController.active)
    {
        cell.textLabel.text = _results_Arr[indexPath.row].name;
        firstPhone = _results_Arr[indexPath.row].mobileArray[0];
        phoneAccount = _results_Arr[indexPath.row].mobileArray.count;
    }else{
        cell.textLabel.text = _address_Arr[indexPath.row].name;
        firstPhone = _address_Arr[indexPath.row].mobileArray[0];
        phoneAccount = _address_Arr[indexPath.row].mobileArray.count;
    }
    if(phoneAccount>1)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@等%ld个号码",firstPhone,phoneAccount];
    }else{
        cell.detailTextLabel.text = firstPhone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger phoneAccount;
    if(_searchController.active)
    {
        phoneAccount = _results_Arr[indexPath.row].mobileArray.count;
    }else{
        phoneAccount = _address_Arr[indexPath.row].mobileArray.count;
    }
    NSLog(@"NSUInteger phoneAccount = %ld",phoneAccount);
    if(phoneAccount>1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择号码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        for(int i=0;i<phoneAccount;i++)
        {
            NSString *phoneStr = _searchController.active? _results_Arr[indexPath.row].mobileArray[i]:_address_Arr[indexPath.row].mobileArray[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:phoneStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *callStr = [NSString stringWithFormat:@"tel:%@",phoneStr];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
            }];
            [alert addAction:action];
       }
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        if(_searchController.active)
        {
            [_searchController presentViewController:alert animated:YES completion:nil];
        }else{
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        NSString *phone = _searchController.active?_results_Arr[indexPath.row].mobileArray[0]:_address_Arr[indexPath.row].mobileArray[0];
//        NSLog(@"点击-%@",_address_Arr[indexPath.row].mobileArray[0]);
        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"tel:%@",phone];
        UIWebView *callWebView = [[UIWebView alloc]init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
        [self.view addSubview:callWebView];
    }
}
#pragma mark
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if(_results_Arr.count>0)
    {
        [_results_Arr removeAllObjects];
    }
    NSString *inputStr = searchController.searchBar.text;//搜索框内容
    NSMutableArray *name_arr = [NSMutableArray array];
    for(int i=0;i<_address_Arr.count;i++)
    {
        [name_arr addObject:_address_Arr[i].name];
    }
    for(NSString *str in name_arr)
    {
        //lowercaseString小写
        if([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound)
        {
            for(PPPersonModel *model in _address_Arr)
            {
                if(model.name == str)
                {
                    //找到
                    [_results_Arr addObject:model];
                }
            }
        }
    }
    [_tableView reloadData];//刷新数据
}
@end
