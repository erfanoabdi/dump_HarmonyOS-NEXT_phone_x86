#!/bin/bash
# Copyright (c) 2024 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
if [ $# = 1 ]; then
    mount -t ext4 /dev/block/by-name/patch /patch_hw -o ro,barrier=1
    exit
fi
PATCH_PATH="/patch_hw"
SANDBOX_PATCH_PATH="/mnt/sandbox/system/patch_hw"
DEV_PATCH_PATH="/dev/block/by-name/patch"
SAMGR_NAMESPACE="/proc/$(pidof samgr)/ns/mnt"

umount "$PATCH_PATH"
nsenter -m"$SAMGR_NAMESPACE" umount "$PATCH_PATH"
nsenter -m"$SAMGR_NAMESPACE" umount "$SANDBOX_PATCH_PATH"
nsenter -m"$SAMGR_NAMESPACE" sh /system/etc/init/patch_partition_refresh.sh 1
exit

