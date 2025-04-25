pub const PES = @import("PackedEnumSet");
pub const Offset2D = extern struct {
    x: i32 = @import("std").mem.zeroes(i32),
    y: i32 = @import("std").mem.zeroes(i32),
};
pub const BaseInStructure = extern struct {
    s_type: StructureType = @import("std").mem.zeroes(StructureType),
    p_next: [*c]const BaseInStructure = @import("std").mem.zeroes([*c]const BaseInStructure),
};
