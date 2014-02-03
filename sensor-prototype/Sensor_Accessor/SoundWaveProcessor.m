//
//  SoundWaveProcessor.m
//  Sensor_Accessor
//
//  Created by Peter Zhao on 4/5/12.
//  Copyright (c) 2012 CALab. All rights reserved.
//

#import "SoundWaveProcessor.h"

#define HF_SOUND_FILE_PRE   @"HF_SOUNDWAVE_PRE"
#define HF_SOUND_FILE_DUR   @"HF_SOUNDWAVE_DUR"
#define LF_SOUND_FILE   @"/dev/null"

@implementation SoundWaveProcessor

@synthesize soundFileURLPre, soundFileURLDur;
@synthesize hfRecorderPre, hfRecorderDur;

+ (NSString*) hfSoundFileNamePre {
    return HF_SOUND_FILE_PRE;
}

+ (NSString*) hfSoundFileNameDur {
    return HF_SOUND_FILE_DUR;
}

- (id)init {
    self = [super init];

    if (self) {
        //--// Initializing an audio session & start our session
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //--// Grab the user document's directory
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *dataPath = [fileManager URLForDirectory: NSDocumentDirectory 
                                              inDomain: NSUserDomainMask 
                                     appropriateForURL: nil 
                                                create: YES 
                                                 error: nil];

        soundFileURLPre = [NSURL fileURLWithPath:[[dataPath path] stringByAppendingPathComponent:HF_SOUND_FILE_PRE]];
        soundFileURLDur = [NSURL fileURLWithPath:[[dataPath path] stringByAppendingPathComponent:HF_SOUND_FILE_DUR]];
        
        //--// Initialize low freq recorder
        // LF has to use uncompressed audio if we want HF to use compressed audio.
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat: 44100.0],              AVSampleRateKey,
                                        [NSNumber numberWithInt: kAudioFormatLinearPCM],  AVFormatIDKey,
                                        [NSNumber numberWithInt: 1],                      AVNumberOfChannelsKey, nil]; 
        
        
//        lfRecorder = [[AVAudioRecorder alloc] initWithURL: soundFileURL
//                                                 settings: recordSettings
//                                                    error: &lferror];
//        if( lferror != nil ) {
//            NSLog( @"[SoundWaveProcessor] ERROR: %@", [lferror localizedDescription] );
//        }
        
//        lfRecorder = [[AVAudioRecorder alloc] initWithURL: [NSURL fileURLWithPath: LF_SOUND_FILE]
//                                                 settings: recordSettings
//                                                    error: &lferror];
        
        //--// Initialize high freq recorderb
        // See here: http://developer.apple.com/library/ios/#DOCUMENTATION/AudioVideo/Conceptual/MultimediaPG/UsingAudio/UsingAudio.html
        // for why we need to use AppleIMA4 versus MPEG4AAC when recording.
        //
        // Important Excerpt: 
        //      For AAC, MP3, and ALAC (Apple Lossless) audio, decoding can take place using hardware-assisted codecs. 
        //      While efficient, this is limited to one audio stream at a time. If you need to play multiple sounds 
        //      simultaneously, store those sounds using the IMA4 (compressed) or linear PCM (uncompressed) format.
        //
        recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat: 44100.0],            AVSampleRateKey,
                            [NSNumber numberWithInt: kAudioFormatAppleIMA4], AVFormatIDKey,
                            [NSNumber numberWithInt: 1],                    AVNumberOfChannelsKey,
                            [NSNumber numberWithInt: AVAudioQualityMedium], AVEncoderAudioQualityKey, nil];    
        
        NSError *hferrorPre = nil;
        hfRecorderPre = [[AVAudioRecorder alloc] initWithURL: soundFileURLPre
                                                 settings: recordSettings 
                                                    error: &hferrorPre];
        if( hferrorPre != nil ) {
            NSLog( @"[SoundWaveProcessor] ERROR: %@", [hferrorPre localizedDescription] );
        }
        
        NSError *hferrorDur = nil;
        hfRecorderDur = [[AVAudioRecorder alloc] initWithURL: soundFileURLDur
                                                    settings: recordSettings
                                                       error: &hferrorDur];
        if( hferrorDur != nil ) {
            NSLog( @"[SoundWaveProcessor] ERROR: %@", [hferrorDur localizedDescription] );
        }
        
        
        [hfRecorderPre setDelegate:self];
        [hfRecorderDur setDelegate:self];
        
        hfRecorderPre.meteringEnabled = YES;
        hfRecorderDur.meteringEnabled = YES;
        
        [hfRecorderPre prepareToRecord];
        [hfRecorderDur prepareToRecord];

    }
    return self;
}

- (void) startPreRecording {
    if( ![hfRecorderPre isRecording] ) {
    [hfRecorderPre record];
    }
}

- (void) pausePreRecording {
    [hfRecorderPre stop];
}

- (void) startDurRecording {
    if( ![hfRecorderDur isRecording] ) {
        [hfRecorderDur record];
    }
}

- (void) pauseDurRecording {
    [hfRecorderDur stop];
}

@end
