# ~~~
# Copyright (c) 2025-2026 The Khronos Group Inc.
# Copyright (c) 2025-2026 RasterGrid Kft.
#
# SPDX-License-Identifier: Apache-2.0
# ~~~

export VULKANSC_SDK="$(realpath "$(dirname "$(readlink -f "${BASH_SOURCE:-$0}" )" )/..")"
export PATH="${VULKANSC_SDK}/bin:${PATH}"
export LD_LIBRARY_PATH="${VULKANSC_SDK}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
