// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: add_group_member_request.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "add_group_member_request.pb.h"

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
class AddGroupMemberRequestDefaultTypeInternal : public ::google::protobuf::internal::ExplicitlyConstructed<AddGroupMemberRequest> {
} _AddGroupMemberRequest_default_instance_;

namespace protobuf_add_5fgroup_5fmember_5frequest_2eproto {


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
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(AddGroupMemberRequest, _internal_metadata_),
  ~0u,  // no _extensions_
  ~0u,  // no _oneof_case_
  ~0u,  // no _weak_field_map_
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(AddGroupMemberRequest, group_id_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(AddGroupMemberRequest, added_member_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(AddGroupMemberRequest, to_line_),
  GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(AddGroupMemberRequest, notify_content_),
};

static const ::google::protobuf::internal::MigrationSchema schemas[] = {
  { 0, -1, sizeof(AddGroupMemberRequest)},
};

static ::google::protobuf::Message const * const file_default_instances[] = {
  reinterpret_cast<const ::google::protobuf::Message*>(&_AddGroupMemberRequest_default_instance_),
};

namespace {

void protobuf_AssignDescriptors() {
  AddDescriptors();
  ::google::protobuf::MessageFactory* factory = NULL;
  AssignDescriptors(
      "add_group_member_request.proto", schemas, file_default_instances, TableStruct::offsets, factory,
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
  _AddGroupMemberRequest_default_instance_.Shutdown();
  delete file_level_metadata[0].reflection;
}

void TableStruct::InitDefaultsImpl() {
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::internal::InitProtobufDefaults();
  ::mars::stn::protobuf_message_5fcontent_2eproto::InitDefaults();
  ::mars::stn::protobuf_group_2eproto::InitDefaults();
  _AddGroupMemberRequest_default_instance_.DefaultConstruct();
  _AddGroupMemberRequest_default_instance_.get_mutable()->notify_content_ = const_cast< ::mars::stn::MessageContent*>(
      ::mars::stn::MessageContent::internal_default_instance());
}

void InitDefaults() {
  static GOOGLE_PROTOBUF_DECLARE_ONCE(once);
  ::google::protobuf::GoogleOnceInit(&once, &TableStruct::InitDefaultsImpl);
}
void AddDescriptorsImpl() {
  InitDefaults();
  static const char descriptor[] = {
      "\n\036add_group_member_request.proto\022\010mars.s"
      "tn\032\025message_content.proto\032\013group.proto\"\231"
      "\001\n\025AddGroupMemberRequest\022\020\n\010group_id\030\001 \001"
      "(\t\022+\n\014added_member\030\002 \003(\0132\025.mars.stn.Grou"
      "pMember\022\017\n\007to_line\030\003 \003(\005\0220\n\016notify_conte"
      "nt\030\004 \001(\0132\030.mars.stn.MessageContentB7\n\024wi"
      "n.liyufan.im.protoB\037AddGroupMemberReques"
      "tOuterClassb\006proto3"
  };
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
      descriptor, 299);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "add_group_member_request.proto", &protobuf_RegisterTypes);
  ::mars::stn::protobuf_message_5fcontent_2eproto::AddDescriptors();
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

}  // namespace protobuf_add_5fgroup_5fmember_5frequest_2eproto


// ===================================================================

#if !defined(_MSC_VER) || _MSC_VER >= 1900
const int AddGroupMemberRequest::kGroupIdFieldNumber;
const int AddGroupMemberRequest::kAddedMemberFieldNumber;
const int AddGroupMemberRequest::kToLineFieldNumber;
const int AddGroupMemberRequest::kNotifyContentFieldNumber;
#endif  // !defined(_MSC_VER) || _MSC_VER >= 1900

AddGroupMemberRequest::AddGroupMemberRequest()
  : ::google::protobuf::Message(), _internal_metadata_(NULL) {
  if (GOOGLE_PREDICT_TRUE(this != internal_default_instance())) {
    protobuf_add_5fgroup_5fmember_5frequest_2eproto::InitDefaults();
  }
  SharedCtor();
  // @@protoc_insertion_point(constructor:mars.stn.AddGroupMemberRequest)
}
AddGroupMemberRequest::AddGroupMemberRequest(const AddGroupMemberRequest& from)
  : ::google::protobuf::Message(),
      _internal_metadata_(NULL),
      added_member_(from.added_member_),
      to_line_(from.to_line_),
      _cached_size_(0) {
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  group_id_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (from.group_id().size() > 0) {
    group_id_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.group_id_);
  }
  if (from.has_notify_content()) {
    notify_content_ = new ::mars::stn::MessageContent(*from.notify_content_);
  } else {
    notify_content_ = NULL;
  }
  // @@protoc_insertion_point(copy_constructor:mars.stn.AddGroupMemberRequest)
}

void AddGroupMemberRequest::SharedCtor() {
  group_id_.UnsafeSetDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  notify_content_ = NULL;
  _cached_size_ = 0;
}

AddGroupMemberRequest::~AddGroupMemberRequest() {
  // @@protoc_insertion_point(destructor:mars.stn.AddGroupMemberRequest)
  SharedDtor();
}

void AddGroupMemberRequest::SharedDtor() {
  group_id_.DestroyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (this != internal_default_instance()) {
    delete notify_content_;
  }
}

void AddGroupMemberRequest::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* AddGroupMemberRequest::descriptor() {
  protobuf_add_5fgroup_5fmember_5frequest_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_add_5fgroup_5fmember_5frequest_2eproto::file_level_metadata[kIndexInFileMessages].descriptor;
}

const AddGroupMemberRequest& AddGroupMemberRequest::default_instance() {
  protobuf_add_5fgroup_5fmember_5frequest_2eproto::InitDefaults();
  return *internal_default_instance();
}

AddGroupMemberRequest* AddGroupMemberRequest::New(::google::protobuf::Arena* arena) const {
  AddGroupMemberRequest* n = new AddGroupMemberRequest;
  if (arena != NULL) {
    arena->Own(n);
  }
  return n;
}

void AddGroupMemberRequest::Clear() {
// @@protoc_insertion_point(message_clear_start:mars.stn.AddGroupMemberRequest)
  added_member_.Clear();
  to_line_.Clear();
  group_id_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
  if (GetArenaNoVirtual() == NULL && notify_content_ != NULL) {
    delete notify_content_;
  }
  notify_content_ = NULL;
}

bool AddGroupMemberRequest::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!GOOGLE_PREDICT_TRUE(EXPRESSION)) goto failure
  ::google::protobuf::uint32 tag;
  // @@protoc_insertion_point(parse_start:mars.stn.AddGroupMemberRequest)
  for (;;) {
    ::std::pair< ::google::protobuf::uint32, bool> p = input->ReadTagWithCutoffNoLastTag(127u);
    tag = p.first;
    if (!p.second) goto handle_unusual;
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // string group_id = 1;
      case 1: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(10u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_group_id()));
          DO_(::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            this->group_id().data(), this->group_id().length(),
            ::google::protobuf::internal::WireFormatLite::PARSE,
            "mars.stn.AddGroupMemberRequest.group_id"));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // repeated .mars.stn.GroupMember added_member = 2;
      case 2: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(18u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
                input, add_added_member()));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // repeated int32 to_line = 3;
      case 3: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(26u)) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadPackedPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, this->mutable_to_line())));
        } else if (static_cast< ::google::protobuf::uint8>(tag) ==
                   static_cast< ::google::protobuf::uint8>(24u)) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadRepeatedPrimitiveNoInline<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 1, 26u, input, this->mutable_to_line())));
        } else {
          goto handle_unusual;
        }
        break;
      }

      // .mars.stn.MessageContent notify_content = 4;
      case 4: {
        if (static_cast< ::google::protobuf::uint8>(tag) ==
            static_cast< ::google::protobuf::uint8>(34u)) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
               input, mutable_notify_content()));
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
  // @@protoc_insertion_point(parse_success:mars.stn.AddGroupMemberRequest)
  return true;
