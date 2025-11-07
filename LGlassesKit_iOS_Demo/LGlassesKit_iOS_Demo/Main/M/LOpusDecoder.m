//
//  LOpusDecoder.m
//  LGlassesKit_iOS_Demo
//
//  Created by LINWEAR on 2025-10-31.
//

#import "LOpusDecoder.h"

@interface LOpusDecoder ()
@property (nonatomic, assign) OpusDecoder *decoder;
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channels;
@end

@implementation LOpusDecoder

- (instancetype)initWithSampleRate:(int)sampleRate channels:(int)channels {
    self = [super init];
    if (self) {
        _sampleRate = sampleRate;
        _channels = channels;
        int error;
        _decoder = opus_decoder_create(sampleRate, channels, &error);
        if (!_decoder || error != OPUS_OK) {
            NSLog(@"Failed to create Opus decoder: %d", error);
            _decoder = NULL;
        }
    }
    return self;
}

- (NSData *)decodeOpusData:(NSData *)opusData error:(NSError **)error {
    if (!self.decoder || !opusData || opusData.length == 0) {
        return nil;
    }

    const unsigned char *input = (const unsigned char *)opusData.bytes;
    opus_int32 len = (opus_int32)opusData.length;

    // 假设最大帧大小为 960 样本（窄带）到 120ms（宽带）
    const int maxPcmFrameSize = 960 * 4; // 支持最高 48kHz
    const int maxPcmBufferSize = maxPcmFrameSize * self.channels * sizeof(opus_int16);

    opus_int16 *pcmBuffer = malloc(maxPcmBufferSize);
    int frameCount = opus_decode(self.decoder,
                                input,
                                len,
                                pcmBuffer,
                                maxPcmFrameSize,
                                0); // 0 = 不进行 FEC

    if (frameCount < 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"OpusDecodeError" code:frameCount userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Opus decode failed: %d", frameCount]}];
        }
        free(pcmBuffer);
        return nil;
    }

    int pcmDataSize = frameCount * self.channels * sizeof(opus_int16);
    NSData *pcmData = [NSData dataWithBytes:pcmBuffer length:pcmDataSize];
    free(pcmBuffer);
    return pcmData;
}

- (void)reset {
    if (self.decoder) {
        opus_decoder_ctl(self.decoder, OPUS_RESET_STATE);
    }
}

- (void)close {
    if (self.decoder) {
        opus_decoder_destroy(self.decoder);
        self.decoder = NULL;
    }
}

- (void)dealloc {
    [self close];
}

@end
