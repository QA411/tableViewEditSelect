//
//  ViewController.m
//  tableViewMSelect
//
//  Created by qq on 2017/5/2.
//  Copyright © 2017年 fangxian. All rights reserved.
//

#import "ViewController.h"
#import "KTCapListTableViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    KTCapListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KTCapListTableViewCell"];
    cell.tintColor = [UIColor redColor];//[UIColor colorWithHex:0xFA5042];

    cell.selectedBackgroundView = [[UIView alloc] init];
    
    cell.delButton.hidden = self.tableView.editing;
    
    cell.isClickDelBtnBlock = ^(UITableViewCell *currentCell){
        
        NSIndexPath* index=[self.tableView indexPathForCell:currentCell];
        NSLog(@"点击删除row=%ld",(long)index.row);
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否删除此节目" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [MBProgressHUD showMessage:@"正在删除" toView:self.view];
            
            
            
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:true completion: nil];
        
    };
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72;
}
//- ( CGFloat )tableView:( UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 362.f;
//    }
//    return 0.01f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (_headView) {
//        [_circleView loadDataArray:@[@{@"number":@"300",@"color":[UIColor colorWithHex:0xFFC63F],@"name":@"网购",@"numText":@"75%"},@{@"number":@"100",@"color":[UIColor colorWithHex:0x07D195],@"name":@"网购2"},@{@"number":@"200",@"color":[UIColor colorWithHex:0xF7F7F7],@"name":@"网购3"}] withType:MYHCircleManageViewTypeRound];
//    }
//    return self.headView;
//}


//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.deleteArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //    [self.deleteArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
}
#pragma mark --- 点击事件

//全选
- (IBAction)selectAllClick:(UIButton *)sender {
    
    if (self.tableView.editing) {
        
        for (int i = 0; i < 12; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            //        [self.deleteArr addObjectsFromArray:self.dataArray];
        }
    }
}

- (IBAction)clickOnEditButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        //支持同时选中多行
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        
    }else{

    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
