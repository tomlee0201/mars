// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: pull_user_response.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "pull_user_response.pb.h"

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
class UserResultDefaultTypeInternal : public ::google::protobuf::internal::ExplicitlyConstructed<UserResult> {
} _UserResult_default_instance_;
class PullUserResultDefaultTypeInternal : public ::google::protobuf::internal::ExplicitlyConstructed<PullUserResult> {
} _PullUserResult_default_instance_;

namespace protobuf_pull_5fuser_5fresponse_2eproto {


namespace {

::google::protobuf::Metadata file_level_metadata[2];
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
  { NULL, NULL, 0, -1, -1, false },
};

const ::google::protobuf::uint32 TableStruct::offsets[] = {
  ~0u,  // no _has_bits_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(UserResult, _internal_metadata_),
  ~0u,  // no _extensions_
  ~0u,  // no _oneof_case_
  ~0u,  // no _weak_field_map_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(UserResult, user_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(UserResult, code_),
  ~0u,  // no _has_bits_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PullUserResult, _internal_metadata_),
  ~0u,  // no _extensions_
  ~0u,  // no _oneof_case_
  ~0u,  // no _weak_field_map_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PullUserResult, result_),
};

static const ::google::protobuf::internal::MigrationSchema schemas[] = {
  { 0, -1, sizeof(UserResult)},
  { 7, -1, sizeof(PullUserResult)},
};

static ::google::protobuf::Message const * const file_default_instances[] = {
  reinterpret_cast<const ::google::protobuf::Message*>(&_UserResult_default_instance_),
  reinterpret_cast<const ::google::protobuf::Message*>(&_PullUserResult_default_instance_),
};

namespace {

void protobuf_AssignDescriptors() {
  AddDescriptors();
  ::google::protobuf::MessageFactory* factory = NULL;
  AssignDescriptors(
      "pull_user_response.proto", schemas, file_default_instances, TableStruct::offsets, factory,
      file_level_metadata, file_level_enum_descriptors, NULL);
}

void protobuf_AssignDescriptorsOnce() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &protobuf_AssignDescriptors);
}

void protobuf_RegisterTypes(const ::std::string&) GOOGLE_ATTRIBUTE_COLD;
void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::internal::RegisterAllTypes(file_level_metadata, 2);
}

}  // namespace

void TableStruct::Shutdown() {
  _UserResult_default_instance_.Shutdown();
  delete file_level_metadata[0].reflection;
  _PullUserResult_default_instance_.Shutdown();
  delete file_level_metadata[1].reflection;
}

void TableStruct::InitDefaultsImpl() {
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::internal::InitProtobufDefaults();
  ::mars::stn::protobuf_user_2eproto::InitDefaults();
  _UserResult_default_instance_.DefaultConstruct();
  _PullUserResult_default_instance_.DefaultConstruct();
  _UserResult_default_instance_.get_mutable()->user_ = const_cast< ::mars::stn::User*>(
      ::mars::stn::User::internal_default_instance());
}

void InitDefaults() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &TableStruct::InitDefaultsImpl);
}
void AddDescriptorsImpl() {
  InitDefaults();
  static const char descriptor[] = {
      "\n\030pull_user_response.proto\022\010mars.stn\032\nus"
      "er.proto\"R\n\nUserResult\022\034\n\004user\030\001 \001(\0132\016.m"
      "ars.stn.User\022&\n\004code\030\002 \001(\0162\030.mars.stn.Us"
      "erResultCode\"6\n\016PullUserResult\022$\n\006result"
      "\030\001 \003(\0132\024.mars.stn.UserResult*<\n\016UserResu"
      "ltCode\022\013\n\007Success\020\000\022\014\n\010NotFound\020\001\022\017\n\013Not"
      "Modified\020\002B0\n\024win.liyufan.im.protoB\030Pull"
      "UserResultOuterClassb\006proto3"
  };
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
      descriptor, 308);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "pull_user_response.proto", &protobuf_RegisterTypes);
  ::mars::stn::protobuf_user_2eproto::AddDescriptors();
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

}  // namespace protobuf_pull_5fuser_5fresponse_2eproto

