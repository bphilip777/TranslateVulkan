pub const PFN_vkAllocationFunction = ?*const fn (?*anyopaque, usize, usize, VkSystemAllocationScope) callconv(.c) ?*anyopaque;
