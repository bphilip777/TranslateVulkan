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
