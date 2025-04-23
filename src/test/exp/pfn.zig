pub const PFN_allocationFunction = ?*const fn (?*anyopaque, usize, usize, SystemAllocationScope) callconv(.c) ?*anyopaque;
