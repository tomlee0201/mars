// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: friend_request.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "friend_request.pb.h"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/port.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace mars {
namespace stn {
class FriendRequestDefaultTypeInternal : public ::google::protobuf::internal::ExplicitlyConstructed<FriendRequest> {
} _FriendRequest_default_instance_;

namespace protobuf_friend_5frequest_2eproto {


namespace {

::google::protobuf::Metadata file_level_metadata[1];
const ::google::protobuf::EnumDescriptor* file_level_enum_descriptors[1];

}  // namespace

PROTOBUF_CONSTEXPR_VAR ::google::protobuf::internal::ParseTableField
    const TableStruct::entries[] = {
  {0, 0, 0, ::google::protobuf::internal::kInvalidMask, 0, 0},
};

PROTOBUF_CONSTEXPR_VAR ::google::protobuf::internal::AuxillaryParseTableField
    const TableStruct::aux[] = {
  ::google::protobuf::internal::AuxillaryParseTableField(),
};
PROTOBUF_CONSTEXPR_VAR ::google::protobuf::internal::ParseTable const
    TableStruct::schema[] = {
  { NULL, NULL, 0, -1, -1, false },
};

const ::google::protobuf::uint32 TableStruct::offsets[] = {
  ~0u,  // no _has_bits_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, _internal_metadata_),
  ~0u,  // no _extensions_
  ~0u,  // no _oneof_case_
  ~0u,  // no _weak_field_map_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, from_uid_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, to_uid_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, reason_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, status_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, update_dt_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, from_read_status_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(FriendRequest, to_read_status_),
};

static const ::google::protobuf::internal::MigrationSchema schemas[] = {
  { 0, -1, sizeof(FriendRequest)},
};

static ::google::protobuf::Message const * const file_default_instances[] = {
  reinterpret_cast<const ::google::protobuf::Message*>(&_FriendRequest_default_instance_),
};

namespace {

void protobuf_AssignDescriptors() {
  AddDescriptors();
  ::google::protobuf::MessageFactory* factory = NULL;
  AssignDescriptors(
      "friend_request.proto", schemas, file_default_instances, TableStruct::offsets, factory,
      file_level_metadata, file_level_enum_descriptors, NULL);
}

void protobuf_AssignDescriptorsOnce() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &protobuf_AssignDescriptors);
}

void protobuf_RegisterTypes(const ::std::string&) GOOGLE_ATTRIBUTE_COLD;
void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::internal::RegisterAllTypes(file_level_metadata, 1);
}

}  // namespace

void TableStruct::Shutdown() {
  _FriendRequest_default_instance_.Shutdown();
  delete file_level_metadata[0].reflection;
}

void TableStruct::InitDefaultsImpl() {
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::internal::InitProtobufDefaults();
  _FriendRequest_default_instance_.DefaultConstruct();
}

void InitDefaults() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &TableStruct::InitDefaultsImpl);
}
void AddDescriptorsImpl() {
  InitDefaults();
  static const char descriptor[] = {
      "\n\024friend_request.proto\022\010mars.stn\"\257\001\n\rFri"
      "endRequest\022\020\n\010from_uid\030\001 \001(\t\022\016\n\006to_uid\030\002"
      " \001(\t\022\016\n\006reason\030\003 \001(\t\022\'\n\006status\030\004 \001(\0162\027.m"
      "ars.stn.RequestStatus\022\021\n\tupdate_dt\030\005 \001(\003"
      "\022\030\n\020from_read_status\030\006 \001(\010\022\026\n\016to_read_st"
      "atus\030\007 \001(\010*5\n\rRequestStatus\022\010\n\004sent\020\000\022\014\n"
      "\010accepted\020\001\022\014\n\010rejected\020\002B/\n\024win.liyufan"
      ".im.protoB\027FriendRequestOuterClassb\006prot"
      "o3"
  };
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
      descriptor, 322);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "friend_request.proto", &protobuf_RegisterTypes);
  ::google::protobuf::internal::OnShutdown(&TableStruct::Shutdown);
}

void AddDescriptors() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &AddDescriptorsImpl);
}
// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer {
  StaticDescriptorInitializer() {
    AddDescriptors();
  }
} static_descriptor_initializer;

}  // namespace protobuf_friend_5frequest_2eproto

const ::google::protobuf::EnumDescriptor* RequestStatus_descriptor() {
  protobuf_friend_5frequest_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_friend_5frequest_2eproto::file_level_enum_descriptors[0];
}
bool RequestStatus_IsValid(int value) {
  switch (value) {
    case 0:
    case 1:
    case 2:
      return true;
    default:
      return false;
  }
}


