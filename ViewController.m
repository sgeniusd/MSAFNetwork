//
//  ViewController.m
//  MSAFNetwork
//
//  Created by bita on 15/8/18.
//  Copyright (c) 2015年 MagicSong. All rights reserved.
//

#import "ViewController.h"
#import "YCPTestHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testSendRequestClicked:(id)sender {
    YCPTestHandler *testHandler = [[YCPTestHandler alloc]initWithDelegate:self];
    [testHandler startRequestWithSuccess:^(YCPResponseModel *responseModel) {
        NSLog(@"success ### responseString = %@", responseModel.responseRawString);
    } failure:^(YCPResponseModel *responseModel) {
        NSLog(@"failed ### responseString = %@", responseModel.responseRawString);
    }];
}


@end
