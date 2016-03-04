@protocol SocketHandleRespDelegate<NSObject>

@required
- (void)handleSocketReposoneWithData:(NSData*)data tag:(long)tag;
@end