// ===================================================================

#if !defined(_MSC_VER) || _MSC_VER >= 1900
const int FriendRequest::kFromUidFieldNumber;
const int FriendRequest::kToUidFieldNumber;
const int FriendRequest::kReasonFieldNumber;
const int FriendRequest::kStatusFieldNumber;
const int FriendRequest::kUpdateDtFieldNumber;
const int FriendRequest::kFromReadStatusFieldNumber;
const int FriendRequest::kToReadStatusFieldNumber;
#endif  // !defined(_MSC_VER) || _MSC_VER >= 1900

FriendRequest::FriendRequest()
  : ::google::protobuf::Message(), _internal_metadata_(NULL) {
  if (GOOGLE_PREDICT_TRUE(this != internal_default_instance())) {
    protobuf_friend_5frequest_2eproto::InitDefaults();
  }
  SharedCtor();
  // @@protoc_insertion_point(constructor:mars.stn.FriendRequest)
}
FriendRequest::FriendRequest(const FriendRequest& from)
  : ::google::protobuf::Message(),
      _internal_metadata_(NULL),
      _cached_size_(0) {
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  from_uid_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (from.from_uid().size() > 0) {
    from_uid_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.from_uid_);
  }
  to_uid_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (from.to_uid().size() > 0) {
    to_uid_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.to_uid_);
  }
  reason_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (from.reason().size() > 0) {
    reason_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.reason_);
  }
  ::memcpy(&update_dt_, &from.update_dt_,
    reinterpret_cast<char*>(&to_read_status_) -
    reinterpret_cast<char*>(&update_dt_) + sizeof(to_read_status_));
  // @@protoc_insertion_point(copy_constructor:mars.stn.FriendRequest)
}

void FriendRequest::SharedCtor() {
  from_uid_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  to_uid_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  reason_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  ::memset(&update_dt_, 0, reinterpret_cast<char*>(&to_read_status_) -
    reinterpret_cast<char*>(&update_dt_) + sizeof(to_read_status_));
  _cached_size_ = 0;
}

FriendRequest::~FriendRequest() {
  // @@protoc_insertion_point(destructor:mars.stn.FriendRequest)
  SharedDtor();
}

void FriendRequest::SharedDtor() {
  from_uid_.DestroyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  to_uid_.DestroyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  reason_.DestroyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}

void FriendRequest::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* FriendRequest::descriptor() {
  protobuf_friend_5frequest_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_friend_5frequest_2eproto::file_level_metadata[kIndexInFileMessages].descriptor;
}

const FriendRequest& FriendRequest::default_instance() {
  protobuf_friend_5frequest_2eproto::InitDefaults();
  return *internal_default_instance();
}

FriendRequest* FriendRequest::New(::google::protobuf::Arena* arena) const {
  FriendRequest* n = new FriendRequest;
  if (arena != NULL) {
    arena->Own(n);
  }
  return n;
}

void FriendRequest::Clear() {
// @@protoc_insertion_point(message_clear_start:mars.stn.FriendRequest)
  from_uid_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  to_uid_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  reason_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  ::memset(&update_dt_, 0, reinterpret_cast<char*>(&to_read_status_) -
    reinterpret_cast<char*>(&update_dt_) + sizeof(to_read_status_));
}

bool FriendRequest::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!GOOGLE_PREDICT_TRUE(EXPRESSION)) goto failure
  ::google::protobuf::uint32 tag;
  // @@protoc_insertion_point(parse_start:mars.stn.FriendRequest)
  for (;;) {
    ::std::pair< ::google::protobuf::uint32, bool> p = input->ReadTagWithCutoffNoLastTag(127u);
    tag = p.first;
    if (!p.second) goto handle_unusual;
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // string from_uid = 1;
      case 1: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(10u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_from_uid()));
          DO_(::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            this->from_uid().data(), this->from_uid().length(),
            ::google::protobuf::internal::WireFormatLite::PARSE,
            "mars.stn.FriendRequest.from_uid"));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // string to_uid = 2;
      case 2: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(18u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_to_uid()));
          DO_(::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            this->to_uid().data(), this->to_uid().length(),
            ::google::protobuf::internal::WireFormatLite::PARSE,
            "mars.stn.FriendRequest.to_uid"));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // string reason = 3;
      case 3: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(26u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_reason()));
          DO_(::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            this->reason().data(), this->reason().length(),
            ::google::protobuf::internal::WireFormatLite::PARSE,
            "mars.stn.FriendRequest.reason"));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // .mars.stn.RequestStatus status = 4;
      case 4: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(32u)) {
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          set_status(static_cast< ::mars::stn::RequestStatus >(value));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // int64 update_dt = 5;
      case 5: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(40u)) {

          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int64, ::google::protobuf::internal::WireFormatLite::TYPE_INT64>(
                 input, &update_dt_)));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // bool from_read_status = 6;
      case 6: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(48u)) {

          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &from_read_status_)));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // bool to_read_status = 7;
      case 7: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(56u)) {

          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &to_read_status_)));
        } else {
          goto handle_unusual;
        }
        break;
      }

      default: {
      handle_unusual:
        if (tag == 0 ||
            ::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          goto success;
        }
        DO_(::google::protobuf::internal::WireFormatLite::SkipField(input, tag));
        break;
      }
    }
  }
