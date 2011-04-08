find_library( SIMPLECONTACTLIST_LIBRARIES simplecontactlist PATHS ${QUTIM_PATH}/lib )
message (${SIMPLECONTACTLIST_LIBRARIES})

qutim_add_plugin(simplecontactlistwidget
	EXTENSION
	EXTENSION_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/sevenwidget.h
	EXTENSION_CLASS Core::SimpleContactList::SimpleWidget
	DISPLAY_NAME "Seven"
	SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}
	DESCRIPTION "Windows seven specific implementation with button's in caption"
	LINK_LIBRARIES ${SIMPLECONTACTLIST_LIBRARIES}
)
