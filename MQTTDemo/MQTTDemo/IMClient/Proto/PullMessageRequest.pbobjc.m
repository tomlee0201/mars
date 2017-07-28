// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: pull_message_request.proto

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

 #import "PullMessageRequest.pbobjc.h"
 #import "NotifyMessage.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - PullMessageRequestRoot

@implementation PullMessageRequestRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - PullMessageRequestRoot_FileDescriptor

static GPBFileDescriptor *PullMessageRequestRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"proto"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - PullMessageRequest

@implementation PullMessageRequest

@dynamic id_p;
@dynamic type;

typedef struct PullMessageRequest__storage_ {
  uint32_t _has_storage_[1];
  PullType type;
  int64_t id_p;
} PullMessageRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = PullMessageRequest_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PullMessageRequest__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "type",
        .dataTypeSpecific.enumDescFunc = PullType_EnumDescriptor,
        .number = PullMessageRequest_FieldNumber_Type,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(PullMessageRequest__storage_, type),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PullMessageRequest class]
                                     rootClass:[PullMessageRequestRoot class]
                                          file:PullMessageRequestRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PullMessageRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t PullMessageRequest_Type_RawValue(PullMessageRequest *message) {
  GPBDescriptor *descriptor = [PullMessageRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:PullMessageRequest_FieldNumber_Type];
  return GPBGetMessageInt32Field(message, field);
}

void SetPullMessageRequest_Type_RawValue(PullMessageRequest *message, int32_t value) {
  GPBDescriptor *descriptor = [PullMessageRequest descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:PullMessageRequest_FieldNumber_Type];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
