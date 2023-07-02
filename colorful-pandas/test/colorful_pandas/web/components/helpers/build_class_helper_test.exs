defmodule ColorfulPandas.Web.Components.Helpers.BuildClassHelperTest do
  use ExUnit.Case

  import ColorfulPandas.Web.Components.Helpers, only: [build_class: 1]

  describe "when given an empty list" do
    test "returns an empty string" do
      assert build_class([]) == ""
    end
  end

  describe "when given a list with only nil" do
    test "returns an empty string" do
      assert build_class([nil]) == ""
    end
  end

  describe "when given a list with a single string" do
    test "returns that string" do
      assert build_class(["bg-gray-50"]) == "bg-gray-50"
    end

    test "trims the string if it has whitespace as pre- or suffix" do
      assert build_class([" bg-gray-50"]) == "bg-gray-50"
      assert build_class(["bg-gray-50 "]) == "bg-gray-50"
      assert build_class([" bg-gray-50 "]) == "bg-gray-50"
    end
  end

  describe "when given a list of multiple strings" do
    test "joins the strings with a space" do
      assert build_class(["bg-gray-50", "text-red-50"]) == "bg-gray-50 text-red-50"
    end

    test "trims each string before joining" do
      assert build_class([" bg-gray-50", "text-red-50 "]) == "bg-gray-50 text-red-50"
    end
  end

  describe "when given a list that includes nil" do
    test "filters out the nil value before joining" do
      assert build_class(["bg-gray-50", nil, "text-red-50"]) == "bg-gray-50 text-red-50"
    end
  end

  describe "when given a list that includes empty string" do
    test "filters out the empty string value before joining" do
      assert build_class(["bg-gray-50", "", "text-red-50"]) == "bg-gray-50 text-red-50"
    end
  end
end
