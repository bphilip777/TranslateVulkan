pub const _beep = @compileError("unable to resolve function type clang.TypeClass.MacroQualified");
pub const VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES: c_int = 0;
pub const VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY: c_int = 1;
pub const VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES_KHR: c_int = 0;
pub const VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY_KHR: c_int = 1;
pub const VK_POINT_CLIPPING_BEHAVIOR_MAX_ENUM: c_int = 2147483647;
pub const enum_VkPointClippingBehavior = c_uint;
pub const VkPointClippingBehavior = enum_VkPointClippingBehavior;
pub export var __mingw_current_teb: ?*struct__TEB = @import("std").mem.zeroes(?*struct__TEB);
pub const VK_KHR_SURFACE_EXTENSION_NAME = "VK_KHR_surface";
pub const _XcptActTab: [*c]struct__XCPT_ACTION = @extern([*c]struct__XCPT_ACTION, .{
    .name = "_XcptActTab",
});
pub extern const VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN: GUID;
pub extern fn AttachVirtualDisk(VirtualDiskHandle: HANDLE, SecurityDescriptor: PSECURITY_DESCRIPTOR, Flags: ATTACH_VIRTUAL_DISK_FLAG, ProviderSpecificFlags: ULONG, Parameters: PATTACH_VIRTUAL_DISK_PARAMETERS, Overlapped: LPOVERLAPPED) DWORD;
pub extern fn vkCreateWin32SurfaceKHR(instance: VkInstance, pCreateInfo: [*c]const VkWin32SurfaceCreateInfoKHR, pAllocator: [*c]const VkAllocationCallbacks, pSurface: [*c]VkSurfaceKHR) VkResult;
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
pub const struct_VkOffset2D = extern struct {
    x: i32 = @import("std").mem.zeroes(i32),
    y: i32 = @import("std").mem.zeroes(i32),
};
pub const VkOffset2D = struct_VkOffset2D;
pub const struct_VkBaseInStructure = extern struct {
    sType: VkStructureType = @import("std").mem.zeroes(VkStructureType),
    pNext: [*c]const struct_VkBaseInStructure = @import("std").mem.zeroes([*c]const struct_VkBaseInStructure),
};
pub const VkBaseInStructure = struct_VkBaseInStructure;
const union_unnamed_344 = extern union {
    hBitmap: HBITMAP,
    hMetaFilePict: HMETAFILEPICT,
    hEnhMetaFile: HENHMETAFILE,
    hGlobal: HGLOBAL,
    lpszFileName: LPOLESTR,
    pstm: [*c]IStream,
    pstg: [*c]IStorage,
};
pub const union_VkClearColorValue = extern union {
    float32: [4]f32,
    int32: [4]i32,
    uint32: [4]u32,
};
pub const VkClearColorValue = union_VkClearColorValue;
pub extern var IWinTypesBase_v0_1_c_ifspec: RPC_IF_HANDLE;
pub const VK_ACCESS_INDIRECT_COMMAND_READ_BIT: c_int = 1;
pub const VK_ACCESS_INDEX_READ_BIT: c_int = 2;
pub const VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT: c_int = 4;
pub const VK_ACCESS_UNIFORM_READ_BIT: c_int = 8;
pub const VK_ACCESS_INPUT_ATTACHMENT_READ_BIT: c_int = 16;
pub const VK_ACCESS_SHADER_READ_BIT: c_int = 32;
pub const VK_ACCESS_SHADER_WRITE_BIT: c_int = 64;
pub const VK_ACCESS_COLOR_ATTACHMENT_READ_BIT: c_int = 128;
pub const VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT: c_int = 256;
pub const VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT: c_int = 512;
pub const VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT: c_int = 1024;
pub const VK_ACCESS_TRANSFER_READ_BIT: c_int = 2048;
pub const VK_ACCESS_TRANSFER_WRITE_BIT: c_int = 4096;
pub const VK_ACCESS_HOST_READ_BIT: c_int = 8192;
pub const VK_ACCESS_HOST_WRITE_BIT: c_int = 16384;
pub const VK_ACCESS_MEMORY_READ_BIT: c_int = 32768;
pub const VK_ACCESS_MEMORY_WRITE_BIT: c_int = 65536;
pub const VK_ACCESS_NONE: c_int = 0;
pub const VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT: c_int = 33554432;
pub const VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT: c_int = 67108864;
pub const VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT: c_int = 134217728;
pub const VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT: c_int = 1048576;
pub const VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT: c_int = 524288;
pub const VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_KHR: c_int = 2097152;
pub const VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_KHR: c_int = 4194304;
pub const VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT: c_int = 16777216;
pub const VK_ACCESS_FRAGMENT_SHADING_RATE_ATTACHMENT_READ_BIT_KHR: c_int = 8388608;
pub const VK_ACCESS_COMMAND_PREPROCESS_READ_BIT_NV: c_int = 131072;
pub const VK_ACCESS_COMMAND_PREPROCESS_WRITE_BIT_NV: c_int = 262144;
pub const VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV: c_int = 8388608;
pub const VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV: c_int = 2097152;
pub const VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV: c_int = 4194304;
pub const VK_ACCESS_NONE_KHR: c_int = 0;
pub const VK_ACCESS_COMMAND_PREPROCESS_READ_BIT_EXT: c_int = 131072;
pub const VK_ACCESS_COMMAND_PREPROCESS_WRITE_BIT_EXT: c_int = 262144;
pub const VK_ACCESS_FLAG_BITS_MAX_ENUM: c_int = 2147483647;
pub const enum_VkAccessFlagBits = c_uint;
pub const VkAccessFlagBits = enum_VkAccessFlagBits;
pub const VkAccessFlags = VkFlags;
pub const VkAccessFlags2 = VkFlags64;
pub const VkAccessFlagBits2 = VkFlags64;
pub const VK_ACCESS_2_NONE: VkAccessFlagBits2 = 0;
pub const VK_ACCESS_2_INDIRECT_COMMAND_READ_BIT: VkAccessFlagBits2 = 1;
pub const VK_ACCESS_2_INDEX_READ_BIT: VkAccessFlagBits2 = 2;
pub const VK_ACCESS_2_VERTEX_ATTRIBUTE_READ_BIT: VkAccessFlagBits2 = 4;
pub const VK_ACCESS_2_UNIFORM_READ_BIT: VkAccessFlagBits2 = 8;
pub const VK_ACCESS_2_INPUT_ATTACHMENT_READ_BIT: VkAccessFlagBits2 = 16;
pub const VK_ACCESS_2_SHADER_READ_BIT: VkAccessFlagBits2 = 32;
pub const VK_ACCESS_2_SHADER_WRITE_BIT: VkAccessFlagBits2 = 64;
pub const VK_ACCESS_2_COLOR_ATTACHMENT_READ_BIT: VkAccessFlagBits2 = 128;
pub const VK_ACCESS_2_COLOR_ATTACHMENT_WRITE_BIT: VkAccessFlagBits2 = 256;
pub const VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_READ_BIT: VkAccessFlagBits2 = 512;
pub const VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT: VkAccessFlagBits2 = 1024;
pub const VK_ACCESS_2_TRANSFER_READ_BIT: VkAccessFlagBits2 = 2048;
pub const VK_ACCESS_2_TRANSFER_WRITE_BIT: VkAccessFlagBits2 = 4096;
pub const VK_ACCESS_2_HOST_READ_BIT: VkAccessFlagBits2 = 8192;
pub const VK_ACCESS_2_HOST_WRITE_BIT: VkAccessFlagBits2 = 16384;
pub const VK_ACCESS_2_MEMORY_READ_BIT: VkAccessFlagBits2 = 32768;
pub const VK_ACCESS_2_MEMORY_WRITE_BIT: VkAccessFlagBits2 = 65536;
pub const VK_ACCESS_2_SHADER_SAMPLED_READ_BIT: VkAccessFlagBits2 = 4294967296;
pub const VK_ACCESS_2_SHADER_STORAGE_READ_BIT: VkAccessFlagBits2 = 8589934592;
pub const VK_ACCESS_2_SHADER_STORAGE_WRITE_BIT: VkAccessFlagBits2 = 17179869184;
pub const VK_ACCESS_2_VIDEO_DECODE_READ_BIT_KHR: VkAccessFlagBits2 = 34359738368;
pub const VK_ACCESS_2_VIDEO_DECODE_WRITE_BIT_KHR: VkAccessFlagBits2 = 68719476736;
pub const VK_ACCESS_2_VIDEO_ENCODE_READ_BIT_KHR: VkAccessFlagBits2 = 137438953472;
pub const VK_ACCESS_2_VIDEO_ENCODE_WRITE_BIT_KHR: VkAccessFlagBits2 = 274877906944;
pub const VK_ACCESS_2_NONE_KHR: VkAccessFlagBits2 = 0;
pub const VK_ACCESS_2_INDIRECT_COMMAND_READ_BIT_KHR: VkAccessFlagBits2 = 1;
pub const VK_ACCESS_2_INDEX_READ_BIT_KHR: VkAccessFlagBits2 = 2;
pub const VK_ACCESS_2_VERTEX_ATTRIBUTE_READ_BIT_KHR: VkAccessFlagBits2 = 4;
pub const VK_ACCESS_2_UNIFORM_READ_BIT_KHR: VkAccessFlagBits2 = 8;
pub const VK_ACCESS_2_INPUT_ATTACHMENT_READ_BIT_KHR: VkAccessFlagBits2 = 16;
pub const VK_ACCESS_2_SHADER_READ_BIT_KHR: VkAccessFlagBits2 = 32;
pub const VK_ACCESS_2_SHADER_WRITE_BIT_KHR: VkAccessFlagBits2 = 64;
pub const VK_ACCESS_2_COLOR_ATTACHMENT_READ_BIT_KHR: VkAccessFlagBits2 = 128;
pub const VK_ACCESS_2_COLOR_ATTACHMENT_WRITE_BIT_KHR: VkAccessFlagBits2 = 256;
pub const VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_READ_BIT_KHR: VkAccessFlagBits2 = 512;
pub const VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT_KHR: VkAccessFlagBits2 = 1024;
pub const VK_ACCESS_2_TRANSFER_READ_BIT_KHR: VkAccessFlagBits2 = 2048;
pub const VK_ACCESS_2_TRANSFER_WRITE_BIT_KHR: VkAccessFlagBits2 = 4096;
pub const VK_ACCESS_2_HOST_READ_BIT_KHR: VkAccessFlagBits2 = 8192;
pub const VK_ACCESS_2_HOST_WRITE_BIT_KHR: VkAccessFlagBits2 = 16384;
pub const VK_ACCESS_2_MEMORY_READ_BIT_KHR: VkAccessFlagBits2 = 32768;
pub const VK_ACCESS_2_MEMORY_WRITE_BIT_KHR: VkAccessFlagBits2 = 65536;
pub const VK_ACCESS_2_SHADER_SAMPLED_READ_BIT_KHR: VkAccessFlagBits2 = 4294967296;
pub const VK_ACCESS_2_SHADER_STORAGE_READ_BIT_KHR: VkAccessFlagBits2 = 8589934592;
pub const VK_ACCESS_2_SHADER_STORAGE_WRITE_BIT_KHR: VkAccessFlagBits2 = 17179869184;
pub const VK_ACCESS_2_TRANSFORM_FEEDBACK_WRITE_BIT_EXT: VkAccessFlagBits2 = 33554432;
pub const VK_ACCESS_2_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT: VkAccessFlagBits2 = 67108864;
pub const VK_ACCESS_2_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT: VkAccessFlagBits2 = 134217728;
pub const VK_ACCESS_2_CONDITIONAL_RENDERING_READ_BIT_EXT: VkAccessFlagBits2 = 1048576;
pub const VK_ACCESS_2_COMMAND_PREPROCESS_READ_BIT_NV: VkAccessFlagBits2 = 131072;
pub const VK_ACCESS_2_COMMAND_PREPROCESS_WRITE_BIT_NV: VkAccessFlagBits2 = 262144;
pub const VK_ACCESS_2_COMMAND_PREPROCESS_READ_BIT_EXT: VkAccessFlagBits2 = 131072;
pub const VK_ACCESS_2_COMMAND_PREPROCESS_WRITE_BIT_EXT: VkAccessFlagBits2 = 262144;
pub const VK_ACCESS_2_FRAGMENT_SHADING_RATE_ATTACHMENT_READ_BIT_KHR: VkAccessFlagBits2 = 8388608;
pub const VK_ACCESS_2_SHADING_RATE_IMAGE_READ_BIT_NV: VkAccessFlagBits2 = 8388608;
pub const VK_ACCESS_2_ACCELERATION_STRUCTURE_READ_BIT_KHR: VkAccessFlagBits2 = 2097152;
pub const VK_ACCESS_2_ACCELERATION_STRUCTURE_WRITE_BIT_KHR: VkAccessFlagBits2 = 4194304;
pub const VK_ACCESS_2_ACCELERATION_STRUCTURE_READ_BIT_NV: VkAccessFlagBits2 = 2097152;
pub const VK_ACCESS_2_ACCELERATION_STRUCTURE_WRITE_BIT_NV: VkAccessFlagBits2 = 4194304;
pub const VK_ACCESS_2_FRAGMENT_DENSITY_MAP_READ_BIT_EXT: VkAccessFlagBits2 = 16777216;
pub const VK_ACCESS_2_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT: VkAccessFlagBits2 = 524288;
pub const VK_ACCESS_2_DESCRIPTOR_BUFFER_READ_BIT_EXT: VkAccessFlagBits2 = 2199023255552;
pub const VK_ACCESS_2_INVOCATION_MASK_READ_BIT_HUAWEI: VkAccessFlagBits2 = 549755813888;
pub const VK_ACCESS_2_SHADER_BINDING_TABLE_READ_BIT_KHR: VkAccessFlagBits2 = 1099511627776;
pub const VK_ACCESS_2_MICROMAP_READ_BIT_EXT: VkAccessFlagBits2 = 17592186044416;
pub const VK_ACCESS_2_MICROMAP_WRITE_BIT_EXT: VkAccessFlagBits2 = 35184372088832;
pub const VK_ACCESS_2_OPTICAL_FLOW_READ_BIT_NV: VkAccessFlagBits2 = 4398046511104;
pub const VK_ACCESS_2_OPTICAL_FLOW_WRITE_BIT_NV: VkAccessFlagBits2 = 8796093022208;
pub const VK_SUBMIT_PROTECTED_BIT: c_int = 1;
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
pub inline fn VK_MAKE_API_VERSION(variant: anytype, major: anytype, minor: anytype, patch: anytype) @TypeOf((((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch)) {
    _ = &variant;
    _ = &major;
    _ = &minor;
    _ = &patch;
    return (((@import("std").zig.c_translation.cast(u32, variant) << @as(c_uint, 29)) | (@import("std").zig.c_translation.cast(u32, major) << @as(c_uint, 22))) | (@import("std").zig.c_translation.cast(u32, minor) << @as(c_uint, 12))) | @import("std").zig.c_translation.cast(u32, patch);
}
pub const struct_threadmbcinfostruct = opaque {};
pub const struct_VkBuffer_T = opaque {};
pub const VkBuffer = ?*struct_VkBuffer_T;
pub const PFN_vkAllocationFunction = ?*const fn (?*anyopaque, usize, usize, VkSystemAllocationScope) callconv(.c) ?*anyopaque;
pub const VK_KHR_SURFACE_SPEC_VERSION = @as(c_int, 25);
pub const DWORD = c_ulong;
pub const PVOID = ?*anyopaque;
pub const ULONG_PTR = c_ulonglong;
pub const DWORD64 = c_ulonglong;
pub const VK_UUID_SIZE = @as(c_uint, 16);
pub const VkBool32 = u32;
pub const VkDeviceAddress = u64;
pub const VkDeviceSize = u64;
pub const VkFlags = u32;
pub const VkFlags64 = u64;
pub const VkSampleMask = u32;
pub const VkDeviceCreateFlags = VkFlags;
