// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: pull_group_info_result.proto

#ifndef PROTOBUF_pull_5fgroup_5finfo_5fresult_2eproto__INCLUDED
#define PROTOBUF_pull_5fgroup_5finfo_5fresult_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 3003000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 3003000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/arena.h>
#include <google/protobuf/arenastring.h>
#include <google/protobuf/generated_message_table_driven.h>
#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/metadata.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>  // IWYU pragma: export
#include <google/protobuf/extension_set.h>  // IWYU pragma: export
#include <google/protobuf/unknown_field_set.h>
#include "group.pb.h"
// @@protoc_insertion_point(includes)
namespace mars {
namespace stn {
class Group;
class GroupDefaultTypeInternal;
extern GroupDefaultTypeInternal _Group_default_instance_;
class GroupInfo;
class GroupInfoDefaultTypeInternal;
extern GroupInfoDefaultTypeInternal _GroupInfo_default_instance_;
class GroupMember;
class GroupMemberDefaultTypeInternal;
extern GroupMemberDefaultTypeInternal _GroupMember_default_instance_;
class PullGroupInfoResult;
class PullGroupInfoResultDefaultTypeInternal;
extern PullGroupInfoResultDefaultTypeInternal _PullGroupInfoResult_default_instance_;
}  // namespace stn
}  // namespace mars

namespace mars {
namespace stn {

namespace protobuf_pull_5fgroup_5finfo_5fresult_2eproto {
// Internal implementation detail -- do not call these.
struct TableStruct {
  static const ::google::protobuf::internal::ParseTableField entries[];
  static const ::google::protobuf::internal::AuxillaryParseTableField aux[];
  static const ::google::protobuf::internal::ParseTable schema[];
  static const ::google::protobuf::uint32 offsets[];
  static void InitDefaultsImpl();
  static void Shutdown();
};
void AddDescriptors();
void InitDefaults();
}  // namespace protobuf_pull_5fgroup_5finfo_5fresult_2eproto

// ===================================================================

class PullGroupInfoResult : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:mars.stn.PullGroupInfoResult) */ {
 public:
  PullGroupInfoResult();
  virtual ~PullGroupInfoResult();

  PullGroupInfoResult(const PullGroupInfoResult& from);

  inline PullGroupInfoResult& operator=(const PullGroupInfoResult& from) {
    CopyFrom(from);
    return *this;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const PullGroupInfoResult& default_instance();

  static inline const PullGroupInfoResult* internal_default_instance() {
    return reinterpret_cast<const PullGroupInfoResult*>(
               &_PullGroupInfoResult_default_instance_);
  }
  static PROTOBUF_CONSTEXPR int const kIndexInFileMessages =
    0;

  void Swap(PullGroupInfoResult* other);

  // implements Message ----------------------------------------------

  inline PullGroupInfoResult* New() const PROTOBUF_FINAL { return New(NULL); }

  PullGroupInfoResult* New(::google::protobuf::Arena* arena) const PROTOBUF_FINAL;
  void CopyFrom(const ::google::protobuf::Message& from) PROTOBUF_FINAL;
  void MergeFrom(const ::google::protobuf::Message& from) PROTOBUF_FINAL;
  void CopyFrom(const PullGroupInfoResult& from);
  void MergeFrom(const PullGroupInfoResult& from);
  void Clear() PROTOBUF_FINAL;
  bool IsInitialized() const PROTOBUF_FINAL;

  size_t ByteSizeLong() const PROTOBUF_FINAL;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input) PROTOBUF_FINAL;
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const PROTOBUF_FINAL;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* target) const PROTOBUF_FINAL;
  int GetCachedSize() const PROTOBUF_FINAL { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const PROTOBUF_FINAL;
  void InternalSwap(PullGroupInfoResult* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return NULL;
  }
  inline void* MaybeArenaPtr() const {
    return NULL;
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const PROTOBUF_FINAL;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // repeated .mars.stn.GroupInfo info = 1;
  int info_size() const;
  void clear_info();
  static const int kInfoFieldNumber = 1;
  const ::mars::stn::GroupInfo& info(int index) const;
  ::mars::stn::GroupInfo* mutable_info(int index);
  ::mars::stn::GroupInfo* add_info();
  ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >*
      mutable_info();
  const ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >&
      info() const;

  // @@protoc_insertion_point(class_scope:mars.stn.PullGroupInfoResult)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo > info_;
  mutable int _cached_size_;
  friend struct protobuf_pull_5fgroup_5finfo_5fresult_2eproto::TableStruct;
};
// ===================================================================


// ===================================================================

#if !PROTOBUF_INLINE_NOT_IN_HEADERS
// PullGroupInfoResult

// repeated .mars.stn.GroupInfo info = 1;
inline int PullGroupInfoResult::info_size() const {
  return info_.size();
}
inline void PullGroupInfoResult::clear_info() {
  info_.Clear();
}
inline const ::mars::stn::GroupInfo& PullGroupInfoResult::info(int index) const {
  // @@protoc_insertion_point(field_get:mars.stn.PullGroupInfoResult.info)
  return info_.Get(index);
}
inline ::mars::stn::GroupInfo* PullGroupInfoResult::mutable_info(int index) {
  // @@protoc_insertion_point(field_mutable:mars.stn.PullGroupInfoResult.info)
  return info_.Mutable(index);
}
inline ::mars::stn::GroupInfo* PullGroupInfoResult::add_info() {
  // @@protoc_insertion_point(field_add:mars.stn.PullGroupInfoResult.info)
  return info_.Add();
}
inline ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >*
PullGroupInfoResult::mutable_info() {
  // @@protoc_insertion_point(field_mutable_list:mars.stn.PullGroupInfoResult.info)
  return &info_;
}
inline const ::google::protobuf::RepeatedPtrField< ::mars::stn::GroupInfo >&
PullGroupInfoResult::info() const {
  // @@protoc_insertion_point(field_list:mars.stn.PullGroupInfoResult.info)
  return info_;
}

#endif  // !PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)


}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_pull_5fgroup_5finfo_5fresult_2eproto__INCLUDED
