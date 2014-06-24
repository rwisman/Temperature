//
//  Created by Ray Wisman on Aug 8, 2011.
//

// % change/sample in low-pass filter

const double ALPHA = 0.1;

// dB to Celsius conversion equation with calibration correction factor

#define temperatureCelsius (3.3965*lowPassResults + 145.49) + calibrationCorrection

// Frequency of sine wave generated and output to audio

#define sineFrequency 199.0

#define timeInterval ALPHA

#define samplingRate 2000.0

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Data.h"
#import "MeterView.h"
#include "BleepMachine.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPVolumeView.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>

@interface TemperatureViewController  : UIViewController <MFMailComposeViewControllerDelegate, AVAudioSessionDelegate> {
	IBOutlet UILabel *sampleRateLabel;
	IBOutlet UIButton *sendButton;
	IBOutlet UIButton *hotterButton;
	IBOutlet UIButton *coolerButton;
	IBOutlet UIButton *fasterButton;
	IBOutlet UIButton *slowerButton;
	IBOutlet UIButton *saveButton;
	IBOutlet MeterView *thermometerView;
	IBOutlet UIView *meterView;
	IBOutlet UIButton *meterButton;

	NSNotificationCenter *notificationCenter;
	BleepMachine * m_bleepMachine;
	AVAudioSession *audioSession;
	NSTimer *levelTimer;
	BOOL isViewVisible;
}

@property(readwrite, assign, nonatomic) Data *data;
@property (nonatomic, retain) IBOutlet UILabel *sampleRateLabel;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, assign) IBOutlet MeterView *thermometerView;
@property (nonatomic, assign) NSNotificationCenter *notificationCenter;
@property (nonatomic, assign)	AVAudioSession *audioSession;
@property (nonatomic, assign)	NSTimer *levelTimer;
@property (nonatomic, retain) IBOutlet UIButton *meterButton;
@property (nonatomic, retain) IBOutlet UIView *meterView;

-(IBAction) startStopButton: (id) sender; 
-(IBAction) sendButton: (id) sender;
-(IBAction) hotterButton: (id) sender;
-(IBAction) coolerButton: (id) sender;
-(IBAction) fasterButton: (id) sender;
-(IBAction) slowerButton: (id) sender;
-(IBAction) saveButton: (id) sender;

@end