success:
  // @@protoc_insertion_point(parse_success:mars.stn.FriendRequest)
  return true;
failure:
  // @@protoc_insertion_point(parse_failure:mars.stn.FriendRequest)
  return false;
#undef DO_
}

void FriendRequest::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // @@protoc_insertion_point(serialize_start:mars.stn.FriendRequest)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // string from_uid = 1;
  if (this->from_uid().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->from_uid().data(), this->from_uid().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.from_uid");
    ::google::protobuf::internal::WireFormatLite::WriteStringMaybeAliased(
      1, this->from_uid(), output);
  }

  // string to_uid = 2;
  if (this->to_uid().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->to_uid().data(), this->to_uid().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.to_uid");
    ::google::protobuf::internal::WireFormatLite::WriteStringMaybeAliased(
      2, this->to_uid(), output);
  }

  // string reason = 3;
  if (this->reason().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->reason().data(), this->reason().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.reason");
    ::google::protobuf::internal::WireFormatLite::WriteStringMaybeAliased(
      3, this->reason(), output);
  }

  // .mars.stn.RequestStatus status = 4;
  if (this->status() != 0) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      4, this->status(), output);
  }

  // int64 update_dt = 5;
  if (this->update_dt() != 0) {
    ::google::protobuf::internal::WireFormatLite::WriteInt64(5, this->update_dt(), output);
  }

  // bool from_read_status = 6;
  if (this->from_read_status() != 0) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(6, this->from_read_status(), output);
  }

  // bool to_read_status = 7;
  if (this->to_read_status() != 0) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(7, this->to_read_status(), output);
  }

  // @@protoc_insertion_point(serialize_end:mars.stn.FriendRequest)
}

::google::protobuf::uint8* FriendRequest::InternalSerializeWithCachedSizesToArray(
    bool deterministic, ::google::protobuf::uint8* target) const {
  // @@protoc_insertion_point(serialize_to_array_start:mars.stn.FriendRequest)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // string from_uid = 1;
  if (this->from_uid().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->from_uid().data(), this->from_uid().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.from_uid");
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        1, this->from_uid(), target);
  }

  // string to_uid = 2;
  if (this->to_uid().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->to_uid().data(), this->to_uid().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.to_uid");
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        2, this->to_uid(), target);
  }

  // string reason = 3;
  if (this->reason().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->reason().data(), this->reason().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.FriendRequest.reason");
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        3, this->reason(), target);
  }

  // .mars.stn.RequestStatus status = 4;
  if (this->status() != 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      4, this->status(), target);
  }

  // int64 update_dt = 5;
  if (this->update_dt() != 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArray(5, this->update_dt(), target);
  }

  // bool from_read_status = 6;
  if (this->from_read_status() != 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(6, this->from_read_status(), target);
  }

  // bool to_read_status = 7;
  if (this->to_read_status() != 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(7, this->to_read_status(), target);
  }

  // @@protoc_insertion_point(serialize_to_array_end:mars.stn.FriendRequest)
  return target;
}

