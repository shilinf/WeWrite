// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: WeWriteProtocal.proto

#ifndef PROTOBUF_WeWriteProtocal_2eproto__INCLUDED
#define PROTOBUF_WeWriteProtocal_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 2005000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 2005000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/generated_enum_reflection.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

namespace WeWrite {

// Internal implementation detail -- do not call these.
void  protobuf_AddDesc_WeWriteProtocal_2eproto();
void protobuf_AssignDesc_WeWriteProtocal_2eproto();
void protobuf_ShutdownFile_WeWriteProtocal_2eproto();

class Event;

enum Event_EventType {
  Event_EventType_UNKNOWN = 0,
  Event_EventType_INSERT = 1,
  Event_EventType_DELETE = 2,
  Event_EventType_UNDO = 3,
  Event_EventType_REDO = 4,
  Event_EventType_ACKNOWLEGEMENT = 5
};
bool Event_EventType_IsValid(int value);
const Event_EventType Event_EventType_EventType_MIN = Event_EventType_UNKNOWN;
const Event_EventType Event_EventType_EventType_MAX = Event_EventType_ACKNOWLEGEMENT;
const int Event_EventType_EventType_ARRAYSIZE = Event_EventType_EventType_MAX + 1;

const ::google::protobuf::EnumDescriptor* Event_EventType_descriptor();
inline const ::std::string& Event_EventType_Name(Event_EventType value) {
  return ::google::protobuf::internal::NameOfEnum(
    Event_EventType_descriptor(), value);
}
inline bool Event_EventType_Parse(
    const ::std::string& name, Event_EventType* value) {
  return ::google::protobuf::internal::ParseNamedEnum<Event_EventType>(
    Event_EventType_descriptor(), name, value);
}
// ===================================================================

class Event : public ::google::protobuf::Message {
 public:
  Event();
  virtual ~Event();

  Event(const Event& from);

  inline Event& operator=(const Event& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const Event& default_instance();

  void Swap(Event* other);

  // implements Message ----------------------------------------------

  Event* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const Event& from);
  void MergeFrom(const Event& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  typedef Event_EventType EventType;
  static const EventType UNKNOWN = Event_EventType_UNKNOWN;
  static const EventType INSERT = Event_EventType_INSERT;
  static const EventType DELETE = Event_EventType_DELETE;
  static const EventType UNDO = Event_EventType_UNDO;
  static const EventType REDO = Event_EventType_REDO;
  static const EventType ACKNOWLEGEMENT = Event_EventType_ACKNOWLEGEMENT;
  static inline bool EventType_IsValid(int value) {
    return Event_EventType_IsValid(value);
  }
  static const EventType EventType_MIN =
    Event_EventType_EventType_MIN;
  static const EventType EventType_MAX =
    Event_EventType_EventType_MAX;
  static const int EventType_ARRAYSIZE =
    Event_EventType_EventType_ARRAYSIZE;
  static inline const ::google::protobuf::EnumDescriptor*
  EventType_descriptor() {
    return Event_EventType_descriptor();
  }
  static inline const ::std::string& EventType_Name(EventType value) {
    return Event_EventType_Name(value);
  }
  static inline bool EventType_Parse(const ::std::string& name,
      EventType* value) {
    return Event_EventType_Parse(name, value);
  }

  // accessors -------------------------------------------------------

  // required int64 orderId = 1;
  inline bool has_orderid() const;
  inline void clear_orderid();
  static const int kOrderIdFieldNumber = 1;
  inline ::google::protobuf::int64 orderid() const;
  inline void set_orderid(::google::protobuf::int64 value);

  // optional .WeWrite.Event.EventType eventType = 2 [default = UNKNOWN];
  inline bool has_eventtype() const;
  inline void clear_eventtype();
  static const int kEventTypeFieldNumber = 2;
  inline ::WeWrite::Event_EventType eventtype() const;
  inline void set_eventtype(::WeWrite::Event_EventType value);

  // optional int32 location = 3;
  inline bool has_location() const;
  inline void clear_location();
  static const int kLocationFieldNumber = 3;
  inline ::google::protobuf::int32 location() const;
  inline void set_location(::google::protobuf::int32 value);

  // optional string content = 4;
  inline bool has_content() const;
  inline void clear_content();
  static const int kContentFieldNumber = 4;
  inline const ::std::string& content() const;
  inline void set_content(const ::std::string& value);
  inline void set_content(const char* value);
  inline void set_content(const char* value, size_t size);
  inline ::std::string* mutable_content();
  inline ::std::string* release_content();
  inline void set_allocated_content(::std::string* content);

  // @@protoc_insertion_point(class_scope:WeWrite.Event)
 private:
  inline void set_has_orderid();
  inline void clear_has_orderid();
  inline void set_has_eventtype();
  inline void clear_has_eventtype();
  inline void set_has_location();
  inline void clear_has_location();
  inline void set_has_content();
  inline void clear_has_content();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int64 orderid_;
  int eventtype_;
  ::google::protobuf::int32 location_;
  ::std::string* content_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(4 + 31) / 32];

