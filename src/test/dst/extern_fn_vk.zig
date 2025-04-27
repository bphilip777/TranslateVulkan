pub const PES = @import("PackedEnumSet").PackedEnumSet;
pub extern fn createWin32SurfaceKhr(instance: Instance, p_create_info: [*c]const Win32SurfaceCreateInfoKHR, p_allocator: [*c]const AllocationCallbacks, p_surface: [*c]SurfaceKHR) Result;
pub extern fn copyMemoryToImage(device: Device, pcopy_memory_to_image_info: [*c]const copyMemoryToImageInfo) Result;
