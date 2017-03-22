//
//  AFNetworkTool.h
//  TextA
//
//  Created by 张超 on 15/11/6.
//  Copyright © 2015年 张超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResposeStyle) {
    ZCJSON,
    ZCXML,
    ZCData,};
typedef NS_ENUM(NSUInteger, QCRequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault
};

@interface AFNetworkTool : NSObject

+ (void)getUrl:(NSString *)
      url body:(id)body
      response:(ResposeStyle)style
requestHeadFile:(NSDictionary *)headFile
       success:(void (^)(NSURLSessionDataTask* task, id resposeObject))success
       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


+ (void)postUrlString:(NSString *)url
                 body:(id)body
             response:(ResposeStyle)style
            bodyStyle:(QCRequestStyle)bodyStyle
      requestHeadFile:(NSDictionary *)headFile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
