#
# Copyright (c) 2017-2018 Andreasheumaier<andreas.heumaier@microsoft.vom>
#
# SPDX-License-Identifier: Apache-2.0
#
default: test

# This runs the whole test suite for this repo
test: bats

#  Run the shell tests
bats:
	(cd ./src/scripts && ./test/libs/bats/bin/bats ./test)