const ::google::protobuf::EnumDescriptor* UserResultCode_descriptor() {
  protobuf_pull_5fuser_5fresponse_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fuser_5fresponse_2eproto::file_level_enum_descriptors[0];
}
bool UserResultCode_IsValid(int value) {
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
const int UserResult::kUserFieldNumber;
const int UserResult::kCodeFieldNumber;
#endif  // !defined(_MSC_VER) || _MSC_VER >= 1900

UserResult::UserResult()
  : ::google::protobuf::Message(), _internal_metadata_(NULL) {
  if (GOOGLE_PREDICT_TRUE(this != internal_default_instance())) {
    protobuf_pull_5fuser_5fresponse_2eproto::InitDefaults();
  }
  SharedCtor();
  // @@protoc_insertion_point(constructor:mars.stn.UserResult)
}
UserResult::UserResult(const UserResult& from)
  : ::google::protobuf::Message(),
      _internal_metadata_(NULL),
      _cached_size_(0) {
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  if (from.has_user()) {
    user_ = new ::mars::stn::User(*from.user_);
  } else {
    user_ = NULL;
  }
  code_ = from.code_;
  // @@protoc_insertion_point(copy_constructor:mars.stn.UserResult)
}

void UserResult::SharedCtor() {
  ::memset(&user_, 0, reinterpret_cast<char*>(&code_) -
    reinterpret_cast<char*>(&user_) + sizeof(code_));
  _cached_size_ = 0;
}

UserResult::~UserResult() {
  // @@protoc_insertion_point(destructor:mars.stn.UserResult)
  SharedDtor();
}

void UserResult::SharedDtor() {
  if (this != internal_default_instance()) {
    delete user_;
  }
}

void UserResult::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* UserResult::descriptor() {
  protobuf_pull_5fuser_5fresponse_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fuser_5fresponse_2eproto::file_level_metadata[kIndexInFileMessages].descriptor;
}

const UserResult& UserResult::default_instance() {
  protobuf_pull_5fuser_5fresponse_2eproto::InitDefaults();
  return *internal_default_instance();
}

UserResult* UserResult::New(::google::protobuf::Arena* arena) const {
  UserResult* n = new UserResult;
  if (arena != NULL) {
    arena->Own(n);
  }
  return n;
}

void UserResult::Clear() {
// @@protoc_insertion_point(message_clear_start:mars.stn.UserResult)
  if (GetArenaNoVirtual() == NULL && user_ != NULL) {
    delete user_;
  }
  user_ = NULL;
  code_ = 0;
}

bool UserResult::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!GOOGLE_PREDICT_TRUE(EXPRESSION)) goto failure
  ::google::protobuf::uint32 tag;
  // @@protoc_insertion_point(parse_start:mars.stn.UserResult)
  for (;;) {
    ::std::pair< ::google::protobuf::uint32, bool> p = input->ReadTagWithCutoffNoLastTag(127u);
    tag = p.first;
    if (!p.second) goto handle_unusual;
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // .mars.stn.User user = 1;
      case 1: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(10u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
               input, mutable_user()));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // .mars.stn.UserResultCode code = 2;
      case 2: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(16u)) {
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          set_code(static_cast< ::mars::stn::UserResultCode >(value));
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
  // @@protoc_insertion_point(parse_success:mars.stn.UserResult)
  return true;
failure:
  // @@protoc_insertion_point(parse_failure:mars.stn.UserResult)
  return false;
#undef DO_
}

void UserResult::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // @@protoc_insertion_point(serialize_start:mars.stn.UserResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // .mars.stn.User user = 1;
  if (this->has_user()) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      1, *this->user_, output);
  }

  // .mars.stn.UserResultCode code = 2;
  if (this->code() != 0) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      2, this->code(), output);
  }

  // @@protoc_insertion_point(serialize_end:mars.stn.UserResult)
}

