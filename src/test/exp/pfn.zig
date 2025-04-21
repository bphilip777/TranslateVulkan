pub const PFN_AllocationFunction = ?*const fn (?*anyopaque, usize, usize, SystemAllocationScope) callconv(.c) ?*anyopaque;
