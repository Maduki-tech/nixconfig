{ pkgs, ... }:
{
  home.sessionVariables = {
    # AMD GPU optimizations for Wayland
    WLR_DRM_NO_ATOMIC = "0";
    WLR_RENDERER = "vulkan";

    # Hardware video acceleration
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";

    # Vulkan
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "gpl,nggc";

    # Qt/Wayland
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # VRR support
    WLR_DRM_NO_MODIFIERS = "1";
  };
}
