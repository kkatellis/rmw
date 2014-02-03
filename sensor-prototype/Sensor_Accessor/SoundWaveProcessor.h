//
//  SoundWaveProcessor.h
//  Sensor_Accessor
//
//  Created by Peter Zhao on 4/5/12.
//  Copyright (c) 2012 CALab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface SoundWaveProcessor : NSObject <AVAudioRecorderDelegate> {
    
    AVAudioSession  *ourSession;
    AVAudioRecorder *hfRecorderPre, *hfRecorderDur;
    NSURL           *soundFileURLPre;
    NSURL           *soundFileURLDur;
}

@property (nonatomic, retain) AVAudioRecorder   *hfRecorderPre;
@property (nonatomic, retain) AVAudioRecorder   *hfRecorderDur;
@property (nonatomic, retain) NSURL             *soundFileURLPre;
@property (nonatomic, retain) NSURL             *soundFileURLDur;

+ (NSString*) hfSoundFileNamePre;
+ (NSString*) hfSoundFileNameDur;

- (void) startPreRecording;
- (void) pausePreRecording;

- (void) startDurRecording;
- (void) pauseDurRecording;

@end