failure:
  // @@protoc_insertion_point(parse_failure:mars.stn.AddGroupMemberRequest)
  return false;
#undef DO_
}

void AddGroupMemberRequest::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // @@protoc_insertion_point(serialize_start:mars.stn.AddGroupMemberRequest)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // string group_id = 1;
  if (this->group_id().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->group_id().data(), this->group_id().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.AddGroupMemberRequest.group_id");
    ::google::protobuf::internal::WireFormatLite::WriteStringMaybeAliased(
      1, this->group_id(), output);
  }

  // repeated .mars.stn.GroupMember added_member = 2;
  for (unsigned int i = 0, n = this->added_member_size(); i < n; i++) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      2, this->added_member(i), output);
  }

  // repeated int32 to_line = 3;
  if (this->to_line_size() > 0) {
    ::google::protobuf::internal::WireFormatLite::WriteTag(3, ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED, output);
    output->WriteVarint32(_to_line_cached_byte_size_);
  }
  for (int i = 0, n = this->to_line_size(); i < n; i++) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32NoTag(
      this->to_line(i), output);
  }

  // .mars.stn.MessageContent notify_content = 4;
  if (this->has_notify_content()) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      4, *this->notify_content_, output);
  }

  // @@protoc_insertion_point(serialize_end:mars.stn.AddGroupMemberRequest)
}