size_t FriendRequest::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:mars.stn.FriendRequest)
  size_t total_size = 0;

  // string from_uid = 1;
  if (this->from_uid().size() > 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::StringSize(
        this->from_uid());
  }

  // string to_uid = 2;
  if (this->to_uid().size() > 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::StringSize(
        this->to_uid());
  }

  // string reason = 3;
  if (this->reason().size() > 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::StringSize(
        this->reason());
  }

  // int64 update_dt = 5;
  if (this->update_dt() != 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::Int64Size(
        this->update_dt());
  }

  // .mars.stn.RequestStatus status = 4;
  if (this->status() != 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::EnumSize(this->status());
  }

  // bool from_read_status = 6;
  if (this->from_read_status() != 0) {
    total_size += 1 + 1;
  }

  // bool to_read_status = 7;
  if (this->to_read_status() != 0) {
    total_size += 1 + 1;
  }

  int cached_size = ::google::protobuf::internal::ToCachedSize(total_size);
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = cached_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void FriendRequest::MergeFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_merge_from_start:mars.stn.FriendRequest)
  GOOGLE_DCHECK_NE(&from, this);
  const FriendRequest* source =
      ::google::protobuf::internal::DynamicCastToGenerated<const FriendRequest>(
          &from);
  if (source == NULL) {
  // @@protoc_insertion_point(generalized_merge_from_cast_fail:mars.stn.FriendRequest)
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
  // @@protoc_insertion_point(generalized_merge_from_cast_success:mars.stn.FriendRequest)
    MergeFrom(*source);
  }
}

void FriendRequest::MergeFrom(const FriendRequest& from) {
// @@protoc_insertion_point(class_specific_merge_from_start:mars.stn.FriendRequest)
  GOOGLE_DCHECK_NE(&from, this);
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  if (from.from_uid().size() > 0) {

    from_uid_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.from_uid_);
  }
  if (from.to_uid().size() > 0) {

    to_uid_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.to_uid_);
  }
  if (from.reason().size() > 0) {

    reason_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.reason_);
  }
  if (from.update_dt() != 0) {
    set_update_dt(from.update_dt());
  }
  if (from.status() != 0) {
    set_status(from.status());
  }
  if (from.from_read_status() != 0) {
    set_from_read_status(from.from_read_status());
  }
  if (from.to_read_status() != 0) {
    set_to_read_status(from.to_read_status());
  }
}

void FriendRequest::CopyFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_copy_from_start:mars.stn.FriendRequest)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void FriendRequest::CopyFrom(const FriendRequest& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:mars.stn.FriendRequest)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool FriendRequest::IsInitialized() const {
  return true;
}

void FriendRequest::Swap(FriendRequest* other) {
  if (other == this) return;
  InternalSwap(other);
}
void FriendRequest::InternalSwap(FriendRequest* other) {
  from_uid_.Swap(&other->from_uid_);
  to_uid_.Swap(&other->to_uid_);
  reason_.Swap(&other->reason_);
  std::swap(update_dt_, other->update_dt_);
  std::swap(status_, other->status_);
  std::swap(from_read_status_, other->from_read_status_);
  std::swap(to_read_status_, other->to_read_status_);
  std::swap(_cached_size_, other->_cached_size_);
}

::google::protobuf::Metadata FriendRequest::GetMetadata() const {
  protobuf_friend_5frequest_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_friend_5frequest_2eproto::file_level_metadata[kIndexInFileMessages];
}

#if PROTOBUF_INLINE_NOT_IN_HEADERS
// FriendRequest