::google::protobuf::uint8* UserResult::InternalSerializeWithCachedSizesToArray(
    bool deterministic, ::google::protobuf::uint8* target) const {
  // @@protoc_insertion_point(serialize_to_array_start:mars.stn.UserResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // .mars.stn.User user = 1;
  if (this->has_user()) {
    target = ::google::protobuf::internal::WireFormatLite::
      InternalWriteMessageNoVirtualToArray(
        1, *this->user_, deterministic, target);
  }

  // .mars.stn.UserResultCode code = 2;
  if (this->code() != 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      2, this->code(), target);
  }

  // @@protoc_insertion_point(serialize_to_array_end:mars.stn.UserResult)
  return target;
}

size_t UserResult::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:mars.stn.UserResult)
  size_t total_size = 0;

  // .mars.stn.User user = 1;
  if (this->has_user()) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
        *this->user_);
  }

  // .mars.stn.UserResultCode code = 2;
  if (this->code() != 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::EnumSize(this->code());
  }

  int cached_size = ::google::protobuf::internal::ToCachedSize(total_size);
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = cached_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void UserResult::MergeFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_merge_from_start:mars.stn.UserResult)
  GOOGLE_DCHECK_NE(&from, this);
  const UserResult* source =
      ::google::protobuf::internal::DynamicCastToGenerated<const UserResult>(
          &from);
  if (source == NULL) {
  // @@protoc_insertion_point(generalized_merge_from_cast_fail:mars.stn.UserResult)
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
  // @@protoc_insertion_point(generalized_merge_from_cast_success:mars.stn.UserResult)
    MergeFrom(*source);
  }
}

void UserResult::MergeFrom(const UserResult& from) {
// @@protoc_insertion_point(class_specific_merge_from_start:mars.stn.UserResult)
  GOOGLE_DCHECK_NE(&from, this);
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  if (from.has_user()) {
    mutable_user()->::mars::stn::User::MergeFrom(from.user());
  }
  if (from.code() != 0) {
    set_code(from.code());
  }
}

void UserResult::CopyFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_copy_from_start:mars.stn.UserResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void UserResult::CopyFrom(const UserResult& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:mars.stn.UserResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool UserResult::IsInitialized() const {
  return true;
}

void UserResult::Swap(UserResult* other) {
  if (other == this) return;
  InternalSwap(other);
}
void UserResult::InternalSwap(UserResult* other) {
  std::swap(user_, other->user_);
  std::swap(code_, other->code_);
  std::swap(_cached_size_, other->_cached_size_);
}

::google::protobuf::Metadata UserResult::GetMetadata() const {
  protobuf_pull_5fuser_5fresponse_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fuser_5fresponse_2eproto::file_level_metadata[kIndexInFileMessages];
}

#if PROTOBUF_INLINE_NOT_IN_HEADERS
// UserResult

// .mars.stn.User user = 1;
bool UserResult::has_user() const {
  return this != internal_default_instance() && user_ != NULL;
}
void UserResult::clear_user() {
  if (GetArenaNoVirtual() == NULL && user_ != NULL) delete user_;
  user_ = NULL;
}
const ::mars::stn::User& UserResult::user() const {
  // @@protoc_insertion_point(field_get:mars.stn.UserResult.user)
  return user_ != NULL ? *user_
                         : *::mars::stn::User::internal_default_instance();
}
::mars::stn::User* UserResult::mutable_user() {
  
  if (user_ == NULL) {
    user_ = new ::mars::stn::User;
  }
  // @@protoc_insertion_point(field_mutable:mars.stn.UserResult.user)
  return user_;
}
::mars::stn::User* UserResult::release_user() {
  // @@protoc_insertion_point(field_release:mars.stn.UserResult.user)
  
  ::mars::stn::User* temp = user_;
  user_ = NULL;
  return temp;
}
void UserResult::set_allocated_user(::mars::stn::User* user) {
  delete user_;
  user_ = user;
  if (user) {
    
  } else {
    
  }
  // @@protoc_insertion_point(field_set_allocated:mars.stn.UserResult.user)
}

// .mars.stn.UserResultCode code = 2;
void UserResult::clear_code() {
  code_ = 0;
}
::mars::stn::UserResultCode UserResult::code() const {
  // @@protoc_insertion_point(field_get:mars.stn.UserResult.code)
  return static_cast< ::mars::stn::UserResultCode >(code_);
}
void UserResult::set_code(::mars::stn::UserResultCode value) {
  
  code_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.UserResult.code)
}

