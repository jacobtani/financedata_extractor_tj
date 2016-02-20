module MiniTest::Assertions

  # Fails unless 'exp' and 'act' are both arrays and contain the same elements.
  # Example: assert_matched_arrays [3,2,1], [1,2,3]
  #
  def assert_matched_arrays exp, act
    exp_ary = (exp || []).to_ary
    assert_kind_of Array, exp_ary

    act_ary = (act || []).to_ary
    assert_kind_of Array, act_ary

    assert_equal exp_ary.sort, act_ary.sort
  end
end

module MiniTest::Expectations

  # See MiniTest::Assertions#assert_matched_arrays
  # Example: [1,2,3].must_match_array [3,2,1]
  #
  infect_an_assertion :assert_matched_arrays, :must_match_array
end