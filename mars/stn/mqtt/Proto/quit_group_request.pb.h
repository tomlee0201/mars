// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: quit_group_request.proto

#ifndef PROTOBUF_quit_5fgroup_5frequest_2eproto__INCLUDED
#define PROTOBUF_quit_5fgroup_5frequest_2eproto__INCLUDED

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
#include "message_content.pb.h"
// @@protoc_insertion_point(includes)
namespace mars {
namespace stn {
class MessageContent;
class MessageContentDefaultTypeInternal;
extern MessageContentDefaultTypeInternal _MessageContent_default_instance_;
class QuitGroupRequest;
class QuitGroupRequestDefaultTypeInternal;
extern QuitGroupRequestDefaultTypeInternal _QuitGroupRequest_default_instance_;
}  // namespace stn
}  // namespace mars

namespace mars {
namespace stn {

namespace protobuf_quit_5fgroup_5frequest_2eproto {
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
}  // namespace protobuf_quit_5fgroup_5frequest_2eproto

// ===================================================================

class QuitGroupRequest : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:mars.stn.QuitGroupRequest) */ {
 public:
  QuitGroupRequest();
  virtual ~QuitGroupRequest();

  QuitGroupRequest(const QuitGroupRequest& from);

  inline QuitGroupRequest& operator=(const QuitGroupRequest& from) {
    CopyFrom(from);
    return *this;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const QuitGroupRequest& default_instance();

  static inline const QuitGroupRequest* internal_default_instance() {
    return reinterpret_cast<const QuitGroupRequest*>(
               &_QuitGroupRequest_default_instance_);
  }
  static PROTOBUF_CONSTEXPR int const kIndexInFileMessages =
    0;

  void Swap(QuitGroupRequest* other);

  // implements Message ----------------------------------------------

  inline QuitGroupRequest* New() const PROTOBUF_FINAL { return New(NULL); }

  QuitGroupRequest* New(::google::protobuf::Arena* arena) const PROTOBUF_FINAL;
  void CopyFrom(const ::google::protobuf::Message& from) PROTOBUF_FINAL;
  void MergeFrom(const ::google::protobuf::Message& from) PROTOBUF_FINAL;
  void CopyFrom(const QuitGroupRequest& from);
  void MergeFrom(const QuitGroupRequest& from);
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
  void InternalSwap(QuitGroupRequest* other);
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

  // string group_id = 1;
  void clear_group_id();
  static const int kGroupIdFieldNumber = 1;
  const ::std::string& group_id() const;
  void set_group_id(const ::std::string& value);
  #if LANG_CXX11
  void set_group_id(::std::string&& value);
  #endif
  void set_group_id(const char* value);
  void set_group_id(const char* value, size_t size);
  ::std::string* mutable_group_id();
  ::std::string* release_group_id();
  void set_allocated_group_id(::std::string* group_id);

  // .mars.stn.MessageContent notify_content = 3;
  bool has_notify_content() const;
  void clear_notify_content();
  static const int kNotifyContentFieldNumber = 3;
  const ::mars::stn::MessageContent& notify_content() const;
  ::mars::stn::MessageContent* mutable_notify_content();
  ::mars::stn::MessageContent* release_notify_content();
  void set_allocated_notify_content(::mars::stn::MessageContent* notify_content);

  // int32 line = 2;
  void clear_line();
  static const int kLineFieldNumber = 2;
  ::google::protobuf::int32 line() const;
  void set_line(::google::protobuf::int32 value);

  // @@protoc_insertion_point(class_scope:mars.stn.QuitGroupRequest)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  ::google::protobuf::internal::ArenaStringPtr group_id_;
  ::mars::stn::MessageContent* notify_content_;
  ::google::protobuf::int32 line_;
  mutable int _cached_size_;
  friend struct protobuf_quit_5fgroup_5frequest_2eproto::TableStruct;
};
// ===================================================================


// ===================================================================

#if !PROTOBUF_INLINE_NOT_IN_HEADERS
// QuitGroupRequest

// string group_id = 1;
inline void QuitGroupRequest::clear_group_id() {
  group_id_.ClearToEmptyNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline const ::std::string& QuitGroupRequest::group_id() const {
  // @@protoc_insertion_point(field_get:mars.stn.QuitGroupRequest.group_id)
  return group_id_.GetNoArena();
}
inline void QuitGroupRequest::set_group_id(const ::std::string& value) {
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), value);
  // @@protoc_insertion_point(field_set:mars.stn.QuitGroupRequest.group_id)
}
#if LANG_CXX11
inline void QuitGroupRequest::set_group_id(::std::string&& value) {
  
  group_id_.SetNoArena(
    &::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::move(value));
  // @@protoc_insertion_point(field_set_rvalue:mars.stn.QuitGroupRequest.group_id)
}
#endif
inline void QuitGroupRequest::set_group_id(const char* value) {
  GOOGLE_DCHECK(value != NULL);
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), ::std::string(value));
  // @@protoc_insertion_point(field_set_char:mars.stn.QuitGroupRequest.group_id)
}
inline void QuitGroupRequest::set_group_id(const char* value, size_t size) {
  
  group_id_.SetNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(),
      ::std::string(reinterpret_cast<const char*>(value), size));
  // @@protoc_insertion_point(field_set_pointer:mars.stn.QuitGroupRequest.group_id)
}
inline ::std::string* QuitGroupRequest::mutable_group_id() {
  
  // @@protoc_insertion_point(field_mutable:mars.stn.QuitGroupRequest.group_id)
  return group_id_.MutableNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline ::std::string* QuitGroupRequest::release_group_id() {
  // @@protoc_insertion_point(field_release:mars.stn.QuitGroupRequest.group_id)
  
  return group_id_.ReleaseNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited());
}
inline void QuitGroupRequest::set_allocated_group_id(::std::string* group_id) {
  if (group_id != NULL) {
    
  } else {
    
  }
  group_id_.SetAllocatedNoArena(&::google::protobuf::internal::GetEmptyStringAlreadyInited(), group_id);
  // @@protoc_insertion_point(field_set_allocated:mars.stn.QuitGroupRequest.group_id)
}