#endif  // PROTOBUF_INLINE_NOT_IN_HEADERS

// ===================================================================

#if !defined(_MSC_VER) || _MSC_VER >= 1900
const int PullUserResult::kResultFieldNumber;
#endif  // !defined(_MSC_VER) || _MSC_VER >= 1900

PullUserResult::PullUserResult()
  : ::google::protobuf::Message(), _internal_metadata_(NULL) {
  if (GOOGLE_PREDICT_TRUE(this != internal_default_instance())) {
    protobuf_pull_5fuser_5fresponse_2eproto::InitDefaults();
  }
  SharedCtor();
  // @@protoc_insertion_point(constructor:mars.stn.PullUserResult)
}
PullUserResult::PullUserResult(const PullUserResult& from)
  : ::google::protobuf::Message(),
      _internal_metadata_(NULL),
      result_(from.result_),
      _cached_size_(0) {
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  // @@protoc_insertion_point(copy_constructor:mars.stn.PullUserResult)
}

void PullUserResult::SharedCtor() {
  _cached_size_ = 0;
}

PullUserResult::~PullUserResult() {
  // @@protoc_insertion_point(destructor:mars.stn.PullUserResult)
  SharedDtor();
}

void PullUserResult::SharedDtor() {
}

void PullUserResult::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* PullUserResult::descriptor() {
  protobuf_pull_5fuser_5fresponse_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fuser_5fresponse_2eproto::file_level_metadata[kIndexInFileMessages].descriptor;
}

const PullUserResult& PullUserResult::default_instance() {
  protobuf_pull_5fuser_5fresponse_2eproto::InitDefaults();
  return *internal_default_instance();
}

PullUserResult* PullUserResult::New(::google::protobuf::Arena* arena) const {
  PullUserResult* n = new PullUserResult;
  if (arena != NULL) {
    arena->Own(n);
  }
  return n;
}

void PullUserResult::Clear() {
// @@protoc_insertion_point(message_clear_start:mars.stn.PullUserResult)
  result_.Clear();
}

bool PullUserResult::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!GOOGLE_PREDICT_TRUE(EXPRESSION)) goto failure
  ::google::protobuf::uint32 tag;
  // @@protoc_insertion_point(parse_start:mars.stn.PullUserResult)
  for (;;) {
    ::std::pair< ::google::protobuf::uint32, bool> p = input->ReadTagWithCutoffNoLastTag(127u);
    tag = p.first;
    if (!p.second) goto handle_unusual;
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // repeated .mars.stn.UserResult result = 1;
      case 1: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(10u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
                input, add_result()));
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
  // @@protoc_insertion_point(parse_success:mars.stn.PullUserResult)
  return true;
failure:
  // @@protoc_insertion_point(parse_failure:mars.stn.PullUserResult)
  return false;
#undef DO_
}

void PullUserResult::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // @@protoc_insertion_point(serialize_start:mars.stn.PullUserResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // repeated .mars.stn.UserResult result = 1;
  for (unsigned int i = 0, n = this->result_size(); i < n; i++) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      1, this->result(i), output);
  }

  // @@protoc_insertion_point(serialize_end:mars.stn.PullUserResult)
}

