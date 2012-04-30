//
//  PaintAppDelegate.h
//  Paint
//
//  Created by Egepi on 6/8/10.
//				and
//			   ShadowX
//
//  Copyright Electronic Visualization Laboratory 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PaintViewController;

@interface PaintAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	PaintViewController *myViewController;
	char message[20]; //= "999 999 999 999 999";
	int sameSocket;
	}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PaintViewController *myViewController;

@end
