# Translate Platform Specific Code:
- macros found in vulkan.h - add them to compile to your specified platform

Run this first:
```zig
zig translate-c -IVulkan/Include -lc -DVK_USE_PLATFORM_WIN32_KHR=1
 Vulkan/Include/vulkan/vulkan.h > src/vulkan.zig
```

Inside your zig project folder
```
zig fetch --save git+
```

Add to your build.zig build fn:
```zig
const TranslateVulkan = b.addDependency("TranslateVulkan", .{});
exe.root_module.addImport("TranslateVulkan", TranslateVulkan.module("TranslateVulkan"));
```

Now in your main.zig file, import vulkan:
```zig
const vk = @import("TranslateVulkan").vulkan;
```

Example Use Case:
```zig
const std = @import("std");
const vk = @import("TranslateVulkan").vulkan;

pub fn main() !void {
 const a = vk.InstanceCreateInfo{};
 _ = a;
}
```