::google::protobuf::uint8* PullUserResult::InternalSerializeWithCachedSizesToArray(
    bool deterministic, ::google::protobuf::uint8* target) const {
  // @@protoc_insertion_point(serialize_to_array_start:mars.stn.PullUserResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // repeated .mars.stn.UserResult result = 1;
  for (unsigned int i = 0, n = this->result_size(); i < n; i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      InternalWriteMessageNoVirtualToArray(
        1, this->result(i), deterministic, target);
  }

  // @@protoc_insertion_point(serialize_to_array_end:mars.stn.PullUserResult)
  return target;
}

size_t PullUserResult::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:mars.stn.PullUserResult)
  size_t total_size = 0;

  // repeated .mars.stn.UserResult result = 1;
  {
    unsigned int count = this->result_size();
    total_size += 1UL * count;
    for (unsigned int i = 0; i < count; i++) {
      total_size +=
        ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
          this->result(i));
    }
  }

  int cached_size = ::google::protobuf::internal::ToCachedSize(total_size);
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = cached_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void PullUserResult::MergeFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_merge_from_start:mars.stn.PullUserResult)
  GOOGLE_DCHECK_NE(&from, this);
  const PullUserResult* source =
      ::google::protobuf::internal::DynamicCastToGenerated<const PullUserResult>(
          &from);
  if (source == NULL) {
  // @@protoc_insertion_point(generalized_merge_from_cast_fail:mars.stn.PullUserResult)
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
  // @@protoc_insertion_point(generalized_merge_from_cast_success:mars.stn.PullUserResult)
    MergeFrom(*source);
  }
}

void PullUserResult::MergeFrom(const PullUserResult& from) {
// @@protoc_insertion_point(class_specific_merge_from_start:mars.stn.PullUserResult)
  GOOGLE_DCHECK_NE(&from, this);
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  result_.MergeFrom(from.result_);
}

void PullUserResult::CopyFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_copy_from_start:mars.stn.PullUserResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void PullUserResult::CopyFrom(const PullUserResult& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:mars.stn.PullUserResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool PullUserResult::IsInitialized() const {
  return true;
}

void PullUserResult::Swap(PullUserResult* other) {
  if (other == this) return;
  InternalSwap(other);
}
void PullUserResult::InternalSwap(PullUserResult* other) {
  result_.InternalSwap(&other->result_);
  std::swap(_cached_size_, other->_cached_size_);
}

::google::protobuf::Metadata PullUserResult::GetMetadata() const {
  protobuf_pull_5fuser_5fresponse_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fuser_5fresponse_2eproto::file_level_metadata[kIndexInFileMessages];
}

#if PROTOBUF_INLINE_NOT_IN_HEADERS
// PullUserResult

// repeated .mars.stn.UserResult result = 1;
int PullUserResult::result_size() const {
  return result_.size();
}
void PullUserResult::clear_result() {
  result_.Clear();
}
const ::mars::stn::UserResult& PullUserResult::result(int index) const {
  // @@protoc_insertion_point(field_get:mars.stn.PullUserResult.result)
  return result_.Get(index);
}
::mars::stn::UserResult* PullUserResult::mutable_result(int index) {
  // @@protoc_insertion_point(field_mutable:mars.stn.PullUserResult.result)
  return result_.Mutable(index);
}
::mars::stn::UserResult* PullUserResult::add_result() {
  // @@protoc_insertion_point(field_add:mars.stn.PullUserResult.result)
  return result_.Add();
}
::google::protobuf::RepeatedPtrField< ::mars::stn::UserResult >*
PullUserResult::mutable_result() {
  // @@protoc_insertion_point(field_mutable_list:mars.stn.PullUserResult.result)
  return &result_;
}
const ::google::protobuf::RepeatedPtrField< ::mars::stn::UserResult >&
PullUserResult::result() const {
  // @@protoc_insertion_point(field_list:mars.stn.PullUserResult.result)
  return result_;
}

#endif  // PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)

}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)
