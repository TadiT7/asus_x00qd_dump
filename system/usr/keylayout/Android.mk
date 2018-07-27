LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
$(shell mkdir -p $(TARGET_OUT)/bin; \
	cp -a $(LOCAL_PATH)/* $(TARGET_OUT)/usr/keylayout/)
	
