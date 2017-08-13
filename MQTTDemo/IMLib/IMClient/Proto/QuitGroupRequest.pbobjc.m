// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: quit_group_request.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "QuitGroupRequest.pbobjc.h"
 #import "MessageContent.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - QuitGroupRequestRoot

@implementation QuitGroupRequestRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - QuitGroupRequestRoot_FileDescriptor

static GPBFileDescriptor *QuitGroupRequestRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"mars.stn"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - QuitGroupRequest

@implementation QuitGroupRequest

@dynamic groupId;
@dynamic hasNotifyContent, notifyContent;

typedef struct QuitGroupRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *groupId;
  MessageContent *notifyContent;
} QuitGroupRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "groupId",
        .dataTypeSpecific.className = NULL,
        .number = QuitGroupRequest_FieldNumber_GroupId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(QuitGroupRequest__storage_, groupId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "notifyContent",
        .dataTypeSpecific.className = GPBStringifySymbol(MessageContent),
        .number = QuitGroupRequest_FieldNumber_NotifyContent,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(QuitGroupRequest__storage_, notifyContent),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[QuitGroupRequest class]
                                     rootClass:[QuitGroupRequestRoot class]
                                          file:QuitGroupRequestRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(QuitGroupRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
