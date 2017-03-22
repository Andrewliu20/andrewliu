//
//  Model.h
//  图片加载优化
//
//  Created by 张超 on 16/9/7.
//  Copyright © 2016年 张超. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Result,CoverImageUrl;
@interface Model : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray< Result* > *results;
@end

@interface Result : NSObject
@property (nonatomic, strong) CoverImageUrl *coverUrl;
@property (nonatomic, copy) NSString *nameBase;
@end

@interface CoverImageUrl : NSObject
@property (nonatomic, copy) NSString *url;
@end

