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