::google::protobuf::uint8* AddGroupMemberRequest::InternalSerializeWithCachedSizesToArray(
    bool deterministic, ::google::protobuf::uint8* target) const {
  // @@protoc_insertion_point(serialize_to_array_start:mars.stn.AddGroupMemberRequest)
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  // string group_id = 1;
  if (this->group_id().size() > 0) {
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
      this->group_id().data(), this->group_id().length(),
      ::google::protobuf::internal::WireFormatLite::SERIALIZE,
      "mars.stn.AddGroupMemberRequest.group_id");
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        1, this->group_id(), target);
  }

  // repeated .mars.stn.GroupMember added_member = 2;
  for (unsigned int i = 0, n = this->added_member_size(); i < n; i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      InternalWriteMessageNoVirtualToArray(
        2, this->added_member(i), deterministic, target);
  }

  // repeated int32 to_line = 3;
  if (this->to_line_size() > 0) {
    target = ::google::protobuf::internal::WireFormatLite::WriteTagToArray(
      3,
      ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED,
      target);
    target = ::google::protobuf::io::CodedOutputStream::WriteVarint32ToArray(
      _to_line_cached_byte_size_, target);
    target = ::google::protobuf::internal::WireFormatLite::
      WriteInt32NoTagToArray(this->to_line_, target);
  }

  // .mars.stn.MessageContent notify_content = 4;
  if (this->has_notify_content()) {
    target = ::google::protobuf::internal::WireFormatLite::
      InternalWriteMessageNoVirtualToArray(
        4, *this->notify_content_, deterministic, target);
  }

  // @@protoc_insertion_point(serialize_to_array_end:mars.stn.AddGroupMemberRequest)
  return target;
}

size_t AddGroupMemberRequest::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:mars.stn.AddGroupMemberRequest)
  size_t total_size = 0;

  // repeated .mars.stn.GroupMember added_member = 2;
  {
    unsigned int count = this->added_member_size();
    total_size += 1UL * count;
    for (unsigned int i = 0; i < count; i++) {
      total_size +=
        ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
          this->added_member(i));
    }
  }

  // repeated int32 to_line = 3;
  {
    size_t data_size = ::google::protobuf::internal::WireFormatLite::
      Int32Size(this->to_line_);
    if (data_size > 0) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(data_size);
    }
    int cached_size = ::google::protobuf::internal::ToCachedSize(data_size);
    GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
    _to_line_cached_byte_size_ = cached_size;
    GOOGLE_SAFE_CONCURRENT_WRITES_END();
    total_size += data_size;
  }

  // string group_id = 1;
  if (this->group_id().size() > 0) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::StringSize(
        this->group_id());
  }

  // .mars.stn.MessageContent notify_content = 4;
  if (this->has_notify_content()) {
    total_size += 1 +
      ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
        *this->notify_content_);
  }

  int cached_size = ::google::protobuf::internal::ToCachedSize(total_size);
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = cached_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void AddGroupMemberRequest::MergeFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_merge_from_start:mars.stn.AddGroupMemberRequest)
  GOOGLE_DCHECK_NE(&from, this);
  const AddGroupMemberRequest* source =
      ::google::protobuf::internal::DynamicCastToGenerated<const AddGroupMemberRequest>(
          &from);
  if (source == NULL) {
  // @@protoc_insertion_point(generalized_merge_from_cast_fail:mars.stn.AddGroupMemberRequest)
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
  // @@protoc_insertion_point(generalized_merge_from_cast_success:mars.stn.AddGroupMemberRequest)
    MergeFrom(*source);
  }
}

