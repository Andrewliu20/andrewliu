//
//  ViewController.m
//  图片加载优化
//
//  Created by 张超 on 16/9/6.
//  Copyright © 2016年 张超. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "Model.h"
#import "MJExtension.h"
#import "TableViewCell.h"


#define IDENF @"cell"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated {
   // [[SDImageCache sharedImageCache] clearDisk];
    
   // [[SDImageCache sharedImageCache] clearMemory];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self creatTableView];

}

- (void)getData {
    self.array = [NSMutableArray arrayWithCapacity:0];
    NSString *url  = @"http://knowhere.avosapps.com/Api/exhibition/recommend";
    [self getDataWithURL:url success:^(Model *result) {
        self.array = (NSMutableArray *)result.results;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:IDENF];
    
    
}

- (void)getDataWithURL:(NSString *)url success:(void (^)(Model *result))success failure:(void (^)(NSError *error))failure
{
    [AFNetworkTool getUrl:url body:nil response:ZCJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
         if (success) {
        Model *result = [Model objectWithKeyValues:resposeObject];
             success(result);
         }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }

    }];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  //  TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENF];
    TableViewCell *cell  =[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENF];
    }
    else
    {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }


    [cell.image sd_setImageWithURL:[NSURL URLWithString:[_array[indexPath.row] coverUrl].url ] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

       SDWebImageManager *manager = [SDWebImageManager sharedManager];
       
        
        
        if ([manager diskImageExistsForURL:[NSURL URLWithString:[_array[indexPath.row] coverUrl].url ]]) {
            NSLog(@"不加载动画");
        }else {

               cell.image.alpha = 0.0;
        [UIView transitionWithView:cell.image
                          duration:1.0
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [cell.image setImage:image];
                            cell.image.alpha = 1.0;
                        } completion:NULL];
        
        }
        
        
    }];
    cell.userInteractionEnabled = NO;
    
    
    return  cell;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
