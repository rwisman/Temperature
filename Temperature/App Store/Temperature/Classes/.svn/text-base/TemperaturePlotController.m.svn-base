#import "TemperaturePlotController.h"

@implementation TemperaturePlotController

-(void) updatePlot: (NSNotification *) notification { 
	
	self.data = (Data *)[ notification object ];
	self.xData = data.dataX;
	self.yData = data.dataY;
	
	sizeChanged = NO;
	[self updatePlot ];
}

@end