void AddGroupMemberRequest::MergeFrom(const AddGroupMemberRequest& from) {
// @@protoc_insertion_point(class_specific_merge_from_start:mars.stn.AddGroupMemberRequest)
  GOOGLE_DCHECK_NE(&from, this);
  _internal_metadata_.MergeFrom(from._internal_metadata_);
  ::google::protobuf::uint32 cached_has_bits = 0;
  (void) cached_has_bits;

  added_member_.MergeFrom(from.added_member_);
  to_line_.MergeFrom(from.to_line_);
  if (from.group_id().size() > 0) {

    group_id_.AssignWithDefault(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), from.group_id_);
  }
  if (from.has_notify_content()) {
    mutable_notify_content()->::mars::stn::MessageContent::MergeFrom(from.notify_content());
  }
}

void AddGroupMemberRequest::CopyFrom(const ::google::protobuf::Message& from) {
// @@protoc_insertion_point(generalized_copy_from_start:mars.stn.AddGroupMemberRequest)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void AddGroupMemberRequest::CopyFrom(const AddGroupMemberRequest& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:mars.stn.AddGroupMemberRequest)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool AddGroupMemberRequest::IsInitialized() const {
  return true;
}

void AddGroupMemberRequest::Swap(AddGroupMemberRequest* other) {
  if (other == this) return;
  InternalSwap(other);
}
void AddGroupMemberRequest::InternalSwap(AddGroupMemberRequest* other) {
  added_member_.InternalSwap(&other->added_member_);
  to_line_.InternalSwap(&other->to_line_);
  group_id_.Swap(&other->group_id_);
  std::swap(notify_content_, other->notify_content_);
  std::swap(_cached_size_, other->_cached_size_);
}

::google::protobuf::Metadata AddGroupMemberRequest::GetMetadata() const {
  protobuf_add_5fgroup_5fmember_5frequest_2eproto::protobuf_AssignDescriptorsOnce();
  return protobuf_add_5fgroup_5fmember_5frequest_2eproto::file_level_metadata[kIndexInFileMessages];
}

#if PROTOBUF_INLINE_NOT_IN_HEADERS
// AddGroupMemberRequest

// string group_id = 1;
void AddGroupMemberRequest::clear_group_id() {
  group_id_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
const ::std::string& AddGroupMemberRequest::group_id() const {
  // @@protoc_insertion_point(field_get:mars.stn.AddGroupMemberRequest.group_id)
  return group_id_.GetNoArena();
}
void AddGroupMemberRequest::set_group_id(const ::std::string& value) {
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:mars.stn.AddGroupMemberRequest.group_id)
}
#if LANG_CXX11
void AddGroupMemberRequest::set_group_id(::std::string&& value) {
  
  group_id_.SetNoArena(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value));
  // @@protoc_insertion_point(field_set_rvalue:mars.stn.AddGroupMemberRequest.group_id)
}
#endif
void AddGroupMemberRequest::set_group_id(const char* value) {
  GOOGLE_DCHECK(value != NULL);
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:mars.stn.AddGroupMemberRequest.group_id)
}
void AddGroupMemberRequest::set_group_id(const char* value, size_t size) {
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:mars.stn.AddGroupMemberRequest.group_id)
}
::std::string* AddGroupMemberRequest::mutable_group_id() {
  
  // @@protoc_insertion_point(field_mutable:mars.stn.AddGroupMemberRequest.group_id)
  return group_id_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
::std::string* AddGroupMemberRequest::release_group_id() {
  // @@protoc_insertion_point(field_release:mars.stn.AddGroupMemberRequest.group_id)
  
  return group_id_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
void AddGroupMemberRequest::set_allocated_group_id(::std::string* group_id) {
  if (group_id != NULL) {
    
  } else {
    
  }
  group_id_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), group_id);
  // @@protoc_insertion_point(field_set_allocated:mars.stn.AddGroupMemberRequest.group_id)
}

