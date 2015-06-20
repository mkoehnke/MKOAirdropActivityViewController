//
//  ViewController.m
//  MKOAirdropActivityViewControllerSample
//
//  Created by Mathias Köhnke on 20/06/15.
//  Copyright (c) 2015 Mathias Koehnke. All rights reserved.
//

#import "ViewController.h"
#import "MKOAirdropActivityViewController.h"

@implementation ViewController

- (IBAction)showAirDrop {
    UIImage *image = [UIImage imageNamed:@"octocat"];
    MKOAirdropActivityViewController *vc = [[MKOAirdropActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
