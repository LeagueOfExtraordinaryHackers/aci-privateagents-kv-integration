#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
# load 'test_helper'

profile_script="./create_vg.sh"


@test "test global ORG var is set" {
      source ${profile_script}
      run echo $ORG
      assert_output "https://dev.azure.com/cavertes"
}

@test "test global PROJECT var is set" {
      source ${profile_script}
      run echo $PROJECT
      assert_output "VW_Sharing"
}

@test "test global VG_NAME var is set" {
      source ${profile_script}
      run echo $VG_NAME
      assert_output "TFBackend"
}

@test "test vg_id() should successfull return a number" {
    source ${profile_script}
    run get_vg_id
    assert_success
    assert_output --regexp "^[0-9]+([.][0-9]+)?$"
}

@test "test run_main should be successfull " {
    source ${profile_script}

    run run_main
    assert_success
}


# @test "create_vg()_should_be_return_an_integer_value" {
#     source ./create_vg.sh
#     run create_vg
#     assert_output "11"
# }


