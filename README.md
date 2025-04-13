# Translate Platform Specific Code:
- macros found in vulkan.h - add them to compile to your specified platform

zig translate-c -IVulkan/Include -lc -DVK_USE_PLATFORM_WIN32_KHR=1
 Vulkan/Include/vulkan/vulkan.h > src/vulkan.zig
