pub const PointClippingBehavior = enum(u32) {
    all_clip_planes = 0,
    user_clip_planes_only = 1,
    max_enum = 2147483647,
};
pub const user_clip_planes_only_khr = PointClippingBehavior.user_clip_planes_only;
pub const all_clip_planes_khr = PointClippingBehavior.all_clip_planes;
pub export var __mingw_current_teb: ?*struct__TEB = @import("std").mem.zeroes(?*struct__TEB);
pub const _XcptActTab: [*c]struct__XCPT_ACTION = @extern([*c]struct__XCPT_ACTION, .{
    .name = "_XcptActTab",
});
pub extern const VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN: GUID;
pub extern fn AttachVirtualDisk(VirtualDiskHandle: HANDLE, SecurityDescriptor: PSECURITY_DESCRIPTOR, Flags: ATTACH_VIRTUAL_DISK_FLAG, ProviderSpecificFlags: ULONG, Parameters: PATTACH_VIRTUAL_DISK_PARAMETERS, Overlapped: LPOVERLAPPED) DWORD;
pub extern fn createWin32SurfaceKhr(instance: Instance, p_create_info: [*c]const Win32SurfaceCreateInfoKHR, p_allocator: [*c]const AllocationCallbacks, p_surface: [*c]SurfaceKHR) Result;
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
};
pub const Offset2D = extern struct {
    x: i32 = @import("std").mem.zeroes(i32),
    y: i32 = @import("std").mem.zeroes(i32),
};
pub const VkOffset2D = struct_VkOffset2D;
pub const BaseInStructure = extern struct {
    s_type: StructureType = @import("std").mem.zeroes(VkStructureType),
    p_next: [*c]const BaseInStructure = @import("std").mem.zeroes([*c]const BaseInStructure),
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
pub const ClearColorValue = extern union {
    float32: [4]f32,
    int32: [4]i32,
    uint32: [4]u32,
};
pub extern var IWinTypesBase_v0_1_c_ifspec: RPC_IF_HANDLE;
pub const AccessFlags = enum(u32) {
    indirect_command_read_bit = 1,
    index_read_bit = 2,
    vertex_attribute_read_bit = 4,
    uniform_read_bit = 8,
    none = 0,
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
    color_attachment_read_noncoherent_bit_ext = 524288,
    command_preprocess_read_bit_nv = 131072,
    command_preprocess_write_bit_nv = 262144,
    conditional_rendering_read_bit_ext = 1048576,
    shading_rate_image_read_bit_nv = 8388608,
    acceleration_structure_read_bit_nv = 2097152,
    acceleration_structure_write_bit_nv = 4194304,
    transform_feedback_write_bit_ext = 33554432,
    transform_feedback_counter_read_bit_ext = 67108864,
    fragment_density_map_read_bit_ext = 16777216,
    transform_feedback_counter_write_bit_ext = 134217728,
    max_enum = 2147483647,
};
pub const AccessFlags2 = enum(i32) {
    uniform_read_bit = 8,
    vertex_attribute_read_bit = 4,
    index_read_bit = 2,
    indirect_command_read_bit = 1,
    none = 0,
    shader_write_bit = 64,
    shader_read_bit = 32,
    input_attachment_read_bit = 16,
    depth_stencil_attachment_read_bit = 512,
    color_attachment_write_bit = 256,
    color_attachment_read_bit = 128,
    host_read_bit = 8192,
    transfer_write_bit = 4096,
    transfer_read_bit = 2048,
    depth_stencil_attachment_write_bit = 1024,
    memory_write_bit = 65536,
    memory_read_bit = 32768,
    host_write_bit = 16384,
    color_attachment_read_noncoherent_bit_ext = 524288,
    command_preprocess_write_bit_nv = 262144,
    command_preprocess_read_bit_nv = 131072,
    acceleration_structure_write_bit_nv = 4194304,
    acceleration_structure_read_bit_nv = 2097152,
    shading_rate_image_read_bit_nv = 8388608,
    conditional_rendering_read_bit_ext = 1048576,
    fragment_density_map_read_bit_ext = 16777216,
    transform_feedback_counter_read_bit_ext = 67108864,
    transform_feedback_write_bit_ext = 33554432,
    transform_feedback_counter_write_bit_ext = 134217728,
    shader_storage_read_bit = 8589934592,
    shader_sampled_read_bit = 4294967296,
    video_decode_write_bit_khr = 68719476736,
    video_decode_read_bit_khr = 34359738368,
    shader_storage_write_bit = 17179869184,
    invocation_mask_read_bit_huawei = 549755813888,
    video_encode_write_bit_khr = 274877906944,
    video_encode_read_bit_khr = 137438953472,
    optical_flow_write_bit_nv = 8796093022208,
    optical_flow_read_bit_nv = 4398046511104,
    shader_binding_table_read_bit_khr = 1099511627776,
    descriptor_buffer_read_bit_ext = 2199023255552,
    micromap_write_bit_ext = 35184372088832,
    micromap_read_bit_ext = 17592186044416,
};
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
pub const PFN_AllocationFunction = ?*const fn (?*anyopaque, usize, usize, SystemAllocationScope) callconv(.c) ?*anyopaque;
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
pub const TypeNames = struct {
    uuid_size: u32 = 16,
};
pub const ExtensionNames = struct {
    surface: "VK_KHR_surface",
};
pub const SpecVersions = struct {
    surface: i32 = 25,
};
