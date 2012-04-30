//**Current Version**
//  PaintViewController.h
//  Paint
//
//  Created by Egepi on 6/8/10.
//				and
//			   ShadowX
//
//  Copyright Electronic Visualization Laboratory 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>
//Imports necessary for network communication!
#import <CFNetwork/CFNetwork.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <netdb.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <unistd.h>
#import <errno.h>
#import <arpa/inet.h>

@interface PaintViewController : UIViewController 
{
	//Instance variables of Paint controller...
	
	//Stuff for networking...
	char dataToSend[20];
	char dataPiece1[4];
	char dataPiece2[4];
	char dataPiece3[4];
	char dataPiece4[4];
	char dataPiece5[4];
	int R,G,B,A,selectedTool;
	struct sockaddr_in mySocketAddr;
	struct hostent *host;
	int mySocket;
	bool connected;
	
	NSString *newAddress;
	
	
	bool fromMixingWell;
	int fromButtonID;
	int toButtonID;
	
	//Always holds the value for the current tool
	int currentTool;
	
	//Holds the current number of colors mixed
	int itemsMixed;
	bool colorSelected;
	
	//RGBA breakdown of the last Selected color
	CGFloat lastSelectedColor[4];
	
	//RGBA breakdown of the current Mix color
	CGFloat* mixingWellColorArray;
	
	//RGBA breakdown of a user created mixing well.
	CGFloat* userWellColorArray;
	
	//Interface Objects
	NSMutableArray *arrayOfColors;
	NSMutableArray *colorFunctions;
	
	//Mix values for user made wells.
	int well1mixed;
	int well2mixed;
	int well3mixed;
	bool fromUserWell1;
	bool fromUserWell2;
	bool fromUserWell3; 
	
	//New Buttons for Drag interface.
	UIImageView *ColorOne;
	UIImageView *ColorTwo;
	UIImageView *ColorThree;
	UIImageView *ColorFour;
	UIImageView *ColorFive;
	UIImageView *ColorSix;
	UIImageView *ColorSeven;
	UIImageView *ColorEight;
	UIImageView *ColorNine;
	UIImageView *ColorTen;
	UIImageView *ColorEleven;
	UIImageView *ColorTwelve;
	UIImageView *ColorThirteen;
	UIImageView *ColorFourteen;
	UIImageView *ColorFifteen;
	UIImageView *ColorSixteen;
	UIImageView *newMixingWell;
	UIImageView *userWell1;
	UIImageView *userWell2;
	UIImageView *userWell3;
	
	IBOutlet UIButton* brushButton;

	
	

	

}

@property (nonatomic, retain) IBOutlet UIImageView *ColorOne;
@property (nonatomic, retain) IBOutlet UIImageView *ColorTwo;
@property (nonatomic, retain) IBOutlet UIImageView *ColorThree;
@property (nonatomic, retain) IBOutlet UIImageView *ColorFour;
@property (nonatomic, retain) IBOutlet UIImageView *ColorFive;
@property (nonatomic, retain) IBOutlet UIImageView *ColorSix;
@property (nonatomic, retain) IBOutlet UIImageView *ColorSeven;
@property (nonatomic, retain) IBOutlet UIImageView *ColorEight;
@property (nonatomic, retain) IBOutlet UIImageView *ColorNine;
@property (nonatomic, retain) IBOutlet UIImageView *ColorTen;
@property (nonatomic, retain) IBOutlet UIImageView *ColorEleven;
@property (nonatomic, retain) IBOutlet UIImageView *ColorTwelve;
@property (nonatomic, retain) IBOutlet UIImageView *ColorThirteen;
@property (nonatomic, retain) IBOutlet UIImageView *ColorFourteen;
@property (nonatomic, retain) IBOutlet UIImageView *ColorFifteen;
@property (nonatomic, retain) IBOutlet UIImageView *ColorSixteen;
@property (nonatomic, retain) IBOutlet UIImageView *newMixingWell;
@property (nonatomic, retain) IBOutlet UIImageView *userWell1;
@property (nonatomic, retain) IBOutlet UIImageView *userWell2;
@property (nonatomic, retain) IBOutlet UIImageView *userWell3;

//New, attempting to add image highlight!
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

//Network handling functions
- (bool)connectToHost;
- (void)sendData;
- (bool)getConnected;
- (int)getSocket;
- (void)setConnectedOff;
- (void)grabAddress:(NSString *)addressToSet;

//Static color functions for making colors.
- (void)makeColorOne;
- (void)makeColorTwo;
- (void)makeColorThree;
- (void)makeColorFour;
- (void)makeColorFive;
- (void)makeColorSix;
- (void)makeColorSeven;
- (void)makeColorEight;
- (void)makeColorNine;
- (void)makeColorTen;
- (void)makeColorEleven;
- (void)makeColorTwelve;
- (void)makeColorThirteen;
- (void)makeColorFourteen;
- (void)makeColorFifteen;
- (void)makeColorSixteen;

//Functions to use the user created mixing wells.
- (void)makeColorUserWell1;
- (void)makeColorUserWell2;
- (void)makeColorUserWell3;

//Functions to add user made colors in the user mixing wells.
- (void)createUserWell1;
- (void)createUserWell2;
- (void)createUserWell3;

- (void)clearUserWells;

//Functions for mixing well and switching tools
- (void)newMix;
- (void)newClear;
- (IBAction)Brush:(id)sender;

//Functions for handling detailed touch events.
- (void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
- (void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
- (void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;


@end