// int32 line = 2;
inline void QuitGroupRequest::clear_line() {
  line_ = 0;
}
inline ::google::protobuf::int32 QuitGroupRequest::line() const {
  // @@protoc_insertion_point(field_get:mars.stn.QuitGroupRequest.line)
  return line_;
}
inline void QuitGroupRequest::set_line(::google::protobuf::int32 value) {
  
  line_ = value;
  // @@protoc_insertion_point(field_set:mars.stn.QuitGroupRequest.line)
}

// .mars.stn.MessageContent notify_content = 3;
inline bool QuitGroupRequest::has_notify_content() const {
  return this != internal_default_instance() && notify_content_ != NULL;
}
inline void QuitGroupRequest::clear_notify_content() {
  if (GetArenaNoVirtual() == NULL && notify_content_ != NULL) delete notify_content_;
  notify_content_ = NULL;
}
inline const ::mars::stn::MessageContent& QuitGroupRequest::notify_content() const {
  // @@protoc_insertion_point(field_get:mars.stn.QuitGroupRequest.notify_content)
  return notify_content_ != NULL ? *notify_content_
                         : *::mars::stn::MessageContent::internal_default_instance();
}
inline ::mars::stn::MessageContent* QuitGroupRequest::mutable_notify_content() {
  
  if (notify_content_ == NULL) {
    notify_content_ = new ::mars::stn::MessageContent;
  }
  // @@protoc_insertion_point(field_mutable:mars.stn.QuitGroupRequest.notify_content)
  return notify_content_;
}
inline ::mars::stn::MessageContent* QuitGroupRequest::release_notify_content() {
  // @@protoc_insertion_point(field_release:mars.stn.QuitGroupRequest.notify_content)
  
  ::mars::stn::MessageContent* temp = notify_content_;
  notify_content_ = NULL;
  return temp;
}
inline void QuitGroupRequest::set_allocated_notify_content(::mars::stn::MessageContent* notify_content) {
  delete notify_content_;
  notify_content_ = notify_content;
  if (notify_content) {
    
  } else {
    
  }
  // @@protoc_insertion_point(field_set_allocated:mars.stn.QuitGroupRequest.notify_content)
}

#endif  // !PROTOBUF_INLINE_NOT_IN_HEADERS

// @@protoc_insertion_point(namespace_scope)


}  // namespace stn
}  // namespace mars

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_quit_5fgroup_5frequest_2eproto__INCLUDED
