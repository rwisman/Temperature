#import "CorePlot-CocoaTouch.h"
#import "Data.h"

#define numberDataPointstoPlot	250
#define interval	(int)((end-start) / numberDataPointstoPlot + 1)		

@interface PlotController : UIViewController <CPPlotDataSource>
{
	CPXYGraph *graph;
	
	float *yData, *xData;
	
	int start, end;
	
	IBOutlet UISlider *startSlider, *endSlider;

	Data *data;
	
	NSNotificationCenter *notificationCenter;
	
	Boolean sizeChanged, plotData;

	BOOL isViewVisible;
}

@property (nonatomic, assign) IBOutlet UISlider *startSlider;
@property (nonatomic, assign) IBOutlet UISlider *endSlider;
@property(readwrite, nonatomic) float *xData;
@property(readwrite, nonatomic) float *yData;
@property(readwrite, nonatomic) int start;
@property(readwrite, nonatomic) int end;
@property(readwrite, nonatomic) Boolean sizeChanged;

@property(readwrite, assign, nonatomic) NSNotificationCenter *notificationCenter;
@property(readwrite, assign, nonatomic) Data *data;

-(IBAction) endSizeSliderAction: (id) sender;
-(IBAction) startSizeSliderAction: (id) sender;
-(IBAction) startSizeSliderAction: (id) sender;
-(void) updatePlot;

@end
