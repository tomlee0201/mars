// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: pull_group_member_result.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "pull_group_member_result.pb.h"

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
class PullGroupMemberResultDefaultTypeInternal : public ::google::protobuf::internal::ExplicitlyConstructed<PullGroupMemberResult> {
} _PullGroupMemberResult_default_instance_;

namespace protobuf_pull_5fgroup_5fmember_5fresult_2eproto {


namespace {

::google::protobuf::Metadata file_level_metadata[1];

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
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PullGroupMemberResult, _internal_metadata_),
  ~0u,  // no _extensions_
  ~0u,  // no _oneof_case_
  ~0u,  // no _weak_field_map_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PullGroupMemberResult, member_),
};

static const ::google::protobuf::internal::MigrationSchema schemas[] = {
  { 0, -1, sizeof(PullGroupMemberResult)},
};

static ::google::protobuf::Message const * const file_default_instances[] = {
  reinterpret_cast<const ::google::protobuf::Message*>(&_PullGroupMemberResult_default_instance_),
};

namespace {

void protobuf_AssignDescriptors() {
  AddDescriptors();
  ::google::protobuf::MessageFactory* factory = NULL;
  AssignDescriptors(
      "pull_group_member_result.proto", schemas, file_default_instances, TableStruct::offsets, factory,
      file_level_metadata, NULL, NULL);
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
  _PullGroupMemberResult_default_instance_.Shutdown();
  delete file_level_metadata[0].reflection;
}

void TableStruct::InitDefaultsImpl() {
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::internal::InitProtobufDefaults();
  ::mars::stn::protobuf_group_2eproto::InitDefaults();
  _PullGroupMemberResult_default_instance_.DefaultConstruct();
}

void InitDefaults() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &TableStruct::InitDefaultsImpl);
}
void AddDescriptorsImpl() {
  InitDefaults();
  static const char descriptor[] = {
      "\n\036pull_group_member_result.proto\022\010mars.s"
      "tn\032\013group.proto\">\n\025PullGroupMemberResult"
      "\022%\n\006member\030\001 \003(\0132\025.mars.stn.GroupMemberB"
      "7\n\024win.liyufan.im.protoB\037PullGroupMember"
      "ResultOuterClassb\006proto3"
  };
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
      descriptor, 184);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "pull_group_member_result.proto", &protobuf_RegisterTypes);
  ::mars::stn::protobuf_group_2eproto::AddDescriptors();
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

}  // namespace protobuf_pull_5fgroup_5fmember_5fresult_2eproto


// ===================================================================

#if !defined(_MSC_VER) || _MSC_VER >= 1900
const int PullGroupMemberResult::kMemberFieldNumber;
#endif  // !defined(_MSC_VER) || _MSC_VER >= 1900

PullGroupMemberResult::PullGroupMemberResult()
  : ::google::protobuf::Message(), _internal_metadata_(NULL) {
  if (GOOGLE_PREDICT_TRUE(this != internal_default_instance())) {
    protobuf_pull_5fgroup_5fmember_5fresult_2eproto::InitDefaults();
  }
  SharedCtor();
  // @@protoc_insertion_point(constructor:mars.stn.PullGroupMemberResult)
}
PullGroupMemberResult::PullGroupMemberResult(const PullGroupMemberResult& from)
  : ::google::protobuf::Message(),
      _internal_metadata_(NULL),
      member_(from.member_),
      _cached_size_(0) {
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  // @@protoc_insertion_point(copy_constructor:mars.stn.PullGroupMemberResult)
}

void PullGroupMemberResult::SharedCtor() {
  _cached_size_ = 0;
}

PullGroupMemberResult::~PullGroupMemberResult() {
  // @@protoc_insertion_point(destructor:mars.stn.PullGroupMemberResult)
  SharedDtor();
}

void PullGroupMemberResult::SharedDtor() {
}

void PullGroupMemberResult::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* PullGroupMemberResult::descriptor() {
  protobuf_pull_5fgroup_5fmember_5fresult_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fgroup_5fmember_5fresult_2eproto::file_level_metadata[kIndexInFileMessages].descriptor;
}

const PullGroupMemberResult& PullGroupMemberResult::default_instance() {
  protobuf_pull_5fgroup_5fmember_5fresult_2eproto::InitDefaults();
  return *internal_default_instance();
}

PullGroupMemberResult* PullGroupMemberResult::New(::google::protobuf::Arena* arena) const {
  PullGroupMemberResult* n = new PullGroupMemberResult;
  if (arena != NULL) {
    arena->Own(n);
  }
  return n;
}

void PullGroupMemberResult::Clear() {
// @@protoc_insertion_point(message_clear_start:mars.stn.PullGroupMemberResult)
  member_.Clear();
}

bool PullGroupMemberResult::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!GOOGLE_PREDICT_TRUE(EXPRESSION)) goto failure
  ::google::protobuf::uint32 tag;
  // @@protoc_insertion_point(parse_start:mars.stn.PullGroupMemberResult)
  for (;;) {
    ::std::pair< ::google::protobuf::uint32, bool> p = input->ReadTagWithCutoffNoLastTag(127u);
    tag = p.first;
    if (!p.second) goto handle_unusual;
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // repeated .mars.stn.GroupMember member = 1;
      case 1: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(10u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
                input, add_member()));
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
  // @@protoc_insertion_point(parse_success:mars.stn.PullGroupMemberResult)
  return true;