// string from_uid = 1;
void FriendRequest::clear_from_uid() {
  from_uid_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
const ::std::string& FriendRequest::from_uid() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.from_uid)
  return from_uid_.GetNoArena();
}
void FriendRequest::set_from_uid(const ::std::string& value) {
  
  from_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.from_uid)
}
#if LANG_CXX11
void FriendRequest::set_from_uid(::std::string&& value) {
  
  from_uid_.SetNoArena(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value));
  // @@protoc_insertion_point(field_set_rvalue:mars.stn.FriendRequest.from_uid)
}
#endif
void FriendRequest::set_from_uid(const char* value) {
  GOOGLE_DCHECK(value != NULL);
  
  from_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:mars.stn.FriendRequest.from_uid)
}
void FriendRequest::set_from_uid(const char* value, size_t size) {
  
  from_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:mars.stn.FriendRequest.from_uid)
}
::std::string* FriendRequest::mutable_from_uid() {
  
  // @@protoc_insertion_point(field_mutable:mars.stn.FriendRequest.from_uid)
  return from_uid_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
::std::string* FriendRequest::release_from_uid() {
  // @@protoc_insertion_point(field_release:mars.stn.FriendRequest.from_uid)
  
  return from_uid_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
void FriendRequest::set_allocated_from_uid(::std::string* from_uid) {
  if (from_uid != NULL) {
    
  } else {
    
  }
  from_uid_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from_uid);
  // @@protoc_insertion_point(field_set_allocated:mars.stn.FriendRequest.from_uid)
}

// string to_uid = 2;
void FriendRequest::clear_to_uid() {
  to_uid_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
const ::std::string& FriendRequest::to_uid() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.to_uid)
  return to_uid_.GetNoArena();
}
void FriendRequest::set_to_uid(const ::std::string& value) {
  
  to_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.to_uid)
}
#if LANG_CXX11
void FriendRequest::set_to_uid(::std::string&& value) {
  
  to_uid_.SetNoArena(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value));
  // @@protoc_insertion_point(field_set_rvalue:mars.stn.FriendRequest.to_uid)
}
#endif
void FriendRequest::set_to_uid(const char* value) {
  GOOGLE_DCHECK(value != NULL);
  
  to_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:mars.stn.FriendRequest.to_uid)
}
void FriendRequest::set_to_uid(const char* value, size_t size) {
  
  to_uid_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:mars.stn.FriendRequest.to_uid)
}
::std::string* FriendRequest::mutable_to_uid() {
  
  // @@protoc_insertion_point(field_mutable:mars.stn.FriendRequest.to_uid)
  return to_uid_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
::std::string* FriendRequest::release_to_uid() {
  // @@protoc_insertion_point(field_release:mars.stn.FriendRequest.to_uid)
  
  return to_uid_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
void FriendRequest::set_allocated_to_uid(::std::string* to_uid) {
  if (to_uid != NULL) {
    
  } else {
    
  }
  to_uid_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), to_uid);
  // @@protoc_insertion_point(field_set_allocated:mars.stn.FriendRequest.to_uid)
}

// string reason = 3;
void FriendRequest::clear_reason() {
  reason_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
const ::std::string& FriendRequest::reason() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.reason)
  return reason_.GetNoArena();
}
void FriendRequest::set_reason(const ::std::string& value) {
  
  reason_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.reason)
}
#if LANG_CXX11
void FriendRequest::set_reason(::std::string&& value) {
  
  reason_.SetNoArena(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value));
  // @@protoc_insertion_point(field_set_rvalue:mars.stn.FriendRequest.reason)
}
#endif
void FriendRequest::set_reason(const char* value) {
  GOOGLE_DCHECK(value != NULL);
  
  reason_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:mars.stn.FriendRequest.reason)
}
void FriendRequest::set_reason(const char* value, size_t size) {
  
  reason_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:mars.stn.FriendRequest.reason)
}
::std::string* FriendRequest::mutable_reason() {
  
  // @@protoc_insertion_point(field_mutable:mars.stn.FriendRequest.reason)
  return reason_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
::std::string* FriendRequest::release_reason() {
  // @@protoc_insertion_point(field_release:mars.stn.FriendRequest.reason)
  
  return reason_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
void FriendRequest::set_allocated_reason(::std::string* reason) {
  if (reason != NULL) {
    
  } else {
    
  }
  reason_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), reason);
  // @@protoc_insertion_point(field_set_allocated:mars.stn.FriendRequest.reason)
}

// .mars.stn.RequestStatus status = 4;
void FriendRequest::clear_status() {
  status_ = 0;
}
::mars::stn::RequestStatus FriendRequest::status() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.status)
  return static_cast< ::mars::stn::RequestStatus >(status_);
}
void FriendRequest::set_status(::mars::stn::RequestStatus value) {
  
  status_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.status)
}

// int64 update_dt = 5;
void FriendRequest::clear_update_dt() {
  update_dt_ = GOOGLE_LONGLONG(0);
}
::google::protobuf::int64 FriendRequest::update_dt() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.update_dt)
  return update_dt_;
}
void FriendRequest::set_update_dt(::google::protobuf::int64 value) {
  
  update_dt_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.update_dt)
}

// bool from_read_status = 6;
void FriendRequest::clear_from_read_status() {
  from_read_status_ = false;
}
bool FriendRequest::from_read_status() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.from_read_status)
  return from_read_status_;
}
void FriendRequest::set_from_read_status(bool value) {
  
  from_read_status_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.from_read_status)
}

// bool to_read_status = 7;
void FriendRequest::clear_to_read_status() {
  to_read_status_ = false;
}
bool FriendRequest::to_read_status() const {
  // @@protoc_insertion_point(field_get:mars.stn.FriendRequest.to_read_status)
  return to_read_status_;
}
void FriendRequest::set_to_read_status(bool value) {
  
  to_read_status_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.FriendRequest.to_read_status)
}

#endif  // PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)

}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)
