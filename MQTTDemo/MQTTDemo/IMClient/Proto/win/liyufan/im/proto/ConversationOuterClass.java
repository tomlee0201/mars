// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: conversation.proto

package win.liyufan.im.proto;

public final class ConversationOuterClass {
  private ConversationOuterClass() {}
  public static void registerAllExtensions(
      com.google.protobuf.ExtensionRegistryLite registry) {
  }

  public static void registerAllExtensions(
      com.google.protobuf.ExtensionRegistry registry) {
    registerAllExtensions(
        (com.google.protobuf.ExtensionRegistryLite) registry);
  }
  /**
   * Protobuf enum {@code proto.ConversationType}
   */
  public enum ConversationType
      implements com.google.protobuf.ProtocolMessageEnum {
    /**
     * <code>ConversationType_Private = 0;</code>
     */
    ConversationType_Private(0),
    /**
     * <code>ConversationType_Group = 1;</code>
     */
    ConversationType_Group(1),
    /**
     * <code>ConversationType_System = 2;</code>
     */
    ConversationType_System(2),
    /**
     * <code>ConversationType_ChatRoom = 3;</code>
     */
    ConversationType_ChatRoom(3),
    /**
     * <code>ConversationType_Command = 4;</code>
     */
    ConversationType_Command(4),
    UNRECOGNIZED(-1),
    ;

    /**
     * <code>ConversationType_Private = 0;</code>
     */
    public static final int ConversationType_Private_VALUE = 0;
    /**
     * <code>ConversationType_Group = 1;</code>
     */
    public static final int ConversationType_Group_VALUE = 1;
    /**
     * <code>ConversationType_System = 2;</code>
     */
    public static final int ConversationType_System_VALUE = 2;
    /**
     * <code>ConversationType_ChatRoom = 3;</code>
     */
    public static final int ConversationType_ChatRoom_VALUE = 3;
    /**
     * <code>ConversationType_Command = 4;</code>
     */
    public static final int ConversationType_Command_VALUE = 4;


    public final int getNumber() {
      if (this == UNRECOGNIZED) {
        throw new java.lang.IllegalArgumentException(
            "Can't get the number of an unknown enum value.");
      }
      return value;
    }

    /**
     * @deprecated Use {@link #forNumber(int)} instead.
     */
    @java.lang.Deprecated
    public static ConversationType valueOf(int value) {
      return forNumber(value);
    }

    public static ConversationType forNumber(int value) {
      switch (value) {
        case 0: return ConversationType_Private;
        case 1: return ConversationType_Group;
        case 2: return ConversationType_System;
        case 3: return ConversationType_ChatRoom;
        case 4: return ConversationType_Command;
        default: return null;
      }
    }

    public static com.google.protobuf.Internal.EnumLiteMap<ConversationType>
        internalGetValueMap() {
      return internalValueMap;
    }
    private static final com.google.protobuf.Internal.EnumLiteMap<
        ConversationType> internalValueMap =
          new com.google.protobuf.Internal.EnumLiteMap<ConversationType>() {
            public ConversationType findValueByNumber(int number) {
              return ConversationType.forNumber(number);
            }
          };

    public final com.google.protobuf.Descriptors.EnumValueDescriptor
        getValueDescriptor() {
      return getDescriptor().getValues().get(ordinal());
    }
    public final com.google.protobuf.Descriptors.EnumDescriptor
        getDescriptorForType() {
      return getDescriptor();
    }
    public static final com.google.protobuf.Descriptors.EnumDescriptor
        getDescriptor() {
      return win.liyufan.im.proto.ConversationOuterClass.getDescriptor().getEnumTypes().get(0);
    }

    private static final ConversationType[] VALUES = values();

    public static ConversationType valueOf(
        com.google.protobuf.Descriptors.EnumValueDescriptor desc) {
      if (desc.getType() != getDescriptor()) {
        throw new java.lang.IllegalArgumentException(
          "EnumValueDescriptor is not for this type.");
      }
      if (desc.getIndex() == -1) {
        return UNRECOGNIZED;
      }
      return VALUES[desc.getIndex()];
    }

    private final int value;

    private ConversationType(int value) {
      this.value = value;
    }

    // @@protoc_insertion_point(enum_scope:proto.ConversationType)
  }