failure:
  // @@protoc_insertion_point(parse_failure:mars.stn.PullGroupMemberResult)
  return false;
#undef DO_
}

void PullGroupMemberResult::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // @@protoc_insertion_point(serialize_start:mars.stn.PullGroupMemberResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // repeated .mars.stn.GroupMember member = 1;
  for (unsigned int i = 0, n = this->member_size(); i < n; i++) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      1, this->member(i), output);
  }

  // @@protoc_insertion_point(serialize_end:mars.stn.PullGroupMemberResult)
}

::google::protobuf::uint8* PullGroupMemberResult::InternalSerializeWithCachedSizesToArray(
    bool deterministic, ::google::protobuf::uint8* target) const {
  // @@protoc_insertion_point(serialize_to_array_start:mars.stn.PullGroupMemberResult)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // repeated .mars.stn.GroupMember member = 1;
  for (unsigned int i = 0, n = this->member_size(); i < n; i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      InternalWriteMessageNoVirtualToArray(
        1, this->member(i), deterministic, target);
  }

  // @@protoc_insertion_point(serialize_to_array_end:mars.stn.PullGroupMemberResult)
  return target;
}

size_t PullGroupMemberResult::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:mars.stn.PullGroupMemberResult)
  size_t total_size = 0;

  // repeated .mars.stn.GroupMember member = 1;
  {
    unsigned int count = this->member_size();
    total_size += 1UL * count;
    for (unsigned int i = 0; i < count; i++) {
      total_size +=
        ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
          this->member(i));
    }
  }

  int cached_size = ::google::protobuf::internal::ToCachedSize(total_size);
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = cached_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void PullGroupMemberResult::MergeFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_merge_from_start:mars.stn.PullGroupMemberResult)
  GOOGLE_DCHECK_NE(&from, this);
  const PullGroupMemberResult* source =
      ::google::protobuf::internal::DynamicCastToGenerated<const PullGroupMemberResult>(
          &from);
  if (source == NULL) {
  // @@protoc_insertion_point(generalized_merge_from_cast_fail:mars.stn.PullGroupMemberResult)
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
  // @@protoc_insertion_point(generalized_merge_from_cast_success:mars.stn.PullGroupMemberResult)
    MergeFrom(*source);
  }
}

void PullGroupMemberResult::MergeFrom(const PullGroupMemberResult& from) {
// @@protoc_insertion_point(class_specific_merge_from_start:mars.stn.PullGroupMemberResult)
  GOOGLE_DCHECK_NE(&from, this);
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  member_.MergeFrom(from.member_);
}

void PullGroupMemberResult::CopyFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_copy_from_start:mars.stn.PullGroupMemberResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void PullGroupMemberResult::CopyFrom(const PullGroupMemberResult& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:mars.stn.PullGroupMemberResult)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool PullGroupMemberResult::IsInitialized() const {
  return true;
}

void PullGroupMemberResult::Swap(PullGroupMemberResult* other) {
  if (other == this) return;
  InternalSwap(other);
}
void PullGroupMemberResult::InternalSwap(PullGroupMemberResult* other) {
  member_.InternalSwap(&other->member_);
  std::swap(_cached_size_, other->_cached_size_);
}

::google::protobuf::Metadata PullGroupMemberResult::GetMetadata() const {
  protobuf_pull_5fgroup_5fmember_5fresult_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_pull_5fgroup_5fmember_5fresult_2eproto::file_level_metadata[kIndexInFileMessages];
}

#if PROTOBUF_INLINE_NOT_IN_HEADERS
// PullGroupMemberResult

// repeated .mars.stn.GroupMember member = 1;
int PullGroupMemberResult::member_size() const {
  return member_.size();
}
void PullGroupMemberResult::clear_member() {
  member_.Clear();
}
const ::mars::stn::GroupMember& PullGroupMemberResult::member(int index) const {
  // @@protoc_insertion_point(field_get:mars.stn.PullGroupMemberResult.member)
  return member_.Get(index);
}
::mars::stn::GroupMember* PullGroupMemberResult::mutable_member(int index) {
  // @@protoc_insertion_point(field_mutable:mars.stn.PullGroupMemberResult.member)
  return member_.Mutable(index);
}
::mars::stn::GroupMember* PullGroupMemberResult::add_member() {
  // @@protoc_insertion_point(field_add:mars.stn.PullGroupMemberResult.member)
  return member_.Add();
}
::google::protobuf::RepeatedPtrField< ::mars::stn::GroupMember >*
PullGroupMemberResult::mutable_member() {
  // @@protoc_insertion_point(field_mutable_list:mars.stn.PullGroupMemberResult.member)
  return &member_;
}
const ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupMember >&
PullGroupMemberResult::member() const {
  // @@protoc_insertion_point(field_list:mars.stn.PullGroupMemberResult.member)
  return member_;
}

#endif  // PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)

}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)
