//
//  PlotController.m
//
//  Created by Ray Wisman on Aug 9, 2011.
//

#import "PlotController.h"

@implementation PlotController

@synthesize startSlider, endSlider;
@synthesize data;
@synthesize notificationCenter;
@synthesize xData;
@synthesize yData;
@synthesize start, end, sizeChanged;

CPXYPlotSpace *plotSpace;
NSNumberFormatter *numberFormatter;

#pragma mark -
#pragma mark Initialization and teardown

- (BOOL)shouldAutorotateToInterfaceOrientation:
	(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Low memory warning." 
													message:@"Email recorded data and exit." 
												   delegate:nil 
										  cancelButtonTitle:@"Continue"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[super didReceiveMemoryWarning];	
	
}

-(void)dealloc 
{
	[graph release];
	[numberFormatter release];
    [super dealloc];
}

-(IBAction) endSizeSliderAction: (id) sender {
	UISlider *slider = (UISlider *) sender;
	sizeChanged = YES;
	end = self.data.endIndex * slider.value;
	if(end < start)
		end = start;
	[self updatePlot];
}

-(IBAction) startSizeSliderAction: (id) sender {
	UISlider *slider = (UISlider *) sender;
	sizeChanged = YES;
	start = self.data.endIndex * slider.value;
	if(start > end)
		start = end;
	[self updatePlot];
}

-(void) viewDidUnload {}

-(void)viewDidLoad {
    [super viewDidLoad];	
	
	self.data = nil;

	sizeChanged = NO;
	isViewVisible=YES;
    
	start = 0;					// Starting index of plot data
	end = 0;					// Ending index of plot data
	
    // Create graph from theme
    graph = [[CPXYGraph alloc] initWithFrame: CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPPlainWhiteTheme];
    [graph applyTheme:theme];	
	graph.plotAreaFrame.masksToBorder = YES;
    graph.paddingLeft = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingBottom = 30.0;

    CPLayerHostingView *hostingView = [[CPLayerHostingView alloc] initWithFrame: CGRectZero];
	hostingView.userInteractionEnabled = YES;
    hostingView.hostedLayer = graph;	
	[self.view addSubview:hostingView];
	[hostingView release];
	
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizingView" owner:self options:nil];
	UIView *sizingView = [nib objectAtIndex:0];
	sizingView.backgroundColor = [UIColor clearColor];
	
	sizingView.frame = self.view.bounds;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		graph.paddingBottom = 50.0;
		// Change slider thumb to clock image
		[endSlider setThumbImage:[UIImage imageNamed:@"clock-22x22.png"] forState:UIControlStateNormal];
		[startSlider setThumbImage:[UIImage imageNamed:@"clock-22x22.png"] forState:UIControlStateNormal];
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		graph.paddingBottom = 70.0;
		// Change slider thumb to clock image
//		iPad slider disappears when thumb image set 
//		[endSlider setThumbImage:[UIImage imageNamed:@"clock-32x32.png"] forState:UIControlStateNormal];
//		[startSlider setThumbImage:[UIImage imageNamed:@"clock-32x32.png"] forState:UIControlStateNormal];
	}
	
	[self.view addSubview: sizingView];
	
	
	// Root view rotated about the x-axis 180 degrees by Core-Plot for compatibility with Mac, un-rotate 180.
	self.view.transform = CGAffineTransformMakeScale(1,-1);	
	
	// Create a blue plot area
	CPScatterPlot *plot = [[CPScatterPlot alloc] init];
    plot.identifier = @"C";
	plot.dataLineStyle.miterLimit = 1.0f;
	plot.dataLineStyle.lineWidth = 2.0f;
	plot.dataLineStyle.lineColor = [CPColor blueColor];
    plot.dataSource = self;
	[graph addPlot:plot];
	[plot release];
	
	plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	
    numberFormatter = [[NSNumberFormatter alloc] init];	
	[numberFormatter setMaximumFractionDigits:2];
		
	self.notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self 
						   selector: @selector(updatePlot:) 
							   name: @"DATACHANGE" 
							 object: nil];
	
	[notificationCenter postNotificationName: @"DATAREQUEST" object: nil];		
}

- (void)viewDidAppear:(BOOL)animated {
	isViewVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	isViewVisible = NO;
}

-(void) updatePlot {	
	if(!isViewVisible) return;
	
	if(self.data == nil) return;			// Nothing to plot
	if( !sizeChanged ) {
		end = self.data.endIndex;
		start = self.data.startIndex;
	}
		
	float maxY=0.0, minY=0.0, minX=0.0, maxX=0.0;
	
	maxX = xData[end];
	minX = xData[start];
	maxY = yData[start];
	minY = yData[start];
	
	for(int i=start;i<=end; i=i+interval) {		
		if(yData[i] > maxY) maxY = yData[i];
		if(yData[i] < minY) minY = yData[i];
	}
	
	
	float ylength=maxY-minY+(maxY-minY)/3.0;
	float ylocation=minY-(maxY-minY)/5.0;
	
	float xlength=maxX-minX+(maxX-minX)/8.0;
	float xlocation=minX-(maxX-minX)/8.0;

	plotSpace.xRange = [CPPlotRange 
						plotRangeWithLocation:CPDecimalFromFloat(xlocation) 
						length:CPDecimalFromFloat(xlength)];
	
 	plotSpace.yRange = [CPPlotRange 
						plotRangeWithLocation:CPDecimalFromFloat(ylocation) 
						length:CPDecimalFromFloat(ylength)];
	
	// Grid line styles
    CPLineStyle *majorGridLineStyle = [CPLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.25];
    
    CPLineStyle *minorGridLineStyle = [CPLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPColor blackColor] colorWithAlphaComponent:0.1]; 
	
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *xAxis = axisSet.xAxis;
    xAxis.majorIntervalLength = CPDecimalFromFloat((maxX-minX)/4.0);
	xAxis.orthogonalCoordinateDecimal = CPDecimalFromFloat(minY-(maxY-minY)/30.0);
    xAxis.minorTicksPerInterval = 4;
	xAxis.title = @"Time";
    xAxis.majorGridLineStyle = majorGridLineStyle;
    xAxis.minorGridLineStyle = minorGridLineStyle;
	xAxis.isFloatingAxis=NO;
	xAxis.tickDirection = CPSignNegative;
	
	CPXYAxis *yAxis = axisSet.yAxis;
    yAxis.majorIntervalLength = CPDecimalFromFloat((maxY-minY)/3.0);
    yAxis.minorTicksPerInterval = 4;
    yAxis.orthogonalCoordinateDecimal = CPDecimalFromFloat(minX);
    yAxis.majorGridLineStyle = majorGridLineStyle;
    yAxis.minorGridLineStyle = minorGridLineStyle;
	yAxis.labelRotation = -M_PI/3.0;	
	yAxis.isFloatingAxis = NO;
	yAxis.tickDirection = CPSignNegative;
	yAxis.labelFormatter = numberFormatter;
	
	[graph reloadData];	
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
 	if(self.data == nil) return 0;			// Nothing to plot
	return (end-start)/interval+1;
}

-(NSNumber *)numberForPlot:(CPPlot *)cpPlot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{		
	index = index * interval;
		
	if(fieldEnum == CPScatterPlotFieldX)
		return [NSNumber numberWithFloat:self.xData[index+start]];
	return [NSNumber numberWithFloat: self.yData[index+start]];
}

@end
