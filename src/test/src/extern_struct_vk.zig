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