  public interface ConversationOrBuilder extends
      // @@protoc_insertion_point(interface_extends:proto.Conversation)
      com.google.protobuf.MessageOrBuilder {

    /**
     * <code>.proto.ConversationType type = 1;</code>
     */
    int getTypeValue();
    /**
     * <code>.proto.ConversationType type = 1;</code>
     */
    win.liyufan.im.proto.ConversationOuterClass.ConversationType getType();

    /**
     * <code>string target = 2;</code>
     */
    java.lang.String getTarget();
    /**
     * <code>string target = 2;</code>
     */
    com.google.protobuf.ByteString
        getTargetBytes();
  }
  /**
   * Protobuf type {@code proto.Conversation}
   */
  public  static final class Conversation extends
      com.google.protobuf.GeneratedMessageV3 implements
      // @@protoc_insertion_point(message_implements:proto.Conversation)
      ConversationOrBuilder {
    // Use Conversation.newBuilder() to construct.
    private Conversation(com.google.protobuf.GeneratedMessageV3.Builder<?> builder) {
      super(builder);
    }
    private Conversation() {
      type_ = 0;
      target_ = "";
    }

    @java.lang.Override
    public final com.google.protobuf.UnknownFieldSet
    getUnknownFields() {
      return com.google.protobuf.UnknownFieldSet.getDefaultInstance();
    }
    private Conversation(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
      this();
      int mutable_bitField0_ = 0;
      try {
        boolean done = false;
        while (!done) {
          int tag = input.readTag();
          switch (tag) {
            case 0:
              done = true;
              break;
            default: {
              if (!input.skipField(tag)) {
                done = true;
              }
              break;
            }
            case 8: {
              int rawValue = input.readEnum();

              type_ = rawValue;
              break;
            }
            case 18: {
              java.lang.String s = input.readStringRequireUtf8();

              target_ = s;
              break;
            }
          }
        }
      } catch (com.google.protobuf.InvalidProtocolBufferException e) {
        throw e.setUnfinishedMessage(this);
      } catch (java.io.IOException e) {
        throw new com.google.protobuf.InvalidProtocolBufferException(
            e).setUnfinishedMessage(this);
      } finally {
        makeExtensionsImmutable();
      }
    }
    public static final com.google.protobuf.Descriptors.Descriptor
        getDescriptor() {
      return win.liyufan.im.proto.ConversationOuterClass.internal_static_proto_Conversation_descriptor;
    }

    protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
        internalGetFieldAccessorTable() {
      return win.liyufan.im.proto.ConversationOuterClass.internal_static_proto_Conversation_fieldAccessorTable
          .ensureFieldAccessorsInitialized(
              win.liyufan.im.proto.ConversationOuterClass.Conversation.class, win.liyufan.im.proto.ConversationOuterClass.Conversation.Builder.class);
    }

    public static final int TYPE_FIELD_NUMBER = 1;
    private int type_;
    /**
     * <code>.proto.ConversationType type = 1;</code>
     */
    public int getTypeValue() {
      return type_;
    }
    /**
     * <code>.proto.ConversationType type = 1;</code>
     */
    public win.liyufan.im.proto.ConversationOuterClass.ConversationType getType() {
      win.liyufan.im.proto.ConversationOuterClass.ConversationType result = win.liyufan.im.proto.ConversationOuterClass.ConversationType.valueOf(type_);
      return result == null ? win.liyufan.im.proto.ConversationOuterClass.ConversationType.UNRECOGNIZED : result;
    }

    public static final int TARGET_FIELD_NUMBER = 2;
    private volatile java.lang.Object target_;
    /**
     * <code>string target = 2;</code>
     */
    public java.lang.String getTarget() {
      java.lang.Object ref = target_;
      if (ref instanceof java.lang.String) {
        return (java.lang.String) ref;
      } else {
        com.google.protobuf.ByteString bs = 
            (com.google.protobuf.ByteString) ref;
        java.lang.String s = bs.toStringUtf8();
        target_ = s;
        return s;
      }
    }
    /**
     * <code>string target = 2;</code>
     */
    public com.google.protobuf.ByteString
        getTargetBytes() {
      java.lang.Object ref = target_;
      if (ref instanceof java.lang.String) {
        com.google.protobuf.ByteString b = 
            com.google.protobuf.ByteString.copyFromUtf8(
                (java.lang.String) ref);
        target_ = b;
        return b;
      } else {
        return (com.google.protobuf.ByteString) ref;
      }
    }

    private byte memoizedIsInitialized = -1;
    public final boolean isInitialized() {
      byte isInitialized = memoizedIsInitialized;
      if (isInitialized == 1) return true;
      if (isInitialized == 0) return false;

      memoizedIsInitialized = 1;
      return true;
    }

    public void writeTo(com.google.protobuf.CodedOutputStream output)
                        throws java.io.IOException {
      if (type_ != win.liyufan.im.proto.ConversationOuterClass.ConversationType.ConversationType_Private.getNumber()) {
        output.writeEnum(1, type_);
      }
      if (!getTargetBytes().isEmpty()) {
        com.google.protobuf.GeneratedMessageV3.writeString(output, 2, target_);
      }
    }

    public int getSerializedSize() {
      int size = memoizedSize;
      if (size != -1) return size;

      size = 0;
      if (type_ != win.liyufan.im.proto.ConversationOuterClass.ConversationType.ConversationType_Private.getNumber()) {
        size += com.google.protobuf.CodedOutputStream
          .computeEnumSize(1, type_);
      }
      if (!getTargetBytes().isEmpty()) {
        size += com.google.protobuf.GeneratedMessageV3.computeStringSize(2, target_);
      }
      memoizedSize = size;
      return size;
    }

    private static final long serialVersionUID = 0L;
    @java.lang.Override
    public boolean equals(final java.lang.Object obj) {
      if (obj == this) {
       return true;
      }
      if (!(obj instanceof win.liyufan.im.proto.ConversationOuterClass.Conversation)) {
        return super.equals(obj);
      }
      win.liyufan.im.proto.ConversationOuterClass.Conversation other = (win.liyufan.im.proto.ConversationOuterClass.Conversation) obj;

      boolean result = true;
      result = result && type_ == other.type_;
      result = result && getTarget()
          .equals(other.getTarget());
      return result;
    }

    @java.lang.Override
    public int hashCode() {
      if (memoizedHashCode != 0) {
        return memoizedHashCode;
      }
      int hash = 41;
      hash = (19 * hash) + getDescriptor().hashCode();
      hash = (37 * hash) + TYPE_FIELD_NUMBER;
      hash = (53 * hash) + type_;
      hash = (37 * hash) + TARGET_FIELD_NUMBER;
      hash = (53 * hash) + getTarget().hashCode();
      hash = (29 * hash) + unknownFields.hashCode();
      memoizedHashCode = hash;
      return hash;
    }

    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        java.nio.ByteBuffer data)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        java.nio.ByteBuffer data,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data, extensionRegistry);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        com.google.protobuf.ByteString data)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        com.google.protobuf.ByteString data,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data, extensionRegistry);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(byte[] data)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        byte[] data,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws com.google.protobuf.InvalidProtocolBufferException {
      return PARSER.parseFrom(data, extensionRegistry);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(java.io.InputStream input)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseWithIOException(PARSER, input);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        java.io.InputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseWithIOException(PARSER, input, extensionRegistry);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseDelimitedFrom(java.io.InputStream input)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseDelimitedWithIOException(PARSER, input);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseDelimitedFrom(
        java.io.InputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseDelimitedWithIOException(PARSER, input, extensionRegistry);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        com.google.protobuf.CodedInputStream input)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseWithIOException(PARSER, input);
    }
    public static win.liyufan.im.proto.ConversationOuterClass.Conversation parseFrom(
        com.google.protobuf.CodedInputStream input,
        com.google.protobuf.ExtensionRegistryLite extensionRegistry)
        throws java.io.IOException {
      return com.google.protobuf.GeneratedMessageV3
          .parseWithIOException(PARSER, input, extensionRegistry);
    }

    public Builder newBuilderForType() { return newBuilder(); }
    public static Builder newBuilder() {
      return DEFAULT_INSTANCE.toBuilder();
    }
    public static Builder newBuilder(win.liyufan.im.proto.ConversationOuterClass.Conversation prototype) {
      return DEFAULT_INSTANCE.toBuilder().mergeFrom(prototype);
    }
    public Builder toBuilder() {
      return this == DEFAULT_INSTANCE
          ? new Builder() : new Builder().mergeFrom(this);
    }

    @java.lang.Override
    protected Builder newBuilderForType(
        com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
      Builder builder = new Builder(parent);
      return builder;
    }
    /**
     * Protobuf type {@code proto.Conversation}
     */
    public static final class Builder extends
        com.google.protobuf.GeneratedMessageV3.Builder<Builder> implements
        // @@protoc_insertion_point(builder_implements:proto.Conversation)
        win.liyufan.im.proto.ConversationOuterClass.ConversationOrBuilder {
      public static final com.google.protobuf.Descriptors.Descriptor
          getDescriptor() {
        return win.liyufan.im.proto.ConversationOuterClass.internal_static_proto_Conversation_descriptor;
      }

      protected com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
          internalGetFieldAccessorTable() {
        return win.liyufan.im.proto.ConversationOuterClass.internal_static_proto_Conversation_fieldAccessorTable
            .ensureFieldAccessorsInitialized(
                win.liyufan.im.proto.ConversationOuterClass.Conversation.class, win.liyufan.im.proto.ConversationOuterClass.Conversation.Builder.class);
      }

      // Construct using win.liyufan.im.proto.ConversationOuterClass.Conversation.newBuilder()
      private Builder() {
        maybeForceBuilderInitialization();
      }

      private Builder(
          com.google.protobuf.GeneratedMessageV3.BuilderParent parent) {
        super(parent);
        maybeForceBuilderInitialization();
      }
      private void maybeForceBuilderInitialization() {
        if (com.google.protobuf.GeneratedMessageV3
                .alwaysUseFieldBuilders) {
        }
      }
      public Builder clear() {
        super.clear();
        type_ = 0;

        target_ = "";

        return this;
      }

      public com.google.protobuf.Descriptors.Descriptor
          getDescriptorForType() {
        return win.liyufan.im.proto.ConversationOuterClass.internal_static_proto_Conversation_descriptor;
      }

      public win.liyufan.im.proto.ConversationOuterClass.Conversation getDefaultInstanceForType() {
        return win.liyufan.im.proto.ConversationOuterClass.Conversation.getDefaultInstance();
      }

      public win.liyufan.im.proto.ConversationOuterClass.Conversation build() {
        win.liyufan.im.proto.ConversationOuterClass.Conversation result = buildPartial();
        if (!result.isInitialized()) {
          throw newUninitializedMessageException(result);
        }
        return result;
      }

      public win.liyufan.im.proto.ConversationOuterClass.Conversation buildPartial() {
        win.liyufan.im.proto.ConversationOuterClass.Conversation result = new win.liyufan.im.proto.ConversationOuterClass.Conversation(this);
        result.type_ = type_;
        result.target_ = target_;
        onBuilt();
        return result;
      }

      public Builder clone() {
        return (Builder) super.clone();
      }
      public Builder setField(
          com.google.protobuf.Descriptors.FieldDescriptor field,
          Object value) {
        return (Builder) super.setField(field, value);
      }
      public Builder clearField(
          com.google.protobuf.Descriptors.FieldDescriptor field) {
        return (Builder) super.clearField(field);
      }
      public Builder clearOneof(
          com.google.protobuf.Descriptors.OneofDescriptor oneof) {
        return (Builder) super.clearOneof(oneof);
      }
      public Builder setRepeatedField(
          com.google.protobuf.Descriptors.FieldDescriptor field,
          int index, Object value) {
        return (Builder) super.setRepeatedField(field, index, value);
      }
      public Builder addRepeatedField(
          com.google.protobuf.Descriptors.FieldDescriptor field,
          Object value) {
        return (Builder) super.addRepeatedField(field, value);
      }
      public Builder mergeFrom(com.google.protobuf.Message other) {
        if (other instanceof win.liyufan.im.proto.ConversationOuterClass.Conversation) {
          return mergeFrom((win.liyufan.im.proto.ConversationOuterClass.Conversation)other);
        } else {
          super.mergeFrom(other);
          return this;
        }
      }

      public Builder mergeFrom(win.liyufan.im.proto.ConversationOuterClass.Conversation other) {
        if (other == win.liyufan.im.proto.ConversationOuterClass.Conversation.getDefaultInstance()) return this;
        if (other.type_ != 0) {
          setTypeValue(other.getTypeValue());
        }
        if (!other.getTarget().isEmpty()) {
          target_ = other.target_;
          onChanged();
        }
        onChanged();
        return this;
      }

      public final boolean isInitialized() {
        return true;
      }

      public Builder mergeFrom(
          com.google.protobuf.CodedInputStream input,
          com.google.protobuf.ExtensionRegistryLite extensionRegistry)
          throws java.io.IOException {
        win.liyufan.im.proto.ConversationOuterClass.Conversation parsedMessage = null;
        try {
          parsedMessage = PARSER.parsePartialFrom(input, extensionRegistry);
        } catch (com.google.protobuf.InvalidProtocolBufferException e) {
          parsedMessage = (win.liyufan.im.proto.ConversationOuterClass.Conversation) e.getUnfinishedMessage();
          throw e.unwrapIOException();
        } finally {
          if (parsedMessage != null) {
            mergeFrom(parsedMessage);
          }
        }
        return this;
      }

      private int type_ = 0;
      /**
       * <code>.proto.ConversationType type = 1;</code>
       */
      public int getTypeValue() {
        return type_;
      }
      /**
       * <code>.proto.ConversationType type = 1;</code>
       */
      public Builder setTypeValue(int value) {
        type_ = value;
        onChanged();
        return this;
      }
      /**
       * <code>.proto.ConversationType type = 1;</code>
       */
      public win.liyufan.im.proto.ConversationOuterClass.ConversationType getType() {
        win.liyufan.im.proto.ConversationOuterClass.ConversationType result = win.liyufan.im.proto.ConversationOuterClass.ConversationType.valueOf(type_);
        return result == null ? win.liyufan.im.proto.ConversationOuterClass.ConversationType.UNRECOGNIZED : result;
      }
      /**
       * <code>.proto.ConversationType type = 1;</code>
       */
      public Builder setType(win.liyufan.im.proto.ConversationOuterClass.ConversationType value) {
        if (value == null) {
          throw new NullPointerException();
        }
        
        type_ = value.getNumber();
        onChanged();
        return this;
      }
      /**
       * <code>.proto.ConversationType type = 1;</code>
       */
      public Builder clearType() {
        
        type_ = 0;
        onChanged();
        return this;
      }

      private java.lang.Object target_ = "";
      /**
       * <code>string target = 2;</code>
       */
      public java.lang.String getTarget() {
        java.lang.Object ref = target_;
        if (!(ref instanceof java.lang.String)) {
          com.google.protobuf.ByteString bs =
              (com.google.protobuf.ByteString) ref;
          java.lang.String s = bs.toStringUtf8();
          target_ = s;
          return s;
        } else {
          return (java.lang.String) ref;
        }
      }
      /**
       * <code>string target = 2;</code>
       */
      public com.google.protobuf.ByteString
          getTargetBytes() {
        java.lang.Object ref = target_;
        if (ref instanceof String) {
          com.google.protobuf.ByteString b = 
              com.google.protobuf.ByteString.copyFromUtf8(
                  (java.lang.String) ref);
          target_ = b;
          return b;
        } else {
          return (com.google.protobuf.ByteString) ref;
        }
      }
      /**
       * <code>string target = 2;</code>
       */
      public Builder setTarget(
          java.lang.String value) {
        if (value == null) {
    throw new NullPointerException();
  }
  
        target_ = value;
        onChanged();
        return this;
      }
      /**
       * <code>string target = 2;</code>
       */
      public Builder clearTarget() {
        
        target_ = getDefaultInstance().getTarget();
        onChanged();
        return this;
      }
      /**
       * <code>string target = 2;</code>
       */
      public Builder setTargetBytes(
          com.google.protobuf.ByteString value) {
        if (value == null) {
    throw new NullPointerException();
  }
  checkByteStringIsUtf8(value);
        
        target_ = value;
        onChanged();
        return this;
      }
      public final Builder setUnknownFields(
          final com.google.protobuf.UnknownFieldSet unknownFields) {
        return this;
      }

      public final Builder mergeUnknownFields(
          final com.google.protobuf.UnknownFieldSet unknownFields) {
        return this;
      }


      // @@protoc_insertion_point(builder_scope:proto.Conversation)
    }

    // @@protoc_insertion_point(class_scope:proto.Conversation)
    private static final win.liyufan.im.proto.ConversationOuterClass.Conversation DEFAULT_INSTANCE;
    static {
      DEFAULT_INSTANCE = new win.liyufan.im.proto.ConversationOuterClass.Conversation();
    }

    public static win.liyufan.im.proto.ConversationOuterClass.Conversation getDefaultInstance() {
      return DEFAULT_INSTANCE;
    }

    private static final com.google.protobuf.Parser<Conversation>
        PARSER = new com.google.protobuf.AbstractParser<Conversation>() {
      public Conversation parsePartialFrom(
          com.google.protobuf.CodedInputStream input,
          com.google.protobuf.ExtensionRegistryLite extensionRegistry)
          throws com.google.protobuf.InvalidProtocolBufferException {
          return new Conversation(input, extensionRegistry);
      }
    };

    public static com.google.protobuf.Parser<Conversation> parser() {
      return PARSER;
    }

    @java.lang.Override
    public com.google.protobuf.Parser<Conversation> getParserForType() {
      return PARSER;
    }

    public win.liyufan.im.proto.ConversationOuterClass.Conversation getDefaultInstanceForType() {
      return DEFAULT_INSTANCE;
    }

  }

  private static final com.google.protobuf.Descriptors.Descriptor
    internal_static_proto_Conversation_descriptor;
  private static final 
    com.google.protobuf.GeneratedMessageV3.FieldAccessorTable
      internal_static_proto_Conversation_fieldAccessorTable;

  public static com.google.protobuf.Descriptors.FileDescriptor
      getDescriptor() {
    return descriptor;
  }
  private static  com.google.protobuf.Descriptors.FileDescriptor
      descriptor;
  static {
    java.lang.String[] descriptorData = {
      "\n\022conversation.proto\022\005proto\"E\n\014Conversat" +
      "ion\022%\n\004type\030\001 \001(\0162\027.proto.ConversationTy" +
      "pe\022\016\n\006target\030\002 \001(\t*\246\001\n\020ConversationType\022" +
      "\034\n\030ConversationType_Private\020\000\022\032\n\026Convers" +
      "ationType_Group\020\001\022\033\n\027ConversationType_Sy" +
      "stem\020\002\022\035\n\031ConversationType_ChatRoom\020\003\022\034\n" +
      "\030ConversationType_Command\020\004B.\n\024win.liyuf" +
      "an.im.protoB\026ConversationOuterClassb\006pro" +
      "to3"
    };
    com.google.protobuf.Descriptors.FileDescriptor.InternalDescriptorAssigner assigner =
        new com.google.protobuf.Descriptors.FileDescriptor.    InternalDescriptorAssigner() {
          public com.google.protobuf.ExtensionRegistry assignDescriptors(
              com.google.protobuf.Descriptors.FileDescriptor root) {
            descriptor = root;
            return null;
          }
        };
    com.google.protobuf.Descriptors.FileDescriptor
      .internalBuildGeneratedFileFrom(descriptorData,
        new com.google.protobuf.Descriptors.FileDescriptor[] {
        }, assigner);
    internal_static_proto_Conversation_descriptor =
      getDescriptor().getMessageTypes().get(0);
    internal_static_proto_Conversation_fieldAccessorTable = new
      com.google.protobuf.GeneratedMessageV3.FieldAccessorTable(
        internal_static_proto_Conversation_descriptor,
        new java.lang.String[] { "Type", "Target", });
  }

  // @@protoc_insertion_point(outer_class_scope)
}
