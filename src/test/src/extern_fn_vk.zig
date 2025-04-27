pub extern fn vkCreateWin32SurfaceKHR(instance: VkInstance, pCreateInfo: [*c]const VkWin32SurfaceCreateInfoKHR, pAllocator: [*c]const VkAllocationCallbacks, pSurface: [*c]VkSurfaceKHR) VkResult;
pub extern fn vkCopyMemoryToImage(device: VkDevice, pCopyMemoryToImageInfo: [*c]const VkCopyMemoryToImageInfo) VkResult;
