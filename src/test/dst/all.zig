pub const PES = @import("PackedEnumSet").PackedEnumSet;
pub const PointClippingBehavior = enum(u32) {
    all_clip_planes = 0,
    user_clip_planes_only = 1,
    max_enum = 2147483647,
    const Self = @This();
    pub const user_clip_planes_only_khr = Self.user_clip_planes_only;
    pub const all_clip_planes_khr = Self.all_clip_planes;
};
pub const StructureType = enum(u32) {
    semaphore_create_info = 9,
    export_semaphore_create_info = 1000077000,
    const Self = @This();
    pub const export_semaphore_create_info_khr = Self.export_semaphore_create_info;
};
pub const Result = enum(i32) {
    error_not_enough_space_khr = -1000483000,
    error_compression_exhausted_ext = -1000338000,
    error_invalid_video_std_parameters_khr = -1000299000,
    error_invalid_device_address_ext = -1000257000,
    error_full_screen_exclusive_mode_lost_ext = -1000255000,
    error_not_permitted = -1000174001,
    error_fragmentation = -1000161000,
    error_invalid_drm_format_modifier_plane_layout_ext = -1000158000,
    error_invalid_external_handle = -1000072003,
    error_out_of_pool_memory = -1000069000,
    error_video_std_version_not_supported_khr = -1000023005,
    error_video_profile_codec_not_supported_khr = -1000023004,
    error_video_profile_format_not_supported_khr = -1000023003,
    error_video_profile_operation_not_supported_khr = -1000023002,
    error_video_picture_layout_not_supported_khr = -1000023001,
    error_image_usage_not_supported_khr = -1000023000,
    error_invalid_shader_nv = -1000012000,
    error_validation_failed_ext = -1000011001,
    error_incompatible_display_khr = -1000003001,
    error_out_of_date_khr = -1000001004,
    error_native_window_in_use_khr = -1000000001,
    error_surface_lost_khr = -1000000000,
    error_unknown = -13,
    error_fragmented_pool = -12,
    error_format_not_supported = -11,
    error_too_many_objects = -10,
    error_incompatible_driver = -9,
    error_feature_not_present = -8,
    error_extension_not_present = -7,
    error_layer_not_present = -6,
    error_memory_map_failed = -5,
    error_device_lost = -4,
    error_initialization_failed = -3,
    error_out_of_device_memory = -2,
    error_out_of_host_memory = -1,
    success = 0,
    not_ready = 1,
    timeout = 2,
    event_set = 3,
    event_reset = 4,
    incomplete = 5,
    suboptimal_khr = 1000001003,
    thread_idle_khr = 1000268000,
    thread_done_khr = 1000268001,
    operation_deferred_khr = 1000268002,
    operation_not_deferred_khr = 1000268003,
    pipeline_compile_required = 1000297000,
    incompatible_shader_binary_ext = 1000482000,
    pipeline_binary_missing_khr = 1000483000,
    max_enum = 2147483647,
    const Self = @This();
    pub const error_pipeline_compile_required_ext = Self.pipeline_compile_required_ext;
    pub const error_invalid_opaque_capture_address_khr = Self.error_invalid_device_address_ext;
    pub const error_not_permitted_ext = Self.error_not_permitted_khr;
    pub const error_incompatible_shader_binary_ext = Self.incompatible_shader_binary_ext;
    pub const error_not_permitted_khr = Self.error_not_permitted;
    pub const pipeline_compile_required_ext = Self.pipeline_compile_required;
    pub const error_invalid_opaque_capture_address = Self.error_invalid_device_address_ext;
    pub const error_fragmentation_ext = Self.error_fragmentation;
    pub const error_invalid_external_handle_khr = Self.error_invalid_external_handle;
    pub const error_out_of_pool_memory_khr = Self.error_out_of_pool_memory;
};
pub export var __mingw_current_teb: ?*struct__TEB = @import("std").mem.zeroes(?*struct__TEB);
pub const _XcptActTab: [*c]struct__XCPT_ACTION = @extern([*c]struct__XCPT_ACTION, .{
    .name = "_XcptActTab",
});
pub extern const VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN: GUID;
pub extern fn AttachVirtualDisk(VirtualDiskHandle: HANDLE, SecurityDescriptor: PSECURITY_DESCRIPTOR, Flags: ATTACH_VIRTUAL_DISK_FLAG, ProviderSpecificFlags: ULONG, Parameters: PATTACH_VIRTUAL_DISK_PARAMETERS, Overlapped: LPOVERLAPPED) DWORD;
pub extern fn createWin32SurfaceKhr(instance: Instance, p_create_info: [*c]const Win32SurfaceCreateInfoKHR, p_allocator: [*c]const AllocationCallbacks, p_surface: [*c]SurfaceKHR) Result;
pub const struct_IXMLDOMNotationVtbl = extern struct {
    QueryInterface: ?*const fn ([*c]IXMLDOMNotation, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT),
    AddRef: ?*const fn ([*c]IXMLDOMNotation) callconv(.c) ULONG = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation) callconv(.c) ULONG),
    Release: ?*const fn ([*c]IXMLDOMNotation) callconv(.c) ULONG = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation) callconv(.c) ULONG),
    GetTypeInfoCount: ?*const fn ([*c]IXMLDOMNotation, [*c]UINT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]UINT) callconv(.c) HRESULT),
    GetTypeInfo: ?*const fn ([*c]IXMLDOMNotation, UINT, LCID, [*c][*c]ITypeInfo) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, UINT, LCID, [*c][*c]ITypeInfo) callconv(.c) HRESULT),
    GetIDsOfNames: ?*const fn ([*c]IXMLDOMNotation, [*c]const IID, [*c]LPOLESTR, UINT, LCID, [*c]DISPID) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]const IID, [*c]LPOLESTR, UINT, LCID, [*c]DISPID) callconv(.c) HRESULT),
    Invoke: ?*const fn ([*c]IXMLDOMNotation, DISPID, [*c]const IID, LCID, WORD, [*c]DISPPARAMS, [*c]VARIANT, [*c]EXCEPINFO, [*c]UINT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, DISPID, [*c]const IID, LCID, WORD, [*c]DISPPARAMS, [*c]VARIANT, [*c]EXCEPINFO, [*c]UINT) callconv(.c) HRESULT),
    get_nodeName: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    get_nodeValue: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT),
    put_nodeValue: ?*const fn ([*c]IXMLDOMNotation, VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, VARIANT) callconv(.c) HRESULT),
    get_nodeType: ?*const fn ([*c]IXMLDOMNotation, [*c]DOMNodeType) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]DOMNodeType) callconv(.c) HRESULT),
    get_parentNode: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_childNodes: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNodeList) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNodeList) callconv(.c) HRESULT),
    get_firstChild: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_lastChild: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_previousSibling: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_nextSibling: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_attributes: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNamedNodeMap) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNamedNodeMap) callconv(.c) HRESULT),
    insertBefore: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, VARIANT, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, VARIANT, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    replaceChild: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    removeChild: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    appendChild: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    hasChildNodes: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT),
    get_ownerDocument: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMDocument) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMDocument) callconv(.c) HRESULT),
    cloneNode: ?*const fn ([*c]IXMLDOMNotation, VARIANT_BOOL, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, VARIANT_BOOL, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_nodeTypeString: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    get_text: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    put_text: ?*const fn ([*c]IXMLDOMNotation, BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, BSTR) callconv(.c) HRESULT),
    get_specified: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT),
    get_definition: ?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_nodeTypedValue: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT),
    put_nodeTypedValue: ?*const fn ([*c]IXMLDOMNotation, VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, VARIANT) callconv(.c) HRESULT),
    get_dataType: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT),
    put_dataType: ?*const fn ([*c]IXMLDOMNotation, BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, BSTR) callconv(.c) HRESULT),
    get_xml: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    transformNode: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, [*c]BSTR) callconv(.c) HRESULT),
    selectNodes: ?*const fn ([*c]IXMLDOMNotation, BSTR, [*c][*c]IXMLDOMNodeList) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, BSTR, [*c][*c]IXMLDOMNodeList) callconv(.c) HRESULT),
    selectSingleNode: ?*const fn ([*c]IXMLDOMNotation, BSTR, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, BSTR, [*c][*c]IXMLDOMNode) callconv(.c) HRESULT),
    get_parsed: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT_BOOL) callconv(.c) HRESULT),
    get_namespaceURI: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    get_prefix: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    get_baseName: ?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]BSTR) callconv(.c) HRESULT),
    transformNodeToObject: ?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]IXMLDOMNode, VARIANT) callconv(.c) HRESULT),
    get_publicId: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT),
    get_systemId: ?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IXMLDOMNotation, [*c]VARIANT) callconv(.c) HRESULT),
};
pub const struct_IMonikerVtbl = extern struct {
    QueryInterface: ?*const fn ([*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT),
    AddRef: ?*const fn ([*c]IMoniker) callconv(.c) ULONG = @import("std").mem.zeroes(?*const fn ([*c]IMoniker) callconv(.c) ULONG),
    Release: ?*const fn ([*c]IMoniker) callconv(.c) ULONG = @import("std").mem.zeroes(?*const fn ([*c]IMoniker) callconv(.c) ULONG),
    GetClassID: ?*const fn ([*c]IMoniker, [*c]CLSID) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]CLSID) callconv(.c) HRESULT),
    IsDirty: ?*const fn ([*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker) callconv(.c) HRESULT),
    Load: ?*const fn ([*c]IMoniker, [*c]IStream) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IStream) callconv(.c) HRESULT),
    Save: ?*const fn ([*c]IMoniker, [*c]IStream, WINBOOL) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IStream, WINBOOL) callconv(.c) HRESULT),
    GetSizeMax: ?*const fn ([*c]IMoniker, [*c]ULARGE_INTEGER) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]ULARGE_INTEGER) callconv(.c) HRESULT),
    BindToObject: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT),
    BindToStorage: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]const IID, [*c]?*anyopaque) callconv(.c) HRESULT),
    Reduce: ?*const fn ([*c]IMoniker, [*c]IBindCtx, DWORD, [*c][*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, DWORD, [*c][*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT),
    ComposeWith: ?*const fn ([*c]IMoniker, [*c]IMoniker, WINBOOL, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IMoniker, WINBOOL, [*c][*c]IMoniker) callconv(.c) HRESULT),
    Enum: ?*const fn ([*c]IMoniker, WINBOOL, [*c][*c]IEnumMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, WINBOOL, [*c][*c]IEnumMoniker) callconv(.c) HRESULT),
    IsEqual: ?*const fn ([*c]IMoniker, [*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IMoniker) callconv(.c) HRESULT),
    Hash: ?*const fn ([*c]IMoniker, [*c]DWORD) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]DWORD) callconv(.c) HRESULT),
    IsRunning: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]IMoniker) callconv(.c) HRESULT),
    GetTimeOfLastChange: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]FILETIME) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]FILETIME) callconv(.c) HRESULT),
    Inverse: ?*const fn ([*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT),
    CommonPrefixWith: ?*const fn ([*c]IMoniker, [*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT),
    RelativePathTo: ?*const fn ([*c]IMoniker, [*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IMoniker, [*c][*c]IMoniker) callconv(.c) HRESULT),
    GetDisplayName: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]LPOLESTR) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, [*c]LPOLESTR) callconv(.c) HRESULT),
    ParseDisplayName: ?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, LPOLESTR, [*c]ULONG, [*c][*c]IMoniker) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]IBindCtx, [*c]IMoniker, LPOLESTR, [*c]ULONG, [*c][*c]IMoniker) callconv(.c) HRESULT),
    IsSystemMoniker: ?*const fn ([*c]IMoniker, [*c]DWORD) callconv(.c) HRESULT = @import("std").mem.zeroes(?*const fn ([*c]IMoniker, [*c]DWORD) callconv(.c) HRESULT),
};
pub const Offset2D = extern struct {
    x: i32 = @import("std").mem.zeroes(i32),
    y: i32 = @import("std").mem.zeroes(i32),
};
pub const BaseInStructure = extern struct {
    s_type: StructureType = @import("std").mem.zeroes(StructureType),
    p_next: [*c]const BaseInStructure = @import("std").mem.zeroes([*c]const BaseInStructure),
};
const union_unnamed_344 = extern union {
    hBitmap: HBITMAP,
    hMetaFilePict: HMETAFILEPICT,
    hEnhMetaFile: HENHMETAFILE,
    hGlobal: HGLOBAL,
    lpszFileName: LPOLESTR,
    pstm: [*c]IStream,
    pstg: [*c]IStorage,
};
pub const ClearColorValue = extern union {
    float32: [4]f32,
    int32: [4]i32,
    uint32: [4]u32,
};
pub extern var IWinTypesBase_v0_1_c_ifspec: RPC_IF_HANDLE;
pub const AccessFlagBits = enum(u32) {
    none = 0,
    indirect_command_read_bit = 1,
    index_read_bit = 2,
    vertex_attribute_read_bit = 4,
    uniform_read_bit = 8,
    input_attachment_read_bit = 16,
    shader_read_bit = 32,
    shader_write_bit = 64,
    color_attachment_read_bit = 128,
    color_attachment_write_bit = 256,
    depth_stencil_attachment_read_bit = 512,
    depth_stencil_attachment_write_bit = 1024,
    transfer_read_bit = 2048,
    transfer_write_bit = 4096,
    host_read_bit = 8192,
    host_write_bit = 16384,
    memory_read_bit = 32768,
    memory_write_bit = 65536,
    command_preprocess_read_bit_nv = 131072,
    command_preprocess_write_bit_nv = 262144,
    color_attachment_read_noncoherent_bit_ext = 524288,
    conditional_rendering_read_bit_ext = 1048576,
    acceleration_structure_read_bit_nv = 2097152,
    acceleration_structure_write_bit_nv = 4194304,
    shading_rate_image_read_bit_nv = 8388608,
    fragment_density_map_read_bit_ext = 16777216,
    transform_feedback_write_bit_ext = 33554432,
    transform_feedback_counter_read_bit_ext = 67108864,
    transform_feedback_counter_write_bit_ext = 134217728,
    flag_bits_max_enum = 2147483647,
    const Self = @This();
    pub const command_preprocess_write_bit_ext = Self.command_preprocess_write_bit_nv;
    pub const command_preprocess_read_bit_ext = Self.command_preprocess_read_bit_nv;
    pub const fragment_shading_rate_attachment_read_bit_khr = Self.shading_rate_image_read_bit_nv;
    pub const acceleration_structure_write_bit_khr = Self.acceleration_structure_write_bit_nv;
    pub const acceleration_structure_read_bit_khr = Self.acceleration_structure_read_bit_nv;
    pub const none_khr = Self.none;
};
pub const AccessFlags = PES(AccessFlagBits)
pub const AccessFlags2 = enum(u64) {
    @"2_none" = 0,
    @"2_indirect_command_read_bit" = 1,
    @"2_index_read_bit" = 2,
    @"2_vertex_attribute_read_bit" = 4,
    @"2_uniform_read_bit" = 8,
    @"2_input_attachment_read_bit" = 16,
    @"2_shader_read_bit" = 32,
    @"2_shader_write_bit" = 64,
    @"2_color_attachment_read_bit" = 128,
    @"2_color_attachment_write_bit" = 256,
    @"2_depth_stencil_attachment_read_bit" = 512,
    @"2_depth_stencil_attachment_write_bit" = 1024,
    @"2_transfer_read_bit" = 2048,
    @"2_transfer_write_bit" = 4096,
    @"2_host_read_bit" = 8192,
    @"2_host_write_bit" = 16384,
    @"2_memory_read_bit" = 32768,
    @"2_memory_write_bit" = 65536,
    @"2_command_preprocess_read_bit_nv" = 131072,
    @"2_command_preprocess_write_bit_nv" = 262144,
    @"2_color_attachment_read_noncoherent_bit_ext" = 524288,
    @"2_conditional_rendering_read_bit_ext" = 1048576,
    @"2_acceleration_structure_read_bit_nv" = 2097152,
    @"2_acceleration_structure_write_bit_nv" = 4194304,
    @"2_shading_rate_image_read_bit_nv" = 8388608,
    @"2_fragment_density_map_read_bit_ext" = 16777216,
    @"2_transform_feedback_write_bit_ext" = 33554432,
    @"2_transform_feedback_counter_read_bit_ext" = 67108864,
    @"2_transform_feedback_counter_write_bit_ext" = 134217728,
    @"2_shader_sampled_read_bit" = 4294967296,
    @"2_shader_storage_read_bit" = 8589934592,
    @"2_shader_storage_write_bit" = 17179869184,
    @"2_video_decode_read_bit_khr" = 34359738368,
    @"2_video_decode_write_bit_khr" = 68719476736,
    @"2_video_encode_read_bit_khr" = 137438953472,
    @"2_video_encode_write_bit_khr" = 274877906944,
    @"2_invocation_mask_read_bit_huawei" = 549755813888,
    @"2_shader_binding_table_read_bit_khr" = 1099511627776,
    @"2_descriptor_buffer_read_bit_ext" = 2199023255552,
    @"2_optical_flow_read_bit_nv" = 4398046511104,
    @"2_optical_flow_write_bit_nv" = 8796093022208,
    @"2_micromap_read_bit_ext" = 17592186044416,
    @"2_micromap_write_bit_ext" = 35184372088832,
    const Self = @This();
    pub const @"2_none_khr" = Self.@"2_none";
    pub const @"2_indirect_command_read_bit_khr" = Self.@"2_indirect_command_read_bit";
    pub const @"2_index_read_bit_khr" = Self.@"2_index_read_bit";
    pub const @"2_vertex_attribute_read_bit_khr" = Self.@"2_vertex_attribute_read_bit";
    pub const @"2_uniform_read_bit_khr" = Self.@"2_uniform_read_bit";
    pub const @"2_input_attachment_read_bit_khr" = Self.@"2_input_attachment_read_bit";
    pub const @"2_shader_read_bit_khr" = Self.@"2_shader_read_bit";
    pub const @"2_shader_write_bit_khr" = Self.@"2_shader_write_bit";
    pub const @"2_color_attachment_read_bit_khr" = Self.@"2_color_attachment_read_bit";
    pub const @"2_color_attachment_write_bit_khr" = Self.@"2_color_attachment_write_bit";
    pub const @"2_depth_stencil_attachment_read_bit_khr" = Self.@"2_depth_stencil_attachment_read_bit";
    pub const @"2_depth_stencil_attachment_write_bit_khr" = Self.@"2_depth_stencil_attachment_write_bit";
    pub const @"2_transfer_read_bit_khr" = Self.@"2_transfer_read_bit";
    pub const @"2_transfer_write_bit_khr" = Self.@"2_transfer_write_bit";
    pub const @"2_host_read_bit_khr" = Self.@"2_host_read_bit";
    pub const @"2_host_write_bit_khr" = Self.@"2_host_write_bit";
    pub const @"2_memory_read_bit_khr" = Self.@"2_memory_read_bit";
    pub const @"2_memory_write_bit_khr" = Self.@"2_memory_write_bit";
    pub const @"2_shader_sampled_read_bit_khr" = Self.@"2_shader_sampled_read_bit";
    pub const @"2_shader_storage_read_bit_khr" = Self.@"2_shader_storage_read_bit";
    pub const @"2_shader_storage_write_bit_khr" = Self.@"2_shader_storage_write_bit";
    pub const @"2_command_preprocess_read_bit_ext" = Self.@"2_command_preprocess_read_bit_nv";
    pub const @"2_command_preprocess_write_bit_ext" = Self.@"2_command_preprocess_write_bit_nv";
    pub const @"2_fragment_shading_rate_attachment_read_bit_khr" = Self.@"2_shading_rate_image_read_bit_nv";
    pub const @"2_acceleration_structure_read_bit_khr" = Self.@"2_acceleration_structure_read_bit_nv";
    pub const @"2_acceleration_structure_write_bit_khr" = Self.@"2_acceleration_structure_write_bit_nv";
};
pub const AccessFlags2 = PES(AccessFlagBits2)
pub fn _MarkAllocaS(arg__Ptr: ?*anyopaque, arg__Marker: c_uint) callconv(.c) ?*anyopaque {
    var _Ptr = arg__Ptr;
    _ = &_Ptr;
    var _Marker = arg__Marker;
    _ = &_Marker;
    if (_Ptr != null) {
        @as([*c]c_uint, @ptrCast(@alignCast(_Ptr))).* = _Marker;
        _Ptr = @as(?*anyopaque, @ptrCast(@as([*c]u8, @ptrCast(@alignCast(_Ptr))) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 16)))))));
    }
    return _Ptr;
}
pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub inline fn _BitScanReverse(arg_Index: [*c]c_ulong, arg_Mask: c_ulong) u8 {
    var Index = arg_Index;
    _ = &Index;
    var Mask = arg_Mask;
    _ = &Mask;
    if (Mask == @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 0))))) return 0;
    Index.* = @as(c_ulong, @bitCast(@as(c_long, @as(c_int, 31) - __builtin_clz(@as(c_uint, @bitCast(@as(c_uint, @truncate(Mask))))))));
    return 1;
}
pub inline fn makeApiVersion(variant: anytype, major: anytype, minor: anytype, patch: anytype) @TypeOf((((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch)) {
    _ = &variant;
    _ = &major;
    _ = &minor;
    _ = &patch;
    return (((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch);
}
pub const struct_threadmbcinfostruct = opaque {};
pub const Buffer = enum(u64) { null = 0, _ };
pub const PFN_allocationFunction = ?*const fn (?*anyopaque, usize, usize, SystemAllocationScope) callconv(.c) ?*anyopaque;
pub const DWORD = c_ulong;
pub const PVOID = ?*anyopaque;
pub const ULONG_PTR = c_ulonglong;
pub const DWORD64 = c_ulonglong;
pub const Bool32 = enum(u32) {
    false = 0,
    true = 1,
};
pub const DeviceAddress = u64;
pub const DeviceSize = u64;
pub const Flags = u32;
pub const Flags64 = u64;
pub const SampleMask = u32;
pub const DeviceCreateFlags = Flags;
pub const PhysicalDeviceVariablePointerFeatures = PhysicalDeviceVariablePointersFeatures;
pub const TypeNames = struct {
    uuid_size: u32 = 16,
};
pub const ExtensionNames = struct {
    surface: "VK_KHR_surface",
};
pub const SpecVersions = struct {
    surface: i32 = 25,
};