// repeated .mars.stn.GroupMember added_member = 2;
int AddGroupMemberRequest::added_member_size() const {
  return added_member_.size();
}
void AddGroupMemberRequest::clear_added_member() {
  added_member_.Clear();
}
const ::mars::stn::GroupMember& AddGroupMemberRequest::added_member(int index) const {
  // @@protoc_insertion_point(field_get:mars.stn.AddGroupMemberRequest.added_member)
  return added_member_.Get(index);
}
::mars::stn::GroupMember* AddGroupMemberRequest::mutable_added_member(int index) {
  // @@protoc_insertion_point(field_mutable:mars.stn.AddGroupMemberRequest.added_member)
  return added_member_.Mutable(index);
}
::mars::stn::GroupMember* AddGroupMemberRequest::add_added_member() {
  // @@protoc_insertion_point(field_add:mars.stn.AddGroupMemberRequest.added_member)
  return added_member_.Add();
}
::google::protobuf::RepeatedPtrField< ::mars::stn::GroupMember >*
AddGroupMemberRequest::mutable_added_member() {
  // @@protoc_insertion_point(field_mutable_list:mars.stn.AddGroupMemberRequest.added_member)
  return &added_member_;
}
const ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupMember >&
AddGroupMemberRequest::added_member() const {
  // @@protoc_insertion_point(field_list:mars.stn.AddGroupMemberRequest.added_member)
  return added_member_;
}

// repeated int32 to_line = 3;
int AddGroupMemberRequest::to_line_size() const {
  return to_line_.size();
}
void AddGroupMemberRequest::clear_to_line() {
  to_line_.Clear();
}
::google::protobuf::int32 AddGroupMemberRequest::to_line(int index) const {
  // @@protoc_insertion_point(field_get:mars.stn.AddGroupMemberRequest.to_line)
  return to_line_.Get(index);
}
void AddGroupMemberRequest::set_to_line(int index, ::google::protobuf::int32 value) {
  to_line_.Set(index, value);
  // @@protoc_insertion_point(field_set:mars.stn.AddGroupMemberRequest.to_line)
}
void AddGroupMemberRequest::add_to_line(::google::protobuf::int32 value) {
  to_line_.Add(value);
  // @@protoc_insertion_point(field_add:mars.stn.AddGroupMemberRequest.to_line)
}
const ::google::protobuf::RepeatedField< ::google::protobuf::int32 >&
AddGroupMemberRequest::to_line() const {
  // @@protoc_insertion_point(field_list:mars.stn.AddGroupMemberRequest.to_line)
  return to_line_;
}
::google::protobuf::RepeatedField< ::google::protobuf::int32 >*
AddGroupMemberRequest::mutable_to_line() {
  // @@protoc_insertion_point(field_mutable_list:mars.stn.AddGroupMemberRequest.to_line)
  return &to_line_;
}

// .mars.stn.MessageContent notify_content = 4;
bool AddGroupMemberRequest::has_notify_content() const {
  return this != internal_default_instance() && notify_content_ != NULL;
}
void AddGroupMemberRequest::clear_notify_content() {
  if (GetArenaNoVirtual() == NULL && notify_content_ != NULL) delete notify_content_;
  notify_content_ = NULL;
}
const ::mars::stn::MessageContent& AddGroupMemberRequest::notify_content() const {
  // @@protoc_insertion_point(field_get:mars.stn.AddGroupMemberRequest.notify_content)
  return notify_content_ != NULL ? *notify_content_
                         : *::mars::stn::MessageContent::internal_default_instance();
}
::mars::stn::MessageContent* AddGroupMemberRequest::mutable_notify_content() {
  
  if (notify_content_ == NULL) {
    notify_content_ = new ::mars::stn::MessageContent;
  }
  // @@protoc_insertion_point(field_mutable:mars.stn.AddGroupMemberRequest.notify_content)
  return notify_content_;
}
::mars::stn::MessageContent* AddGroupMemberRequest::release_notify_content() {
  // @@protoc_insertion_point(field_release:mars.stn.AddGroupMemberRequest.notify_content)
  
  ::mars::stn::MessageContent* temp = notify_content_;
  notify_content_ = NULL;
  return temp;
}
void AddGroupMemberRequest::set_allocated_notify_content(::mars::stn::MessageContent* notify_content) {
  delete notify_content_;
  notify_content_ = notify_content;
  if (notify_content) {
    
  } else {
    
  }
  // @@protoc_insertion_point(field_set_allocated:mars.stn.AddGroupMemberRequest.notify_content)
}

#endif  // PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)

}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)
