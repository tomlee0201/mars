//
//  IMService.h
//  MQTTDemo
//
//  Created by Tao Li on 2017/8/8.
//  Copyright © 2017年 litao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "GroupInfo.h"
#import "ConversationInfo.h"
#import "UserInfo.h"
#import "FriendRequest.h"

typedef enum : NSUInteger {
  Modify_DisplayName = 0,
  Modify_Portrait = 1,
  Modify_Mobile = 2,
  Modify_Email = 3,
  Modify_Address = 4,
  Modify_Company = 5,
  Modify_Social = 6,
  Modify_Extra = 7
} ModifyMyInfoType;


@interface IMService : NSObject
+ (IMService*)sharedIMService;

- (Message *)send:(Conversation *)conversation content:(MessageContent *)content success:(void(^)(long messageId, long timestamp))successBlock error:(void(^)(int error_code))errorBlock;

- (NSArray<ConversationInfo *> *)getConversations:(NSArray<NSNumber *> *)conversationTypes lines:(NSArray<NSNumber *> *)lines;
- (NSArray<Message *> *)getMessages:(Conversation *)conversation from:(NSUInteger)fromIndex count:(NSUInteger)count;

- (void)clearUnreadStatus:(Conversation *)conversation;
- (void)clearAllUnreadStatus;

- (void)removeConversation:(Conversation *)conversation clearMessage:(BOOL)clearMessage;

- (void)setConversation:(Conversation *)conversation top:(BOOL)top;

- (BOOL)deleteMessage:(long)messageId;

- (GroupInfo *)getGroupInfo:(NSString *)groupId refresh:(BOOL)refresh;
- (UserInfo *)getUserInfo:(NSString *)userId refresh:(BOOL)refresh;

- (void)registerMessageContent:(Class)contentClass;
- (MessageContent *)messageContentFromPayload:(MessagePayload *)payload;
- (void)searchUser:(NSString *)keyword success:(void(^)(NSArray<UserInfo *> *machedUsers))successBlock error:(void(^)(int errorCode))errorBlock;


- (BOOL)isMyFriend:(NSString *)userId;

- (NSArray<NSString *> *)getMyFriendList:(BOOL)refresh;

- (NSArray<FriendRequest *> *)getIncommingFriendRequest;
- (NSArray<FriendRequest *> *)getOutgoingFriendRequest;

- (void)clearUnreadFriendRequestStatus;
- (int)getUnreadFriendRequestStatus;

- (void)removeFriend:(NSString *)userId
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock;

- (void)sendFriendRequest:(NSString *)userId
                   reason:(NSString *)reason
                  success:(void(^)())successBlock
                    error:(void(^)(int error_code))errorBlock;

- (void)handleFriendRequest:(NSString *)userId
                     accept:(BOOL)accpet
                  success:(void(^)())successBlock
                    error:(void(^)(int error_code))errorBlock;

- (void)deleteFriend:(NSString *)userId
            success:(void(^)())successBlock
              error:(void(^)(int error_code))errorBlock;

- (void)createGroup:(NSString *)groupId
               name:(NSString *)groupName
           portrait:(NSString *)groupPortrait
            members:(NSArray *)groupMembers
        notifyLines:(NSArray<NSNumber *> *)notifyLines
      notifyContent:(MessageContent *)notifyContent
            success:(void(^)(NSString *groupId))successBlock
              error:(void(^)(int error_code))errorBlock;

- (void)addMembers:(NSArray *)members
           toGroup:(NSString *)groupId
       notifyLines:(NSArray<NSNumber *> *)notifyLines
     notifyContent:(MessageContent *)notifyContent
           success:(void(^)())successBlock
             error:(void(^)(int error_code))errorBlock;

- (void)kickoffMembers:(NSArray *)members
             fromGroup:(NSString *)groupId
           notifyLines:(NSArray<NSNumber *> *)notifyLines
         notifyContent:(MessageContent *)notifyContent
               success:(void(^)())successBlock
                 error:(void(^)(int error_code))errorBlock;

- (void)quitGroup:(NSString *)groupId
      notifyLines:(NSArray<NSNumber *> *)notifyLines
    notifyContent:(MessageContent *)notifyContent
          success:(void(^)())successBlock
            error:(void(^)(int error_code))errorBlock;

- (void)dismissGroup:(NSString *)groupId
         notifyLines:(NSArray<NSNumber *> *)notifyLines
       notifyContent:(MessageContent *)notifyContent
             success:(void(^)())successBlock
               error:(void(^)(int error_code))errorBlock;

- (void)modifyGroupInfo:(GroupInfo *)groupInfo
            notifyLines:(NSArray<NSNumber *> *)notifyLines
          notifyContent:(MessageContent *)notifyContent
                success:(void(^)())successBlock
                  error:(void(^)(int error_code))errorBlock;

- (void)getGroupMembers:(NSString *)groupId
                success:(void(^)(NSArray<NSString *> *))successBlock
                  error:(void(^)(int error_code))errorBlock;

- (void)getMyGroups:(void(^)(NSArray<NSString *> *))successBlock
                  error:(void(^)(int error_code))errorBlock;

- (void)transferGroup:(NSString *)groupId
                   to:(NSString *)newOwner
          notifyLines:(NSArray<NSNumber *> *)notifyLines
        notifyContent:(MessageContent *)notifyContent
              success:(void(^)())successBlock
                error:(void(^)(int error_code))errorBlock;
  
- (void)uploadMedia:(NSData *)mediaData
          mediaType:(MediaType)mediaType
            success:(void(^)(NSString *remoteUrl))successBlock
              error:(void(^)(int error_code))errorBlock;
  
  -(void)modifyMyInfo:(NSDictionary<NSNumber */*ModifyMyInfoType*/, NSString *> *)values
              success:(void(^)())successBlock
                error:(void(^)(int error_code))errorBlock;
@end