  friend void  protobuf_AddDesc_WeWriteProtocal_2eproto();
  friend void protobuf_AssignDesc_WeWriteProtocal_2eproto();
  friend void protobuf_ShutdownFile_WeWriteProtocal_2eproto();

  void InitAsDefaultInstance();
  static Event* default_instance_;
};
// ===================================================================


// ===================================================================

// Event

// required int64 orderId = 1;
inline bool Event::has_orderid() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void Event::set_has_orderid() {
  _has_bits_[0] |= 0x00000001u;
}
inline void Event::clear_has_orderid() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void Event::clear_orderid() {
  orderid_ = GOOGLE_LONGLONG(0);
  clear_has_orderid();
}
inline ::google::protobuf::int64 Event::orderid() const {
  return orderid_;
}
inline void Event::set_orderid(::google::protobuf::int64 value) {
  set_has_orderid();
  orderid_ = value;
}

// optional .WeWrite.Event.EventType eventType = 2 [default = UNKNOWN];
inline bool Event::has_eventtype() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void Event::set_has_eventtype() {
  _has_bits_[0] |= 0x00000002u;
}
inline void Event::clear_has_eventtype() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void Event::clear_eventtype() {
  eventtype_ = 0;
  clear_has_eventtype();
}
inline ::WeWrite::Event_EventType Event::eventtype() const {
  return static_cast< ::WeWrite::Event_EventType >(eventtype_);
}
inline void Event::set_eventtype(::WeWrite::Event_EventType value) {
  assert(::WeWrite::Event_EventType_IsValid(value));
  set_has_eventtype();
  eventtype_ = value;
}

// optional int32 location = 3;
inline bool Event::has_location() const {
  return (_has_bits_[0] & 0x00000004u) != 0;
}
inline void Event::set_has_location() {
  _has_bits_[0] |= 0x00000004u;
}
inline void Event::clear_has_location() {
  _has_bits_[0] &= ~0x00000004u;
}
inline void Event::clear_location() {
  location_ = 0;
  clear_has_location();
}
inline ::google::protobuf::int32 Event::location() const {
  return location_;
}
inline void Event::set_location(::google::protobuf::int32 value) {
  set_has_location();
  location_ = value;
}

// optional string content = 4;
inline bool Event::has_content() const {
  return (_has_bits_[0] & 0x00000008u) != 0;
}
inline void Event::set_has_content() {
  _has_bits_[0] |= 0x00000008u;
}
inline void Event::clear_has_content() {
  _has_bits_[0] &= ~0x00000008u;
}
inline void Event::clear_content() {
  if (content_ != &::google::protobuf::internal::kEmptyString) {
    content_->clear();
  }
  clear_has_content();
}
inline const ::std::string& Event::content() const {
  return *content_;
}
inline void Event::set_content(const ::std::string& value) {
  set_has_content();
  if (content_ == &::google::protobuf::internal::kEmptyString) {
    content_ = new ::std::string;
  }
  content_->assign(value);
}
inline void Event::set_content(const char* value) {
  set_has_content();
  if (content_ == &::google::protobuf::internal::kEmptyString) {
    content_ = new ::std::string;
  }
  content_->assign(value);
}
inline void Event::set_content(const char* value, size_t size) {
  set_has_content();
  if (content_ == &::google::protobuf::internal::kEmptyString) {
    content_ = new ::std::string;
  }
  content_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* Event::mutable_content() {
  set_has_content();
  if (content_ == &::google::protobuf::internal::kEmptyString) {
    content_ = new ::std::string;
  }
  return content_;
}
inline ::std::string* Event::release_content() {
  clear_has_content();
  if (content_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = content_;
    content_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void Event::set_allocated_content(::std::string* content) {
  if (content_ != &::google::protobuf::internal::kEmptyString) {
    delete content_;
  }
  if (content) {
    set_has_content();
    content_ = content;
  } else {
    clear_has_content();
    content_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace WeWrite

#ifndef SWIG
namespace google {
namespace protobuf {

template <>
inline const EnumDescriptor* GetEnumDescriptor< ::WeWrite::Event_EventType>() {
  return ::WeWrite::Event_EventType_descriptor();
}

}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_WeWriteProtocal_2eproto__INCLUDED
