pub const PES = @import("PackedEnumSet").PackedEnumSet;
pub const ExtensionNames = struct {
    surface: "VK_KHR_surface",
    maintenance_1: "VK_KHR_maintenance1",
    const Self = @This();
    pub const maintenance1 = Self.maintenance_1;
};
