#
# Copyright 2017-2018, Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
# src/test/util_sds/TEST6 -- unittest for shutdown state
#

# standard unit test setup
. ..\unittest\unittest.PS1

require_test_type medium

require_fs_type any

require_build_type debug

setup

$Env:TEST_LOG_LEVEL=2
$Env:TEST_LOG_FILE=".\test$Env:UNITTEST_NUM.log"

# fail after an open flag is set
expect_normal_exit $Env:EXE_DIR\util_sds 1 5 `
				   $DIR\testfile1 5 0 `
				   $DIR\testfile2 7 0 `
				   $DIR\testfile3 9 0

# files was moved to another dimm
expect_abnormal_exit $Env:EXE_DIR\util_sds 0 0 `
				   $DIR\testfile1 15 0 `
				   $DIR\testfile2 73 0 `
				   $DIR\testfile3 49 0

Get-Content test$Env:UNITTEST_NUM.log | Where-Object {$_ -match 'shutdown_state_check'} > grep$Env:UNITTEST_NUM.log


check

pass
