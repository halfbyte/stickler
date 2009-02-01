//
//  AppController.h
//  Stickler
//
//  Created by Jan Krutisch on 01.02.09.
//  Copyright 2009 mindmatters GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMSerialPort.h"

@interface AppController : NSObject {
	IBOutlet NSTextField *operatorName;
	IBOutlet NSLevelIndicator *signalStrength;
	AMSerialPort *port;
}

- (AMSerialPort *)port;
- (void)initPort;
- (void)setPort:(AMSerialPort *)newPort;

@end
