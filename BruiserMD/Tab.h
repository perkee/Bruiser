//
//  Tab.h
//  BruiserMD
//
//  Created by perkee on 3/17/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabDelegate.h"
#import "DetailViewDelegate.h"

@interface Tab : NSObject <DetailViewDelegate>
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSMutableSet *delegates;

-(id) initWithDelegate:(id<TabDelegate>)delegate;
-(id) initWithDelegate:(id<TabDelegate>)delegate withURLString:(NSString *)urlString;
-(id) initWithDelegate:(id<TabDelegate>)delegate withURL:(NSURL *)url;
-(void) addDelegate:(id<TabDelegate>)delegate;
-(NSString *)urlString;
-(void)setUrlString:(NSString *)string;
@end
