pub const struct_VkOffset2D = extern struct {
    x: i32 = @import("std").mem.zeroes(i32),
    y: i32 = @import("std").mem.zeroes(i32),
};
pub const VkOffset2D = struct_VkOffset2D;
pub const DeviceQueueCreateInfo = extern struct {
    s_type: VkStructureType = @import("std").mem.zeroes(VkStructureType),
    p_next: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
    flags: VkDeviceQueueCreateFlags = @import("std").mem.zeroes(VkDeviceQueueCreateFlags),
    queue_family_index: u32 = @import("std").mem.zeroes(u32),
    queue_count: u32 = @import("std").mem.zeroes(u32),
    p_queue_priorities: [*c]const f32 = @import("std").mem.zeroes([*c]const f32),
};
