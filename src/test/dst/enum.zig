pub const PointClippingBehavior = enum(u32) {
    all_clip_planes = 0,
    user_clip_planes_only = 1,
    max_enum = 2147483647,
};
pub const user_clip_planes_only = PointClippingBehavior.user_clip_planes_only_khr;
pub const all_clip_planes = PointClippingBehavior.all_clip_planes_khr;
pub const StructureType = enum(u32) {
    semaphore_create_info = 9,
    export_semaphore_create_info = 1000077000,
};
pub const export_semaphore_create_info = StructureType.export_semaphore_create_info_khr;
